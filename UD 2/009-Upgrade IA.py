#!/usr/bin/env python3
# Agenda de Clientes (SQLite, Identificador) – GUI completa con menús, diálogos modales y tabla interactiva

import sqlite3
import re
import csv
import webbrowser
import tkinter as tk
from tkinter import ttk, messagebox, filedialog

DB_PATH = "empresa.db"
EMAIL_RE = re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")

DDL_CLIENTES = """
CREATE TABLE IF NOT EXISTS clientes (
    Identificador INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    apellidos TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE
);
"""

# -------------------- Utilidades DB --------------------
def conectar():
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    return con

def init_db(con):
    with con:
        con.execute(DDL_CLIENTES)

def validar_email(email: str) -> bool:
    return bool(EMAIL_RE.match((email or "").strip()))

# -------------------- Diálogos modales --------------------
class ClienteDialog(tk.Toplevel):
    # Modo: "nuevo", "editar", "duplicar"
    def __init__(self, master, title="Cliente", datos=None, modo="nuevo"):
        super().__init__(master)
        self.title(title)
        self.transient(master)
        self.resizable(False, False)
        self.result = None

        frm = ttk.Frame(self, padding=14)
        frm.grid(row=0, column=0, sticky="nsew")
        frm.grid_columnconfigure(1, weight=1)

        ttk.Label(frm, text="Nombre:").grid(row=0, column=0, sticky="w", padx=(0,8), pady=6)
        self.ent_nombre = ttk.Entry(frm, width=32)
        self.ent_nombre.grid(row=0, column=1, sticky="ew", pady=6)

        ttk.Label(frm, text="Apellidos:").grid(row=1, column=0, sticky="w", padx=(0,8), pady=6)
        self.ent_apellidos = ttk.Entry(frm, width=32)
        self.ent_apellidos.grid(row=1, column=1, sticky="ew", pady=6)

        ttk.Label(frm, text="Email:").grid(row=2, column=0, sticky="w", padx=(0,8), pady=6)
        self.ent_email = ttk.Entry(frm, width=32)
        self.ent_email.grid(row=2, column=1, sticky="ew", pady=6)

        # Botones
        btns = ttk.Frame(frm)
        btns.grid(row=3, column=0, columnspan=2, sticky="ew", pady=(10,0))
        btns.grid_columnconfigure(0, weight=1)
        btns.grid_columnconfigure(1, weight=1)
        ttk.Button(btns, text="Cancelar", command=self._cancelar).grid(row=0, column=0, sticky="ew", padx=(0,6))
        ttk.Button(btns, text="Guardar", command=self._guardar).grid(row=0, column=1, sticky="ew", padx=(6,0))

        # Prefill
        if datos:
            self.ent_nombre.insert(0, datos.get("nombre",""))
            self.ent_apellidos.insert(0, datos.get("apellidos",""))
            email_prefill = datos.get("email","")
            if modo == "duplicar" and email_prefill:
                # Sugerir modificar email para respetar UNIQUE
                at = email_prefill.find("@")
                email_prefill = (email_prefill[:at] + "+copy" + email_prefill[at:]) if at != -1 else email_prefill + ".copy"
            self.ent_email.insert(0, email_prefill)

        self.bind("<Return>", lambda e: self._guardar())
        self.bind("<Escape>", lambda e: self._cancelar())

        self.protocol("WM_DELETE_WINDOW", self._cancelar)
        self.grab_set()
        self.ent_nombre.focus_set()

    def _guardar(self):
        nombre = self.ent_nombre.get().strip()
        apellidos = self.ent_apellidos.get().strip()
        email = self.ent_email.get().strip()
        if not nombre or not apellidos or not email:
            messagebox.showerror("Error", "Todos los campos son obligatorios.")
            return
        if not validar_email(email):
            messagebox.showerror("Error", "Email no válido.")
            return
        self.result = {"nombre": nombre, "apellidos": apellidos, "email": email}
        self.destroy()

    def _cancelar(self):
        self.result = None
        self.destroy()

