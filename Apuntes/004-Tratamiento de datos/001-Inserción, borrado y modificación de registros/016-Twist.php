<?php
session_start();

// --- CONFIGURACIÓN ---
if (!isset($_SESSION['db_file'])) {
    $_SESSION['db_file'] = sys_get_temp_dir() . '/temp_db_' . session_id() . '.sqlite';
}
$dbFile = $_SESSION['db_file'];
if (!isset($_SESSION['history'])) $_SESSION['history'] = [];
if (!isset($_SESSION['mode'])) $_SESSION['mode'] = 'sql'; 

// --- PROCESADOR ---
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = "";
    $isScript = false;

    if (!empty($_POST['script'])) {
        $input = $_POST['script'];
        $isScript = true;
    } elseif (!empty($_POST['command'])) {
        $input = trim($_POST['command']);
    }

    $output = "";
    $currentMode = $_SESSION['mode']; 
    $displayPrompt = ($currentMode === 'sql') ? 'user@dam:~$ ' : '>>> ';

    if (!empty($input)) {
        if ($input === 'clear') {
            if (file_exists($dbFile)) unlink($dbFile);
            $_SESSION['history'] = [];
            $_SESSION['db_file'] = sys_get_temp_dir() . '/temp_db_' . session_id() . '.sqlite';
            $_SESSION['mode'] = 'sql';
        }
        elseif ($currentMode === 'sql' && $input === 'python3') {
            $_SESSION['mode'] = 'python';
            $output = "Python 3. Interactive Mode.";
        }
        elseif ($currentMode === 'python' && trim($input) === 'exit()') {
            $_SESSION['mode'] = 'sql';
            $output = "Volviendo a SQL...";
        }
        elseif ($currentMode === 'python') {
            $file = tempnam(sys_get_temp_dir(), 'py_script');
            file_put_contents($file, $input);
            // Ejecutamos Python. Timeout de 4s para evitar cuelgues.
            $output = shell_exec("timeout 4s python3 $file 2>&1");
            unlink($file);
            
            if ($output === null) $output = "Error: Timeout (Posible bucle infinito o input() esperando).";
        }
        else {
            // SQL Logic
            try {
                $pdo = new PDO("sqlite:$dbFile");
                $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
                if ($isScript) {
                     $pdo->exec($input);
                     $output = "Script SQL ejecutado correctamente.";
                } else {
                    if (stripos($input, 'SELECT') === 0 || stripos($input, 'PRAGMA') === 0) {
                        $stmt = $pdo->query($input);
                        $res = $stmt->fetchAll(PDO::FETCH_ASSOC);
                        $output = json_encode($res, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
                    } else {
                        $pdo->exec($input);
                        $output = "Query OK.";
                    }
                }
            } catch (Exception $e) {
                $output = "Error SQL: " . $e->getMessage();
            }
        }

        if ($input !== 'clear') {
            $displayCmd = $isScript ? "[SCRIPT BLOQUE] " . substr($input, 0, 25) . "..." : $input;
            $_SESSION['history'][] = ['prompt' => $displayPrompt, 'cmd' => $displayCmd, 'out' => $output];
        }
    }
}
$currentPrompt = ($_SESSION['mode'] === 'python') ? '>>> ' : 'user@dam:~$ ';
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Terminal DAM</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <style>
        body { background-color: #121212; color: #e0e0e0; font-family: 'Consolas', 'Courier New', monospace; padding: 20px; font-size: 14px; }
        .container { max-width: 900px; margin: 0 auto; }
        
        /* Terminal */
        #terminal { background: #000; padding: 20px; border-radius: 8px 8px 0 0; min-height: 450px; border: 1px solid #333; }
        .prompt-sql { color: #4ec9b0; font-weight: bold; }
        .prompt-py { color: #ffd700; font-weight: bold; }
        .output { color: #aaa; white-space: pre-wrap; margin-bottom: 10px; margin-left: 15px; border-left: 2px solid #333; padding-left: 10px; }
        
        /* Inputs */
        input { background: transparent; border: none; color: #fff; font-family: inherit; font-size: inherit; outline: none; width: 80%; }
        #editor-container { display: none; margin-top: 10px; border-top: 1px dashed #555; padding-top: 10px; }
        textarea { width: 100%; height: 150px; background: #111; color: #0f0; border: 1px solid #333; padding: 5px; font-family: inherit; resize: vertical; outline: none; }
        
        /* Instrucciones (Footer) */
        .instructions { background: #1e1e1e; border: 1px solid #333; border-top: none; padding: 15px; border-radius: 0 0 8px 8px; display: grid; grid-template-columns: 1fr 1fr; gap: 20px; font-size: 13px; color: #999; }
        .inst-block h4 { color: #fff; margin: 0 0 8px 0; border-bottom: 1px solid #444; padding-bottom: 4px; }
        .inst-item { margin-bottom: 5px; line-height: 1.4; }
        .key { background: #333; color: #fff; padding: 2px 6px; border-radius: 4px; font-size: 11px; margin-right: 5px; border: 1px solid #444; }
        .warn { color: #ff6b6b; font-weight: bold; }

        /* Botones */
        .toolbar { text-align: right; margin-bottom: 5px; }
        .btn { background: #333; color: #fff; border: 1px solid #555; padding: 6px 12px; cursor: pointer; border-radius: 3px; font-size: 12px; }
        .btn:hover { background: #444; }
        .btn-blue { background: #0078d4; border-color: #0078d4; }
    </style>
</head>
<body>

<div class="container">
    <div class="toolbar">
        <button onclick="toggleEditor()" class="btn">📝 Editor Bloque</button>
        <button onclick="generarPDF()" class="btn">📄 Guardar PDF</button>
    </div>

    <div id="terminal">
        <div id="content-to-print">
            <?php foreach ($_SESSION['history'] as $h): ?>
                <div>
                    <span class="<?php echo str_contains($h['prompt'], '>>>') ? 'prompt-py' : 'prompt-sql'; ?>">
                        <?php echo $h['prompt']; ?>
                    </span>
                    <span><?php echo htmlspecialchars($h['cmd']); ?></span>
                </div>
                <?php if(!empty($h['out'])): ?>
                    <div class="output"><?php echo htmlspecialchars($h['out']); ?></div>
                <?php endif; ?>
            <?php endforeach; ?>
        </div>

        <form method="POST" id="form-line">
            <div style="margin-top: 10px;">
                <span class="<?php echo ($_SESSION['mode'] === 'python') ? 'prompt-py' : 'prompt-sql'; ?>">
                    <?php echo $currentPrompt; ?>
                </span>
                <input type="text" name="command" id="cmdInput" autofocus autocomplete="off">
            </div>
            <button type="submit" style="display:none;"></button>
        </form>

        <form method="POST" id="editor-container">
            <div style="margin-bottom:5px; color:#aaa;">Pega aquí tu script completo:</div>
            <textarea name="script" id="scriptArea" spellcheck="false"></textarea>
            <div style="text-align:right; margin-top:5px;">
                <button type="submit" class="btn btn-blue">Ejecutar Script</button>
            </div>
        </form>
    </div>

    <div class="instructions">
        <div class="inst-block">
            <h4>⌨️ Comandos</h4>
            <div class="inst-item"><span class="key">python3</span> Cambia a modo Python (Prompt amarillo).</div>
            <div class="inst-item"><span class="key">exit()</span> Sale de Python y vuelve a SQL.</div>
            <div class="inst-item"><span class="key">clear</span> Limpia pantalla y borra la Base de Datos.</div>
        </div>
        <div class="inst-block">
            <h4>⚠️ Reglas Importantes</h4>
            <div class="inst-item">• <span class="warn">NO USAR input()</span>: La web se colgará o dará <code>EOFError</code>. Usa variables fijas.</div>
            <div class="inst-item">• <span class="warn">NO USAR while True</span>: Scripts infinitos darán error de Timeout.</div>
            <div class="inst-item">• SQL usa SQLite temporal (se borra al salir).</div>
        </div>
    </div>
</div>

<script>
    window.scrollTo(0, document.body.scrollHeight);

    function toggleEditor() {
        var editor = document.getElementById('editor-container');
        var lineForm = document.getElementById('form-line');
        if (editor.style.display === 'block') {
            editor.style.display = 'none';
            lineForm.style.display = 'block';
            document.getElementById('cmdInput').focus();
        } else {
            editor.style.display = 'block';
            lineForm.style.display = 'none';
            document.getElementById('scriptArea').focus();
        }
    }

    function generarPDF() {
        const element = document.getElementById('content-to-print');
        html2pdf().from(element).save('terminal_log.pdf');
    }
</script>
</body>
</html>
