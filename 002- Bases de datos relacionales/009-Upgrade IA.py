#!/usr/bin/env python3
import sys
import re
import csv
import webbrowser

from PySide6.QtWidgets import (
    QApplication, QMainWindow, QTableView, QToolBar, QMessageBox,
    QLineEdit, QLabel, QComboBox, QWidget, QHBoxLayout, QVBoxLayout,
    QDialog, QFormLayout, QDialogButtonBox, QFileDialog, QStyle
)
from PySide6.QtGui import QAction, QIcon, QKeySequence
from PySide6.QtCore import Qt, QSortFilterProxyModel, QRegularExpression
from PySide6.QtSql import QSqlDatabase, QSqlTableModel, QSqlQuery

EMAIL_REGEX = re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")
DB_NAME = "empresa.db"

class ClienteDialog(QDialog):
    def __init__(self, parent=None, record=None, modo="Nuevo"):
        super().__init__(parent)
        self.setWindowTitle(f"{modo} cliente")
        self.record = record
        self._build_ui(modo)

    def _build_ui(self, modo):
        layout = QFormLayout(self)

        self.ent_nombre = QLineEdit()
        self.ent_apellidos = QLineEdit()
        self.ent_email = QLineEdit()

        if self.record:
            self.ent_nombre.setText(self.record.value("nombre"))
            self.ent_apellidos.setText(self.record.value("apellidos"))
            email_val = self.record.value("email") or ""
            if modo == "Duplicar" and email_val:
                at = email_val.find("@")
                email_val = (email_val[:at] + "+copy" + email_val[at:]) if at != -1 else email_val + ".copy"
            self.ent_email.setText(email_val)

        layout.addRow("Nombre:", self.ent_nombre)
        layout.addRow("Apellidos:", self.ent_apellidos)
        layout.addRow("Email:", self.ent_email)

        btns = QDialogButtonBox(QDialogButtonBox.Save | QDialogButtonBox.Cancel)
        btns.accepted.connect(self.accept)
        btns.rejected.connect(self.reject)
        layout.addRow(btns)

    def get_data(self):
        return {
            "nombre": self.ent_nombre.text().strip(),
            "apellidos": self.ent_apellidos.text().strip(),
            "email": self.ent_email.text().strip(),
        }

    def validate(self):
        data = self.get_data()
        if not data["nombre"] or not data["apellidos"] or not data["email"]:
            QMessageBox.warning(self, "Validación", "Todos los campos son obligatorios.")
            return False
        if not EMAIL_REGEX.match(data["email"]):
            QMessageBox.warning(self, "Validación", "Email no válido.")
            return False
        return True

    def accept(self):
        if self.validate():
            super().accept()

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Agenda de Clientes • PySide6 (claro)")
        self.resize(1024, 600)

        self._create_connection()
        self._create_model()
        self._create_proxy()
        self._build_ui()
        self._create_actions()
        self._create_menus()
        self._create_toolbar()
        self._connect_signals()
        self._status("Listo")

    # ---------- DB / Modelo ----------
    def _create_connection(self):
        self.db = QSqlDatabase.addDatabase("QSQLITE")
        self.db.setDatabaseName(DB_NAME)
        if not self.db.open():
            QMessageBox.critical(self, "DB", "No se pudo abrir la base de datos.")
            sys.exit(1)
        q = QSqlQuery(self.db)
        ok = q.exec(
            """
            CREATE TABLE IF NOT EXISTS clientes (
                Identificador INTEGER PRIMARY KEY AUTOINCREMENT,
                nombre TEXT NOT NULL,
                apellidos TEXT NOT NULL,
                email TEXT NOT NULL UNIQUE
            )
            """
        )
        if not ok:
            QMessageBox.critical(self, "DB", f"Error creando tabla: {q.lastError().text()}")
            sys.exit(1)

    def _create_model(self):
        self.model = QSqlTableModel(self, self.db)
        self.model.setTable("clientes")
        self.model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        self.model.select()
        self.model.setHeaderData(self.model.fieldIndex("Identificador"), Qt.Horizontal, "ID")
        self.model.setHeaderData(self.model.fieldIndex("nombre"), Qt.Horizontal, "Nombre")
        self.model.setHeaderData(self.model.fieldIndex("apellidos"), Qt.Horizontal, "Apellidos")
        self.model.setHeaderData(self.model.fieldIndex("email"), Qt.Horizontal, "Email")

    def _create_proxy(self):
        self.proxy = QSortFilterProxyModel(self)
        self.proxy.setSourceModel(self.model)
        self.proxy.setFilterCaseSensitivity(Qt.CaseInsensitive)
        self.proxy.setFilterKeyColumn(-1)

    # ---------- UI ----------
    def _build_ui(self):
        # Filtro superior
        self.edit_filter = QLineEdit()
        self.combo_field = QComboBox()
        self.combo_field.addItems(["Todos", "Nombre", "Apellidos", "Email"])

        filter_bar = QHBoxLayout()
        filter_bar.addWidget(QLabel("Buscar:"))
        filter_bar.addWidget(self.edit_filter)
        filter_bar.addWidget(self.combo_field)

        # Tabla
        self.view = QTableView()
        self.view.setModel(self.proxy)
        self.view.setSelectionBehavior(QTableView.SelectRows)
        self.view.setSelectionMode(QTableView.SingleSelection)
        self.view.setSortingEnabled(True)
        self.view.sortByColumn(self.model.fieldIndex("Identificador"), Qt.AscendingOrder)
        self.view.setAlternatingRowColors(True)
        self.view.setEditTriggers(QTableView.NoEditTriggers)

        layout = QVBoxLayout()
        layout.addLayout(filter_bar)
        layout.addWidget(self.view)

        container = QWidget()
        container.setLayout(layout)
        self.setCentralWidget(container)

        # Estilo claro simple sin manipular QPalette avanzado (evita errores en Qt 6)
        self.setStyleSheet("""
            QTableView { gridline-color: #cccccc; }
            QHeaderView::section { background: #f5f5f5; padding: 6px; border: 1px solid #dddddd; }
            QLineEdit { padding: 4px; }
        """)

    # ---------- Acciones / Menús / Toolbar ----------
    def _create_actions(self):
        style = self.style()

        self.act_new = QAction(style.standardIcon(QStyle.SP_FileIcon), "Nuevo", self)
        self.act_new.setShortcut(QKeySequence("Ctrl+N"))

        self.act_edit = QAction(style.standardIcon(QStyle.SP_DialogOpenButton), "Editar", self)
        self.act_edit.setShortcut(QKeySequence("Ctrl+E"))

        self.act_dup = QAction(style.standardIcon(QStyle.SP_ArrowRight), "Duplicar", self)
        self.act_dup.setShortcut(QKeySequence("Ctrl+D"))

        self.act_del = QAction(style.standardIcon(QStyle.SP_TrashIcon), "Eliminar", self)
        self.act_del.setShortcut(QKeySequence("Delete"))

        self.act_imp = QAction(style.standardIcon(QStyle.SP_DialogOpenButton), "Importar CSV", self)

        self.act_exp = QAction(style.standardIcon(QStyle.SP_DialogSaveButton), "Exportar CSV", self)

        self.act_copy = QAction(style.standardIcon(QStyle.SP_DialogYesButton), "Copiar email", self)
        self.act_open = QAction(style.standardIcon(QStyle.SP_DesktopIcon), "Abrir correo", self)

        self.act_exit = QAction("Salir", self)
        self.act_exit.setShortcut(QKeySequence("Ctrl+Q"))

        self.act_about = QAction("Acerca de", self)
        self.act_about.setShortcut(QKeySequence("F1"))

    def _create_menus(self):
        mb = self.menuBar()
        m_file = mb.addMenu("Archivo")
        m_file.addAction(self.act_new)
        m_file.addAction(self.act_edit)
        m_file.addAction(self.act_dup)
        m_file.addSeparator()
        m_file.addAction(self.act_del)
        m_file.addSeparator()
        m_file.addAction(self.act_imp)
        m_file.addAction(self.act_exp)
        m_file.addSeparator()
        m_file.addAction(self.act_exit)

        m_edit = mb.addMenu("Editar")
        m_edit.addAction(self.act_copy)
        m_edit.addAction(self.act_open)

        m_help = mb.addMenu("Ayuda")
        m_help.addAction(self.act_about)

    def _create_toolbar(self):
        tb = QToolBar("Acciones")
        self.addToolBar(tb)
        tb.addAction(self.act_new)
        tb.addAction(self.act_edit)
        tb.addAction(self.act_dup)
        tb.addAction(self.act_del)
        tb.addSeparator()
        tb.addAction(self.act_imp)
        tb.addAction(self.act_exp)
        tb.addSeparator()
        tb.addAction(self.act_copy)
        tb.addAction(self.act_open)

    def _connect_signals(self):
        # Acciones
        self.act_new.triggered.connect(self.cmd_new)
        self.act_edit.triggered.connect(self.cmd_edit)
        self.act_dup.triggered.connect(self.cmd_dup)
        self.act_del.triggered.connect(self.cmd_del)
        self.act_imp.triggered.connect(self.cmd_import_csv)
        self.act_exp.triggered.connect(self.cmd_export_csv)
        self.act_copy.triggered.connect(self.cmd_copy_email)
        self.act_open.triggered.connect(self.cmd_open_email)
        self.act_exit.triggered.connect(self.close)
        self.act_about.triggered.connect(lambda: QMessageBox.information(self, "Acerca de", "Agenda de Clientes (PySide6) – Interfaz clara y moderna."))

        # Filtro
        self.edit_filter.textChanged.connect(self._apply_filter)
        self.combo_field.currentIndexChanged.connect(self._apply_filter)

        # Interacción tabla
        self.view.doubleClicked.connect(lambda: self.cmd_edit())

    # ---------- Utilidades ----------
    def _status(self, msg):
        self.statusBar().showMessage(msg, 4000)

    def _selected_source_row(self):
        idx = self.view.currentIndex()
        if not idx.isValid():
            return None
        return self.proxy.mapToSource(idx).row()

    def _apply_filter(self):
        text = self.edit_filter.text()
        column = self.combo_field.currentText()
        regex = QRegularExpression(QRegularExpression.escape(text), QRegularExpression.CaseInsensitiveOption)
        if column == "Todos":
            self.proxy.setFilterKeyColumn(-1)
        else:
            field = column.lower()
            self.proxy.setFilterKeyColumn(self.model.fieldIndex(field))
        self.proxy.setFilterRegularExpression(regex)

    # ---------- Comandos ----------
    def cmd_new(self):
        dlg = ClienteDialog(self, modo="Nuevo")
        if dlg.exec():
            data = dlg.get_data()
            rec = self.model.record()
            rec.setValue("nombre", data["nombre"])
            rec.setValue("apellidos", data["apellidos"])
            rec.setValue("email", data["email"])
            if not self.model.insertRecord(-1, rec):
                QMessageBox.critical(self, "Error", self.model.lastError().text())
            else:
                self.model.submitAll()
                self.model.select()
                self._status("Cliente creado.")

    def cmd_edit(self):
        row = self._selected_source_row()
        if row is None:
            QMessageBox.warning(self, "Editar", "Selecciona un registro primero.")
            return
        rec = self.model.record(row)
        dlg = ClienteDialog(self, record=rec, modo="Editar")
        if dlg.exec():
            data = dlg.get_data()
            self.model.setData(self.model.index(row, self.model.fieldIndex("nombre")), data["nombre"])
            self.model.setData(self.model.index(row, self.model.fieldIndex("apellidos")), data["apellidos"])
            self.model.setData(self.model.index(row, self.model.fieldIndex("email")), data["email"])
            if not self.model.submitAll():
                QMessageBox.critical(self, "Error", self.model.lastError().text())
            else:
                self.model.select()
                self._status("Cliente actualizado.")

    def cmd_dup(self):
        row = self._selected_source_row()
        if row is None:
            QMessageBox.warning(self, "Duplicar", "Selecciona un registro primero.")
            return
        rec = self.model.record(row)
        dlg = ClienteDialog(self, record=rec, modo="Duplicar")
        if dlg.exec():
            data = dlg.get_data()
            newrec = self.model.record()
            newrec.setValue("nombre", data["nombre"])
            newrec.setValue("apellidos", data["apellidos"])
            newrec.setValue("email", data["email"])
            if not self.model.insertRecord(-1, newrec):
                QMessageBox.critical(self, "Error", self.model.lastError().text())
            else:
                self.model.submitAll()
                self.model.select()
                self._status("Cliente duplicado.")

    def cmd_del(self):
        row = self._selected_source_row()
        if row is None:
            QMessageBox.warning(self, "Eliminar", "Selecciona un registro primero.")
            return
        rec = self.model.record(row)
        if QMessageBox.question(self, "Eliminar",
                                f"¿Eliminar '{rec.value('nombre')} {rec.value('apellidos')}'?") == QMessageBox.Yes:
            if not self.model.removeRow(row):
                QMessageBox.critical(self, "Error", self.model.lastError().text())
            else:
                if not self.model.submitAll():
                    QMessageBox.critical(self, "Error", self.model.lastError().text())
                self.model.select()
                self._status("Cliente eliminado.")

    def cmd_import_csv(self):
        path, _ = QFileDialog.getOpenFileName(self, "Importar CSV", "", "CSV (*.csv);;Todos (*)")
        if not path:
            return
        inserted, dup = 0, 0
        q = QSqlQuery(self.db)
        q.prepare("INSERT INTO clientes (nombre, apellidos, email) VALUES (?, ?, ?)")
        try:
            with open(path, newline="", encoding="utf-8") as f:
                reader = csv.reader(f)
                # Detectar cabecera por contenido simple (si primera fila contiene 'nombre')
                first = next(reader, None)
                if first and any(h.lower() in ("nombre", "apellidos", "email") for h in first):
                    pass  # ya consumida cabecera
                else:
                    if first:
                        # no era cabecera, procesar como fila
                        row = first
                        if len(row) >= 3:
                            q.addBindValue(row[0].strip())
                            q.addBindValue(row[1].strip())
                            q.addBindValue(row[2].strip())
                            if q.exec():
                                inserted += 1
                            else:
                                dup += 1
                for row in reader:
                    if len(row) < 3:
                        continue
                    q.addBindValue(row[0].strip())
                    q.addBindValue(row[1].strip())
                    q.addBindValue(row[2].strip())
                    if q.exec():
                        inserted += 1
                    else:
                        dup += 1
            self.model.select()
            QMessageBox.information(self, "Importación", f"Insertados: {inserted}\nDuplicados: {dup}")
            self._status("Importación finalizada.")
        except Exception as e:
            QMessageBox.critical(self, "Error", f"No se pudo importar: {e}")

    def cmd_export_csv(self):
        path, _ = QFileDialog.getSaveFileName(self, "Exportar CSV", "clientes.csv", "CSV (*.csv);;Todos (*)")
        if not path:
            return
        try:
            with open(path, "w", newline="", encoding="utf-8") as f:
                w = csv.writer(f)
                w.writerow(["Identificador", "Nombre", "Apellidos", "Email"])
                for r in range(self.model.rowCount()):
                    rec = self.model.record(r)
                    w.writerow([
                        rec.value("Identificador"),
                        rec.value("nombre"),
                        rec.value("apellidos"),
                        rec.value("email"),
                    ])
            QMessageBox.information(self, "Exportar", f"Archivo guardado en: {path}")
            self._status("Exportación finalizada.")
        except Exception as e:
            QMessageBox.critical(self, "Error", f"No se pudo exportar: {e}")

    def cmd_copy_email(self):
        row = self._selected_source_row()
        if row is None:
            return
        rec = self.model.record(row)
        email = rec.value("email") or ""
        QApplication.clipboard().setText(email)
        self._status(f"Email copiado: {email}")

    def cmd_open_email(self):
        row = self._selected_source_row()
        if row is None:
            return
        rec = self.model.record(row)
        email = rec.value("email") or ""
        if email:
            webbrowser.open(f"mailto:{email}")
            self._status(f"Abrir correo: {email}")

if __name__ == "__main__":
    app = QApplication(sys.argv)
    win = MainWindow()
    win.show()
    sys.exit(app.exec())

