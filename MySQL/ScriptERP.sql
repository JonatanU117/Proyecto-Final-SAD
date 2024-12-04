CREATE DATABASE IF NOT EXISTS cegreen_erp;
USE cegreen_erp;

-- Parte de Módulo de Inventario
CREATE TABLE Proveedores (
ID_Proveedores INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(100),
contacto VARCHAR(100),
direccion TEXT,
telefono VARCHAR(15),
email VARCHAR(100)
);

-- Parte de Módulo de Ventas y Clientes
CREATE TABLE Clientes (
ID_Clientes INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(100),
direccion TEXT,
telefono VARCHAR(15),
email VARCHAR(100)
);

-- Módulo de Finanzas
CREATE TABLE Cuentas (
ID_Cuentas INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(100),
tipo ENUM('ingreso', 'gasto', 'activo', 'pasivo'),
saldo DECIMAL(15, 2),
descripcion TEXT
);

CREATE TABLE Transacciones (
ID_Transacciones INT PRIMARY KEY AUTO_INCREMENT,
ID_Cuenta INT,
fecha DATE,
monto DECIMAL(15, 2),
tipo ENUM('ingreso', 'gasto'),
ID_Proveedor INT,
ID_Cliente INT,
descripcion TEXT,
FOREIGN KEY (ID_Cuenta) REFERENCES Cuentas(ID_Cuentas),
FOREIGN KEY (ID_Proveedor) REFERENCES Proveedores(ID_Proveedores),
FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Clientes)
);

-- Módulo de RRHH
CREATE TABLE Empleados (
ID_Empleados INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(100),
apellido VARCHAR(100),
puesto VARCHAR(100),
fecha_contratacion DATE,
salario DECIMAL(15, 2),
estado ENUM('activo', 'inactivo')
);

CREATE TABLE Asistencias (
ID_Asistencias INT PRIMARY KEY AUTO_INCREMENT,
ID_Empleado INT,
fecha DATE,
hora_entrada TIME,
hora_salida TIME,
FOREIGN KEY (ID_Empleado) REFERENCES Empleados(ID_Empleados)
);

CREATE TABLE Nomina (
ID_Nomina INT PRIMARY KEY AUTO_INCREMENT,
ID_Empleado INT,
periodo VARCHAR(20),
salario DECIMAL(15, 2),
fecha_pago DATE,
FOREIGN KEY (ID_Empleado) REFERENCES Empleados(ID_Empleados)
);

-- Módulo de Inventario
CREATE TABLE Categorias (
ID_Categorias INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(100),
descripcion TEXT
);

CREATE TABLE Productos (
ID_Productos INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(100),
descripcion TEXT,
precio_unitario DECIMAL(10, 2),
ID_Categoria INT,
stock_actual INT,
punto_reorden INT,
FOREIGN KEY (ID_Categoria) REFERENCES Categorias(ID_Categorias)
);

CREATE TABLE Entradas (
ID_Entradas INT PRIMARY KEY AUTO_INCREMENT,
ID_Producto INT,
fecha DATE,
cantidad INT,
ID_Proveedor INT,
precio_unitario DECIMAL(10, 2),
FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Productos),
FOREIGN KEY (ID_Proveedor) REFERENCES Proveedores(ID_Proveedores)
);

CREATE TABLE Salidas (
ID_Salidas INT PRIMARY KEY AUTO_INCREMENT,
ID_Producto INT,
fecha DATE,
cantidad INT,
ID_Cliente INT,
precio_unitario DECIMAL(10, 2),
FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Productos),
FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Clientes)
);

-- Módulo de Compras
CREATE TABLE Ordenes_de_Compra (
ID_Ordenes_de_Compra INT PRIMARY KEY AUTO_INCREMENT,
fecha DATE,
ID_Proveedor INT,
monto_total DECIMAL(15, 2),
estado ENUM('pendiente', 'completada', 'cancelada'),
FOREIGN KEY (ID_Proveedor) REFERENCES Proveedores(ID_Proveedores)
);

