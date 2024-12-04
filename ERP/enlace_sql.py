import mysql.connector
from mysql.connector import Error


class Conexion():
    def __init__(self):
        try:
            # Crear conexión a la base de datos
            self.mydb = mysql.connector.connect(
                host="localhost",
                user="root",
                password="12345qwert",
                database="cegreen_erp"
            )
            if self.mydb.is_connected():
                print("Conexión exitosa.")
        except Error as e:
            print("Error al conectar a la base de datos:", e)
            self.mydb = None

    def close_connection(self):
        if self.mydb and self.mydb.is_connected():
            self.mydb.close()
            print("Conexión cerrada.")

    def obtener_columnas(self, tabla):
        if self.mydb and self.mydb.is_connected():
            try:
                query = f"SHOW COLUMNS FROM {tabla}"
                with self.mydb.cursor() as cursor:
                    cursor.execute(query)
                    result = cursor.fetchall()
                    # Extraer solo los nombres de las columnas
                    columnas = [col[0] for col in result]
                    return columnas
            except mysql.connector.Error as e:
                print("Error al obtener columnas:", e)
                return []
            except ValueError as ve:
                print("Error:", ve)
                return []
        else:
            print("No se pudo conectar a la base de datos.")
            return []

    def obtener_contenido(self, tabla):
        if self.mydb and self.mydb.is_connected():
            try:
                # Acceder a la tabla de la base de datos
                query = "SELECT * FROM " + tabla
                with self.mydb.cursor() as cursor:
                    cursor.execute(query)
                    result = cursor.fetchall()
                    return result  # Devolver los resultados en lugar de imprimirlos

            except mysql.connector.Error as e:
                print("Error al ejecutar la consulta:", e)
                return []
        else:
            print("No se pudo conectar a la base de datos.")
            return []


# Configuración del entorno principal
if __name__ == "__main__":
    base = Conexion()
    datos = base.obtener_contenido("Cuentas")
    print(datos)