class ImportDialog(tk.Toplevel):
    # Importar CSV simple: columnas Nombre,Apellidos,Email (cabecera opcional)
    def __init__(self, master):
        super().__init__(master)
        self.title("Importar desde CSV")
        self.transient(master)
        self.resizable(False, False)
        self.result = None

        frm = ttk.Frame(self, padding=14)
        frm.grid(row=0, column=0, sticky="nsew")
        frm.grid_columnconfigure(1, weight=1)

        ttk.Label(frm, text="Archivo CSV:").grid(row=0, column=0, sticky="w", padx=(0,8), pady=6)
        self.ent_path = ttk.Entry(frm, width=40)
        self.ent_path.grid(row=0, column=1, sticky="ew", pady=6)
        ttk.Button(frm, text="Explorar…", command=self._browse).grid(row=0, column=2, padx=(6,0))

        self.has_header = tk.BooleanVar(value=True)
        ttk.Checkbutton(frm, text="Primera fila es cabecera", variable=self.has_header).grid(row=1, column=1, sticky="w", pady=(0,8))

        btns = ttk.Frame(frm)
        btns.grid(row=2, column=0, columnspan=3, sticky="ew", pady=(10,0))
        btns.grid_columnconfigure(0, weight=1)
        btns.grid_columnconfigure(1, weight=1)
        ttk.Button(btns, text="Cancelar", command=self._cancelar).grid(row=0, column=0, sticky="ew", padx=(0,6))
        ttk.Button(btns, text="Importar", command=self._importar).grid(row=0, column=1, sticky="ew", padx=(6,0))

        self.bind("<Return>", lambda e: self._importar())
        self.bind("<Escape>", lambda e: self._cancelar())
        self.protocol("WM_DELETE_WINDOW", self._cancelar)
        self.grab_set()

    def _browse(self):
        path = filedialog.askopenfilename(title="Selecciona CSV", filetypes=[("CSV","*.csv"),("Todos","*.*")])
        if path:
            self.ent_path.delete(0, tk.END)
            self.ent_path.insert(0, path)

    def _importar(self):
        path = self.ent_path.get().strip()
        if not path:
            messagebox.showwarning("Aviso", "Selecciona un archivo CSV.")
            return
        self.result = {"path": path, "has_header": self.has_header.get()}
        self.destroy()

    def _cancelar(self):
        self.result = None
        self.destroy()

