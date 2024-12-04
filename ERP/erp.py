import sys
import mysql.connector
from PyQt5.QtWidgets import QApplication, QMainWindow
from PyQt5.QtCore import QPropertyAnimation
from PyQt5 import QtCore, QtWidgets
from PyQt5.uic import loadUi
from enlace_sql import Conexion


class MyGUI(QMainWindow):
    def __init__(self):
        super(MyGUI, self).__init__()
        # Carga la interfaz desde el archivo .ui
        loadUi("gui_erp.ui", self)

        self.bt_menu.clicked.connect(self.mover_menu)

        # clase conexion mysql
        self.base_datos = Conexion()

        # ocultamos los botones
        self.bt_restaurar.hide()

        # Diccionario para mapear botones, nombres de tablas y widgets de tablas
        refrescar_config = {
            # Finanzas
            self.bt_refrescar_cuentas: ("Cuentas", self.table_cuentas),
            self.bt_refrescar_transacciones: ("Transacciones", self.table_transacciones),
            # RRHH
            self.bt_refrescar_empleados: ("Empleados", self.table_empleados),
            self.bt_refrescar_asistencia: ("Asistencias", self.table_asistencia),
            self.bt_refrescar_nomina: ("Nomina", self.table_nomina),
            # Compras
            self.bt_refrescar_compraord: ("Ordenes_de_Compra", self.table_ordenescompra),
            self.bt_refrescar_detalles: ("Detalle_Orden_Compra", self.table_detalles),
            self.bt_refrescar_cuentaspagar: ("Cuentas_Por_Pagar", self.table_cuentaspagar),
            # Producción
            self.bt_refrescar_produccionord: ("Ordenes_de_Produccion", self.table_ordenesprod),
            self.bt_refrescar_material: ("Materiales", self.table_material),
            self.bt_refrescar_consumo: ("Consumo_Materiales", self.table_consumo),
            self.bt_refrescar_produccionempleados: ("Empleados_Produccion", self.table_empleadosprod),
            # Inventario
            self.bt_refrescar_producto: ("Productos", self.table_producto),
            self.bt_refrescar_entradas: ("Entradas", self.table_entradas),
            self.bt_refrescar_salidas: ("Salidas", self.table_salidas),
            self.bt_refrescar_proveedores: ("Proveedores", self.table_proveedores),
            # Ventas
            self.bt_refrescar_clientes: ("Clientes", self.table_clientes),
            self.bt_refrescar_ventaordenes: ("Ordenes_de_Venta", self.table_ordenesventa),
            self.bt_refrescar_ventasdetalle: ("Detalle_Orden_Venta", self.table_detalleventa),
            self.bt_refrescar_cuentascobrar: ("Cuentas_Por_Cobrar", self.table_cuentascobrar),
        }

        # Iterar sobre el diccionario y conectar los botones a sus funciones
        for boton, (nombre_tabla, tabla_widget) in refrescar_config.items():
            boton.clicked.connect(lambda _, nt=nombre_tabla, tw=tabla_widget: self.mostrar_datos(nt, tw))

        # control barra de titulos
        self.bt_minimizar.clicked.connect(self.control_bt_minimizar)
        self.bt_restaurar.clicked.connect(self.control_bt_normal)
        self.bt_maximizar.clicked.connect(self.control_bt_maximizar)
        self.bt_cerrar.clicked.connect(lambda: self.close())

        # eliminar barra y de titulo opacidad
        self.setWindowFlag(QtCore.Qt.FramelessWindowHint)
        self.setWindowOpacity(1)

        # SizeGrip
        self.gripSize = 10
        self.grip = QtWidgets.QSizeGrip(self)
        self.grip.resize(self.gripSize, self.gripSize)

        # mover ventana
        self.frame_superior.mouseMoveEvent = self.mover_ventana

        # Diccionario para asociar botones con páginas del stackedwidget
        self.navigation_map = {
            # Botones de finanzas
            self.bt_finanzas: self.page_finanzas,
            self.bt_cuentas: self.pfinanzas_cuentas,
            self.bt_back_cuentas: self.page_finanzas,
            self.bt_transacciones: self.pfinanzas_transacciones,
            self.bt_back_transacciones: self.page_finanzas,
            # Botones de rrhh
            self.bt_rrhh: self.page_rrhh,
            self.bt_asistencia: self.prrhh_asistencia,
            self.bt_back_asistencia: self.page_rrhh,
            self.bt_empleados: self.prrhh_empleados,
            self.bt_back_empleados: self.page_rrhh,
            self.bt_nomina: self.prrhh_nomina,
            self.bt_back_nomina: self.page_rrhh,
            # Botones de compras
            self.bt_compras: self.page_compras,
            self.bt_cuentaspagar: self.pcompras_cuentaspagar,
            self.bt_back_cuentaspagar: self.page_compras,
            self.bt_detalles: self.pcompras_detalles,
            self.bt_back_detalles: self.page_compras,
            self.bt_ordenescompra: self.pcompras_ordenes,
            self.bt_back_ordenescompra: self.page_compras,
            # Botones de produccion
            self.bt_produccion: self.page_produccion,
            self.bt_consumo: self.pproduccion_consumo,
            self.bt_back_consumo: self.page_produccion,
            self.bt_empleadosprod: self.pproduccion_empleados,
            self.bt_back_empleadosprod: self.page_produccion,
            self.bt_material: self.pproduccion_material,
            self.bt_back_material: self.page_produccion,
            self.bt_ordenesp: self.pproduccion_ordenes,
            self.bt_back_ordenesprod: self.page_produccion,
            # Botones de inventario
            self.bt_inventario: self.page_inventario,
            self.bt_entradas: self.pinventario_entradas,
            self.bt_back_entradas: self.page_inventario,
            self.bt_producto: self.pinventario_producto,
            self.bt_back_producto: self.page_inventario,
            self.bt_proveedores: self.pinventario_proveedores,
            self.bt_back_proveedores: self.page_inventario,
            self.bt_salidas: self.pinventario_salidas,
            self.bt_back_salidas: self.page_inventario,
            # Botones de ventas
            self.bt_ventas: self.page_ventas,
            self.bt_clientes: self.pventas_clientes,
            self.bt_back_clientes: self.page_ventas,
            self.bt_cuentascobrar: self.pventas_cuentascobrar,
            self.bt_back_cuentascobrar: self.page_ventas,
            self.bt_detalleorden: self.pventas_detalle,
            self.bt_back_detalleventa: self.page_ventas,
            self.bt_ordenesventa: self.pventas_ordenes,
            self.bt_back_ordenesventa: self.page_ventas,
        }

        # Conectar botones al cambio de página
        for button, page in self.navigation_map.items():
            button.clicked.connect(lambda _, p=page: self.stackedwidget.setCurrentWidget(p))

    def closeEvent(self, event):
        # Cerrar la conexión cuando se cierre la ventana
        self.base_datos.close_connection()
        print("Aplicación cerrada. Conexión cerrada.")
        event.accept()  # Esto cierra la ventana de forma normal

    def control_bt_minimizar(self):
        self.showMinimized()

    def control_bt_normal(self):
        self.showNormal()
        self.bt_restaurar.hide()
        self.bt_maximizar.show()

    def control_bt_maximizar(self):
        self.showMaximized()
        self.bt_maximizar.hide()
        self.bt_restaurar.show()

    # SizeGrip
    def resizeEvent(self, event):
        rect = self.rect()
        self.grip.move(rect.right() - self.gripSize, rect.bottom() - self.gripSize)

    # mover ventana
    def mousePressEvent(self, event):
        if event.button() == QtCore.Qt.LeftButton:
            self.click_position = event.globalPos()

    def mover_ventana(self, event):
        if self.isMaximized() == False:
            if event.buttons() == QtCore.Qt.LeftButton:
                self.move(self.pos() + event.globalPos() - self.click_position)
                self.click_position = event.globalPos()
                event.accept()
        if event.globalPos().y() <= 10:
            self.showMaximized()
            self.bt_maximizar.hide()
            self.bt_restaurar.show()
        else:
            self.showNormal()
            self.bt_restaurar.hide()
            self.bt_maximizar.show()

    # Metodo para mover el menu lateral izquierdo
    def mover_menu(self):
        width = self.frame_control.width()
        extender = 200 if width == 0 else 0

        self.animacion = QPropertyAnimation(self.frame_control, b'minimumWidth')
        self.animacion.setDuration(300)
        self.animacion.setStartValue(width)
        self.animacion.setEndValue(extender)
        self.animacion.setEasingCurve(QtCore.QEasingCurve.InOutQuart)
        self.animacion.start()

    def mostrar_datos(self, nombre_tabla, tabla_widget):
        try:
            # Obtener datos y columnas
            datos = self.base_datos.obtener_contenido(nombre_tabla)
            columnas = self.base_datos.obtener_columnas(nombre_tabla)

            if not columnas:
                print(f"No se encontraron columnas para la tabla '{nombre_tabla}'")
                return

            # Configurar la tabla
            tabla_widget.setRowCount(0)
            tabla_widget.setColumnCount(len(columnas))
            tabla_widget.setHorizontalHeaderLabels(columnas)

            # Insertar datos en la tabla
            for fila, registro in enumerate(datos or []):
                tabla_widget.insertRow(fila)
                for columna, valor in enumerate(registro):
                    tabla_widget.setItem(fila, columna, QtWidgets.QTableWidgetItem(str(valor)))

            # Ajustar columnas
            tabla_widget.resizeColumnsToContents()

        except mysql.connector.Error as db_error:
            print(f"Error de base de datos al obtener '{nombre_tabla}': {db_error}")
        except Exception as e:
            print(f"Error inesperado al mostrar datos de '{nombre_tabla}': {e}")


if __name__ == "__main__":
    app = QApplication(sys.argv)
    mi_app = MyGUI()
    mi_app.show()
    sys.exit(app.exec_())