CREATE TABLE Detalle_Orden_Compra (
ID_Detalle_Orden_Compra INT PRIMARY KEY AUTO_INCREMENT,
ID_Orden_Compra INT,
ID_Producto INT,
cantidad INT,
precio_unitario DECIMAL(10, 2),
monto DECIMAL(15, 2),
FOREIGN KEY (ID_Orden_Compra) REFERENCES Ordenes_de_Compra(ID_Ordenes_de_Compra),
FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Productos)
);

CREATE TABLE Cuentas_Por_Pagar (
ID_Cuentas_Por_Pagar INT PRIMARY KEY AUTO_INCREMENT,
ID_Proveedor INT,
monto DECIMAL(15, 2),
fecha_vencimiento DATE,
estado ENUM('pendiente', 'pagado'),
FOREIGN KEY (ID_Proveedor) REFERENCES Proveedores(ID_Proveedores)
);

-- Módulo de Ventas y Clientes
CREATE TABLE Ordenes_de_Venta (
ID_Ordenes_de_Venta INT PRIMARY KEY AUTO_INCREMENT,
fecha DATE,
ID_Cliente INT,
monto_total DECIMAL(15, 2),
estado ENUM('pendiente', 'completada', 'cancelada'),
FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Clientes)
);

CREATE TABLE Detalle_Orden_Venta (
ID_Detalle_Orden_Venta INT PRIMARY KEY AUTO_INCREMENT,
ID_Orden_Venta INT,
ID_Producto INT,
cantidad INT,
precio_unitario DECIMAL(10, 2),
monto DECIMAL(15, 2),
FOREIGN KEY (ID_Orden_Venta) REFERENCES Ordenes_de_Venta(ID_Ordenes_de_Venta),
FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Productos)
);

CREATE TABLE Cuentas_Por_Cobrar (
ID_Cuentas_Por_Cobrar INT PRIMARY KEY AUTO_INCREMENT,
ID_Cliente INT,
monto DECIMAL(15, 2),
fecha_vencimiento DATE,
estado ENUM('pendiente', 'cobrado'),
FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Clientes)
);
-- Módulo de Producción
CREATE TABLE Ordenes_de_Produccion (
ID_Ordenes_de_Produccion INT PRIMARY KEY AUTO_INCREMENT,
fecha_inicio DATE,
fecha_fin_estimada DATE,
fecha_fin_real DATE,
ID_Producto_Final INT,
cantidad INT,
estado ENUM('planificada', 'en_proceso', 'completada', 'cancelada'),
FOREIGN KEY (ID_Producto_Final) REFERENCES Productos(ID_Productos)
);

CREATE TABLE Materiales (
ID_Materiales INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(100),
descripcion TEXT,
ID_Categoria INT,
stock_actual INT,
costo_unitario DECIMAL(10, 2),
FOREIGN KEY (ID_Categoria) REFERENCES Categorias(ID_Categorias)
);

CREATE TABLE Consumo_Materiales (
ID_Consumo_Materiales INT PRIMARY KEY AUTO_INCREMENT,
ID_Orden_Produccion INT,
ID_Material INT,
cantidad_consumida INT,
fecha DATE,
FOREIGN KEY (ID_Orden_Produccion) REFERENCES Ordenes_de_Produccion(ID_Ordenes_de_Produccion),
FOREIGN KEY (ID_Material) REFERENCES Materiales(ID_Materiales)
);

CREATE TABLE Empleados_Produccion (
ID_Empleados_Produccion INT PRIMARY KEY AUTO_INCREMENT,
ID_Empleado INT,
ID_Orden_Produccion INT,
rol ENUM('supervisor', 'operador'),
fecha_asignacion DATE,
fecha_fin_asignacion DATE,
FOREIGN KEY (ID_Empleado) REFERENCES Empleados(ID_Empleados),
FOREIGN KEY (ID_Orden_Produccion) REFERENCES Ordenes_de_Produccion(ID_Ordenes_de_Produccion)
);