USE cegreen_erp;

-- Parte de Módulo de Inventario
INSERT INTO Proveedores (nombre, contacto, direccion, telefono, email)
VALUES 
('Proveedor Moldes SA', 'Carlos Méndez', 'Calle 123, Ciudad', '555-1234', 'carlos@electronica.com'),
('Materiales Industriales SL', 'Ana García', 'Zona Industrial, Ciudad', '555-5678', 'ana@materiales.com');

-- Parte de Módulo de Ventas y Clientes
INSERT INTO Clientes (nombre, direccion, telefono, email)
VALUES 
('Cliente A', 'Avenida Principal 456, Ciudad', '555-9876', 'clientea@empresa.com');

-- Módulo de Finanzas
INSERT INTO Cuentas (nombre, tipo, saldo, descripcion)
VALUES 
('Caja Chica', 'activo', 15000.00, 'Fondos para gastos menores'),
('Ventas', 'ingreso', 0.00, 'Registro de ingresos por ventas'),
('Compras', 'gasto', 0.00, 'Registro de gastos por compras'),
('Cuentas por Cobrar', 'activo', 0.00, 'Créditos pendientes de clientes');

INSERT INTO Transacciones (ID_Cuenta, fecha, monto, tipo, ID_Proveedor, ID_Cliente, descripcion)
VALUES 
(2, '2024-11-01', 5000.00, 'ingreso', NULL, 1, 'Venta de productos a crédito'),
(3, '2024-11-05', 3000.00, 'gasto', 1, NULL, 'Compra de materias primas');


-- Módulo de RRHH
INSERT INTO Empleados (nombre, apellido, puesto, fecha_contratacion, salario, estado)
VALUES 
('Juan', 'Pérez', 'Gerente de Ventas', '2020-05-15', 50000.00, 'activo'),
('María', 'López', 'Operador de Producción', '2023-01-10', 25000.00, 'activo');

INSERT INTO Asistencias (ID_Empleado, fecha, hora_entrada, hora_salida)
VALUES 
(1, '2024-11-25', '08:00:00', '16:00:00'),
(2, '2024-11-25', '08:30:00', '16:30:00');

INSERT INTO Nomina (ID_Empleado, periodo, salario, fecha_pago)
VALUES 
(1, '2024-11', 50000.00, '2024-11-30'),
(2, '2024-11', 25000.00, '2024-11-30');

-- Módulo de Inventario
INSERT INTO Categorias (nombre, descripcion)
VALUES 
('Plato', 'Articulo principal'),
('Materia Prima', 'Materiales usados en producción');

INSERT INTO Productos (nombre, descripcion, precio_unitario, ID_Categoria, stock_actual, punto_reorden)
VALUES 
('Plato', 'Plato plegable', 15000.00, 1, 50, 10),
('Silicona', 'Silicon para fabricación', 500.00, 2, 1000, 200);

INSERT INTO Entradas (ID_Producto, fecha, cantidad, ID_Proveedor, precio_unitario)
VALUES 
(2, '2024-11-20', 500, 2, 450.00);

INSERT INTO Salidas (ID_Producto, fecha, cantidad, ID_Cliente, precio_unitario)
VALUES 
(1, '2024-11-22', 5, 1, 14500.00);

-- Módulo de Compras
INSERT INTO Ordenes_de_Compra (fecha, ID_Proveedor, monto_total, estado)
VALUES 
('2024-11-15', 2, 225000.00, 'completada');

INSERT INTO Detalle_Orden_Compra (ID_Orden_Compra, ID_Producto, cantidad, precio_unitario, monto)
VALUES 
(1, 2, 500, 450.00, 225000.00);

INSERT INTO Cuentas_Por_Pagar (ID_Proveedor, monto, fecha_vencimiento, estado)
VALUES 
(2, 225000.00, '2024-12-15', 'pendiente');

-- Módulo de Ventas y Clientes
INSERT INTO Ordenes_de_Venta (fecha, ID_Cliente, monto_total, estado)
VALUES 
('2024-11-21', 1, 72500.00, 'completada');

INSERT INTO Detalle_Orden_Venta (ID_Orden_Venta, ID_Producto, cantidad, precio_unitario, monto)
VALUES 
(1, 1, 5, 14500.00, 72500.00);

INSERT INTO Cuentas_Por_Cobrar (ID_Cliente, monto, fecha_vencimiento, estado)
VALUES 
(1, 72500.00, '2024-12-15', 'pendiente');

-- Módulo de Producción
INSERT INTO Ordenes_de_Produccion (fecha_inicio, fecha_fin_estimada, fecha_fin_real, ID_Producto_Final, cantidad, estado)
VALUES 
('2024-11-10', '2024-11-30', NULL, 1, 20, 'en_proceso');

INSERT INTO Materiales (nombre, descripcion, ID_Categoria, stock_actual, costo_unitario)
VALUES 
('Silicona', 'Silicon para fabricación', 2, 500, 450.00);

INSERT INTO Consumo_Materiales (ID_Orden_Produccion, ID_Material, cantidad_consumida, fecha)
VALUES 
(1, 1, 10, '2024-11-15');

INSERT INTO Empleados_Produccion (ID_Empleado, ID_Orden_Produccion, rol, fecha_asignacion, fecha_fin_asignacion)
VALUES 
(2, 1, 'operador', '2024-11-10', NULL);