# -------------------- Aplicación principal --------------------
class App(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Agenda de Clientes • SQLite (Identificador)")
        self.geometry("1180x680")
        self.minsize(960, 560)

        # Estado
        self.con = conectar()
        init_db(self.con)
        self.sort_col = "Identificador"
        self.sort_desc = False
        self.filter_text = tk.StringVar(value="")
        self.filter_field = tk.StringVar(value="todos")

        # UI
        self._build_menubar()
        self._build_toolbar()
        self._build_main()
        self._build_status()
        self._bind_shortcuts()

        # Carga inicial
        self._load_data()

    # ---------- UI ----------
    def _build_menubar(self):
        menubar = tk.Menu(self)

        m_file = tk.Menu(menubar, tearoff=False)
        m_file.add_command(label="Nuevo… (Ctrl+N)", command=self.cmd_nuevo)
        m_file.add_command(label="Editar… (Ctrl+E)", command=self.cmd_editar)
        m_file.add_command(label="Duplicar… (Ctrl+D)", command=self.cmd_duplicar)
        m_file.add_separator()
        m_file.add_command(label="Eliminar (Supr)", command=self.cmd_eliminar)
        m_file.add_separator()
        m_file.add_command(label="Importar CSV…", command=self.cmd_importar)
        m_file.add_command(label="Exportar CSV…", command=self.cmd_exportar)
        m_file.add_separator()
        m_file.add_command(label="Salir", command=self.destroy)
        menubar.add_cascade(label="Archivo", menu=m_file)

        m_view = tk.Menu(menubar, tearoff=False)
        m_view.add_command(label="Refrescar (F5)", command=self._load_data)
        m_view.add_checkbutton(label="Mostrar búsqueda (Ctrl+F)", command=self._toggle_busqueda)
        menubar.add_cascade(label="Ver", menu=m_view)

        m_help = tk.Menu(menubar, tearoff=False)
        m_help.add_command(label="Acerca de", command=lambda: messagebox.showinfo(
            "Acerca de",
            "Agenda de Clientes con Tkinter y SQLite\nCRUD completo con menús, diálogos modales y tabla interactiva."
        ))
        menubar.add_cascade(label="Ayuda", menu=m_help)

        self.config(menu=menubar)

    def _build_toolbar(self):
        tb = ttk.Frame(self, padding=(8,6))
        tb.grid(row=0, column=0, sticky="ew")
        for c in range(10):
            tb.grid_columnconfigure(c, weight=0)
        tb.grid_columnconfigure(10, weight=1)

        ttk.Button(tb, text="Nuevo…", command=self.cmd_nuevo).grid(row=0, column=0, padx=(0,6))
        ttk.Button(tb, text="Editar…", command=self.cmd_editar).grid(row=0, column=1, padx=6)
        ttk.Button(tb, text="Duplicar…", command=self.cmd_duplicar).grid(row=0, column=2, padx=6)
        ttk.Button(tb, text="Eliminar", command=self.cmd_eliminar).grid(row=0, column=3, padx=6)
        ttk.Separator(tb, orient="vertical").grid(row=0, column=4, padx=8, sticky="ns")
        ttk.Button(tb, text="Importar CSV…", command=self.cmd_importar).grid(row=0, column=5, padx=6)
        ttk.Button(tb, text="Exportar CSV…", command=self.cmd_exportar).grid(row=0, column=6, padx=6)
        ttk.Separator(tb, orient="vertical").grid(row=0, column=7, padx=8, sticky="ns")

        # Búsqueda avanzada
        self.search_frame = ttk.Frame(tb)
        self.search_frame.grid(row=0, column=8, sticky="e", padx=(12,0))
        ttk.Label(self.search_frame, text="Buscar:").grid(row=0, column=0, padx=(0,6))
        self.ent_search = ttk.Entry(self.search_frame, textvariable=self.filter_text, width=24)
        self.ent_search.grid(row=0, column=1)
        ttk.Label(self.search_frame, text="en").grid(row=0, column=2, padx=6)
        self.cmb_field = ttk.Combobox(self.search_frame, state="readonly", width=12,
                                      values=["todos","Nombre","Apellidos","Email"])
        self.cmb_field.current(0)
        self.cmb_field.bind("<<ComboboxSelected>>", lambda e: self._apply_field())
        self.cmb_field.grid(row=0, column=3)
        ttk.Button(self.search_frame, text="Aplicar", command=self._load_data).grid(row=0, column=4, padx=(6,0))
        self.ent_search.bind("<Return>", lambda e: self._load_data())

    def _build_main(self):
        main = ttk.Frame(self, padding=8)
        main.grid(row=1, column=0, sticky="nsew")
        self.grid_rowconfigure(1, weight=1)
        self.grid_columnconfigure(0, weight=1)

        columns = ("Identificador", "Nombre", "Apellidos", "Email")
        self.tree = ttk.Treeview(main, columns=columns, show="headings", selectmode="browse")
        vsb = ttk.Scrollbar(main, orient="vertical", command=self.tree.yview)
        hsb = ttk.Scrollbar(main, orient="horizontal", command=self.tree.xview)
        self.tree.configure(yscroll=vsb.set, xscroll=hsb.set)

        # Encabezados con callback de ordenación
        self.tree.heading("Identificador", text="Identificador", command=lambda: self._sort_by("Identificador"))
        self.tree.heading("Nombre", text="Nombre", command=lambda: self._sort_by("nombre"))
        self.tree.heading("Apellidos", text="Apellidos", command=lambda: self._sort_by("apellidos"))
        self.tree.heading("Email", text="Email", command=lambda: self._sort_by("email"))

        self.tree.column("Identificador", width=140, anchor="w", stretch=False)
        self.tree.column("Nombre", width=240, anchor="w", stretch=True)
        self.tree.column("Apellidos", width=280, anchor="w", stretch=True)
        self.tree.column("Email", width=380, anchor="w", stretch=True)

        self.tree.grid(row=0, column=0, sticky="nsew")
        vsb.grid(row=0, column=1, sticky="ns")
        hsb.grid(row=1, column=0, sticky="ew")
        main.grid_rowconfigure(0, weight=1)
        main.grid_columnconfigure(0, weight=1)

        # Menú contextual
        self.ctx = tk.Menu(self, tearoff=False)
        self.ctx.add_command(label="Editar…", command=self.cmd_editar)
        self.ctx.add_command(label="Duplicar…", command=self.cmd_duplicar)
        self.ctx.add_command(label="Eliminar", command=self.cmd_eliminar)
        self.ctx.add_separator()
        self.ctx.add_command(label="Copiar email", command=self.cmd_copiar_email)
        self.ctx.add_command(label="Abrir correo", command=self.cmd_abrir_correo)

        self.tree.bind("<Button-3>", self._popup_ctx)
        self.tree.bind("<Double-1>", lambda e: self.cmd_editar())

    def _build_status(self):
        status = ttk.Frame(self)
        status.grid(row=2, column=0, sticky="ew")
        status.grid_columnconfigure(0, weight=1)
        self.status_label = ttk.Label(status, text="Listo", anchor="w")
        self.status_label.grid(row=0, column=0, sticky="ew")

    def _bind_shortcuts(self):
        self.bind("<Control-n>", lambda e: self.cmd_nuevo())
        self.bind("<Control-N>", lambda e: self.cmd_nuevo())
        self.bind("<Control-e>", lambda e: self.cmd_editar())
        self.bind("<Control-E>", lambda e: self.cmd_editar())
        self.bind("<Control-d>", lambda e: self.cmd_duplicar())
        self.bind("<Control-D>", lambda e: self.cmd_duplicar())
        self.bind("<Delete>",    lambda e: self.cmd_eliminar())
        self.bind("<F5>",        lambda e: self._load_data())
        self.bind("<Control-f>", lambda e: self._toggle_busqueda())
        self.bind("<Control-F>", lambda e: self._toggle_busqueda())

    # ---------- Helpers ----------
    def _set_status(self, text):
        self.status_label.configure(text=text)

    def _selected_row(self):
        sel = self.tree.selection()
        if not sel:
            return None
        v = self.tree.item(sel[0], "values")
        return {"Identificador": int(v[0]), "nombre": v[1], "apellidos": v[2], "email": v[3]}

    def _popup_ctx(self, event):
        try:
            row_id = self.tree.identify_row(event.y)
            if row_id:
                self.tree.selection_set(row_id)
            self.ctx.tk_popup(event.x_root, event.y_root)
        finally:
            self.ctx.grab_release()

    def _toggle_busqueda(self):
        if self.search_frame.winfo_ismapped():
            self.search_frame.grid_remove()
        else:
            self.search_frame.grid()
            self.ent_search.focus_set()

    def _apply_field(self):
        self.filter_field.set(self.cmb_field.get())
        self._load_data()

    # ---------- Datos / Orden ----------
    def _load_data(self):
        # Col mapa seguro
        allowed = {"Identificador":"Identificador","nombre":"nombre","apellidos":"apellidos","email":"email"}
        order_col = allowed.get(self.sort_col, "Identificador")
        order_dir = "DESC" if self.sort_desc else "ASC"

        filtro = self.filter_text.get().strip()
        campo = self.filter_field.get()
        params = ()
        where = ""
        if filtro:
            like = f"%{filtro}%"
            if campo == "Nombre":
                where = "WHERE nombre LIKE ?"
                params = (like,)
            elif campo == "Apellidos":
                where = "WHERE apellidos LIKE ?"
                params = (like,)
            elif campo == "Email":
                where = "WHERE email LIKE ?"
                params = (like,)
            else:
                where = "WHERE nombre LIKE ? OR apellidos LIKE ? OR email LIKE ?"
                params = (like, like, like)

        sql = f"""
            SELECT Identificador, nombre, apellidos, email
            FROM clientes
            {where}
            ORDER BY {order_col} {order_dir}
        """
        filas = self.con.execute(sql, params).fetchall()

        # Poblar
        for it in self.tree.get_children():
            self.tree.delete(it)
        for idx, r in enumerate(filas):
            tag = "even" if idx % 2 == 0 else "odd"
            self.tree.insert("", "end", values=(r["Identificador"], r["nombre"], r["apellidos"], r["email"]), tags=(tag,))

        # Flechas en encabezados
        self._update_headings_arrows()
        self._set_status(f"{len(filas)} clientes")

    def _update_headings_arrows(self):
        up = " ▲"
        down = " ▼"
        heads = {
            "Identificador": ("Identificador", "Identificador"),
            "nombre": ("Nombre", "nombre"),
            "apellidos": ("Apellidos", "apellidos"),
            "email": ("Email", "email")
        }
        for heading, (label, colkey) in heads.items():
            arrow = ""
            if self.sort_col == colkey:
                arrow = down if self.sort_desc else up
            self.tree.heading(heading, text=label + arrow)

    def _sort_by(self, col):
        if self.sort_col == col:
            self.sort_desc = not self.sort_desc
        else:
            self.sort_col = col
            self.sort_desc = False
        self._load_data()

    # ---------- Comandos ----------
    def cmd_nuevo(self):
        dlg = ClienteDialog(self, title="Nuevo cliente", modo="nuevo")
        self.wait_window(dlg)  # modal
        if dlg.result:
            try:
                with self.con:
                    cur = self.con.execute(
                        "INSERT INTO clientes (nombre, apellidos, email) VALUES (?, ?, ?)",
                        (dlg.result["nombre"], dlg.result["apellidos"], dlg.result["email"])
                    )
                self._set_status(f"Cliente creado (ID {cur.lastrowid})")
                self._load_data()
            except sqlite3.IntegrityError as e:
                messagebox.showerror("Integridad", f"No se pudo crear: {e}")

    def cmd_editar(self):
        row = self._selected_row()
        if not row:
            messagebox.showwarning("Aviso", "Selecciona un cliente primero.")
            return
        dlg = ClienteDialog(self, title=f"Editar cliente [{row['Identificador']}]", datos=row, modo="editar")
        self.wait_window(dlg)
        if dlg.result:
            try:
                with self.con:
                    cur = self.con.execute(
                        "UPDATE clientes SET nombre = ?, apellidos = ?, email = ? WHERE Identificador = ?",
                        (dlg.result["nombre"], dlg.result["apellidos"], dlg.result["email"], row["Identificador"])
                    )
                if cur.rowcount == 0:
                    self._set_status("No se actualizó ningún registro")
                else:
                    self._set_status("Cliente actualizado")
                self._load_data()
            except sqlite3.IntegrityError as e:
                messagebox.showerror("Integridad", f"No se pudo actualizar: {e}")

    def cmd_duplicar(self):
        row = self._selected_row()
        if not row:
            messagebox.showwarning("Aviso", "Selecciona un cliente primero.")
            return
        dlg = ClienteDialog(self, title=f"Duplicar cliente [{row['Identificador']}]", datos=row, modo="duplicar")
        self.wait_window(dlg)
        if dlg.result:
            try:
                with self.con:
                    cur = self.con.execute(
                        "INSERT INTO clientes (nombre, apellidos, email) VALUES (?, ?, ?)",
                        (dlg.result["nombre"], dlg.result["apellidos"], dlg.result["email"])
                    )
                self._set_status(f"Cliente duplicado (ID {cur.lastrowid})")
                self._load_data()
            except sqlite3.IntegrityError as e:
                messagebox.showerror("Integridad", f"No se pudo duplicar: {e}")

    def cmd_eliminar(self):
        row = self._selected_row()
        if not row:
            messagebox.showwarning("Aviso", "Selecciona un cliente primero.")
            return
        if not messagebox.askyesno("Confirmar", f"¿Eliminar [{row['Identificador']}] {row['nombre']} {row['apellidos']}?"):
            return
        with self.con:
            cur = self.con.execute("DELETE FROM clientes WHERE Identificador = ?", (row["Identificador"],))
        if cur.rowcount == 0:
            self._set_status("No se eliminó ningún registro")
        else:
            self._set_status("Cliente eliminado")
        self._load_data()

    def cmd_importar(self):
        dlg = ImportDialog(self)
        self.wait_window(dlg)
        if not dlg.result:
            return
        path = dlg.result["path"]
        has_header = dlg.result["has_header"]
        insertados = 0
        duplicados = 0
        try:
            with open(path, newline="", encoding="utf-8") as f, self.con:
                reader = csv.reader(f)
                if has_header:
                    next(reader, None)
                for row in reader:
                    if len(row) < 3:
                        continue
                    nombre, apellidos, email = row[0].strip(), row[1].strip(), row[2].strip()
                    if not (nombre and apellidos and validar_email(email)):
                        continue
                    try:
                        self.con.execute(
                            "INSERT INTO clientes (nombre, apellidos, email) VALUES (?, ?, ?)",
                            (nombre, apellidos, email)
                        )
                        insertados += 1
                    except sqlite3.IntegrityError:
                        duplicados += 1
            self._set_status(f"Importados: {insertados}, duplicados: {duplicados}")
            self._load_data()
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo importar: {e}")

    def cmd_exportar(self):
        path = filedialog.asksaveasfilename(defaultextension=".csv", filetypes=[("CSV","*.csv")], title="Exportar a CSV")
        if not path:
            return
        filas = self.con.execute("SELECT Identificador, nombre, apellidos, email FROM clientes ORDER BY Identificador").fetchall()
        try:
            with open(path, "w", newline="", encoding="utf-8") as f:
                w = csv.writer(f)
                w.writerow(["Identificador","Nombre","Apellidos","Email"])
                for r in filas:
                    w.writerow([r["Identificador"], r["nombre"], r["apellidos"], r["email"]])
            self._set_status(f"Exportado: {path}")
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo exportar: {e}")

    def cmd_copiar_email(self):
        row = self._selected_row()
        if not row:
            return
        self.clipboard_clear()
        self.clipboard_append(row["email"])
        self._set_status(f"Email copiado: {row['email']}")

    def cmd_abrir_correo(self):
        row = self._selected_row()
        if not row:
            return
        try:
            webbrowser.open(f"mailto:{row['email']}", new=1)
            self._set_status(f"Abrir correo: {row['email']}")
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo abrir el cliente de correo: {e}")

if __name__ == "__main__":
    app = App()
    app.mainloop()

