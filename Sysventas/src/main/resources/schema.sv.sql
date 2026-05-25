-- ============================================================
-- SysVentas — DDL de inicialización automática
-- Se ejecuta al arrancar la app si db.ddl.auto=true
-- Todas las sentencias usan IF NOT EXISTS → idempotente
-- Compatible con H2 2.x
-- ============================================================

-- =========================================================
-- SCRIPT H2 CON PREFIJO upeu_
-- =========================================================

CREATE TABLE IF NOT EXISTS upeu_emisor (
                                           id_emisor IDENTITY PRIMARY KEY,
                                           ruc VARCHAR(20) NOT NULL,
    nombre_comercial VARCHAR(60) NOT NULL,
    ubigeo VARCHAR(10) NOT NULL,
    domicilio_fiscal VARCHAR(60) NOT NULL,
    urbanizacion VARCHAR(40) NOT NULL,
    departamento VARCHAR(30) NOT NULL,
    provincia VARCHAR(30) NOT NULL,
    distrito VARCHAR(30) NOT NULL
    );

CREATE TABLE IF NOT EXISTS upeu_perfil (
                                           id_perfil IDENTITY PRIMARY KEY,
                                           nombre VARCHAR(20) NOT NULL,
    codigo VARCHAR(60) NOT NULL
    );

CREATE TABLE IF NOT EXISTS upeu_proveedor (
                                              id_proveedor IDENTITY PRIMARY KEY,
                                              dniruc VARCHAR(12) NOT NULL,
    nombres_raso VARCHAR(60) NOT NULL,
    tipo_doc VARCHAR(12) NOT NULL,
    celular VARCHAR(12) NOT NULL,
    email VARCHAR(40) NOT NULL,
    direccion VARCHAR(80) NOT NULL
    );

CREATE TABLE IF NOT EXISTS upeu_unid_medida (
                                                id_unidad IDENTITY PRIMARY KEY,
                                                nombre_medida VARCHAR(40) NOT NULL
    );

CREATE TABLE IF NOT EXISTS upeu_cliente (
                                            dniruc VARCHAR(12) PRIMARY KEY,
    nombres VARCHAR(60) NOT NULL,
    tipo_documento VARCHAR(12) NOT NULL,
    rep_legal VARCHAR(60) NOT NULL
    );

COMMENT ON COLUMN upeu_cliente.tipo_documento IS '--dni--ruc';

CREATE TABLE IF NOT EXISTS upeu_marca (
                                          id_marca IDENTITY PRIMARY KEY,
                                          nombre VARCHAR(20) NOT NULL
    );

CREATE TABLE IF NOT EXISTS upeu_categoria (
                                              id_categoria IDENTITY PRIMARY KEY,
                                              nombre VARCHAR(20) NOT NULL
    );

CREATE TABLE IF NOT EXISTS upeu_usuario (
                                            id_usuario IDENTITY PRIMARY KEY,
                                            usuario VARCHAR(20) NOT NULL,
    clave VARCHAR(60) NOT NULL,
    id_perfil INTEGER NOT NULL,
    estado VARCHAR(10) NOT NULL
    );

CREATE TABLE IF NOT EXISTS upeu_producto (
                                             id_producto IDENTITY PRIMARY KEY,
                                             nombre VARCHAR(40) NOT NULL,
    pu DOUBLE NOT NULL,
    puold DOUBLE NOT NULL,
    utilidad DOUBLE NOT NULL,
    stock DOUBLE NOT NULL,
    stockold DOUBLE NOT NULL,
    id_categoria INTEGER NOT NULL,
    id_marca INTEGER NOT NULL,
    id_unidad INTEGER NOT NULL
    );

CREATE TABLE IF NOT EXISTS upeu_compra (
                                           id_compra IDENTITY PRIMARY KEY,
                                           precio_base DOUBLE NOT NULL,
                                           igv DOUBLE NOT NULL,
                                           preciototal DOUBLE NOT NULL,
                                           id_proveedor INTEGER NOT NULL,
                                           id_usuario INTEGER NOT NULL,
                                           serie VARCHAR(10) NOT NULL,
    num_doc VARCHAR(12) NOT NULL,
    fecha_comp DATE NOT NULL,
    tipo_doc VARCHAR(20) NOT NULL,
    fecha_reg DATE NOT NULL
    );

CREATE TABLE IF NOT EXISTS upeu_venta (
                                          id_venta IDENTITY PRIMARY KEY,
                                          preciobase DOUBLE NOT NULL,
                                          igv DOUBLE NOT NULL,
                                          preciototal DOUBLE NOT NULL,
                                          dniruc VARCHAR(12) NOT NULL,
    id_usuario INTEGER NOT NULL,
    num_doc VARCHAR(40) NOT NULL,
    fecha_gener DATE NOT NULL,
    serie VARCHAR(10) NOT NULL,
    tipo_doc VARCHAR(20) NOT NULL
    );

CREATE TABLE IF NOT EXISTS upeu_comp_carrito (
                                                 id_compcarrito IDENTITY PRIMARY KEY,
                                                 id_proveedor INTEGER NOT NULL,
                                                 id_producto INTEGER NOT NULL,
                                                 nombre_producto VARCHAR(40) NOT NULL,
    cantidad DOUBLE NOT NULL,
    punitario DOUBLE NOT NULL,
    ptotal DOUBLE NOT NULL,
    estado INTEGER NOT NULL,
    id_usuario INTEGER NOT NULL
    );

CREATE TABLE IF NOT EXISTS upeu_vent_carrito (
                                                 id_carrito IDENTITY PRIMARY KEY,
                                                 dniruc VARCHAR(12) NOT NULL,
    id_producto INTEGER NOT NULL,
    nombre_producto VARCHAR(40) NOT NULL,
    cantidad DOUBLE NOT NULL,
    punitario DOUBLE NOT NULL,
    ptotal DOUBLE NOT NULL,
    estado INTEGER NOT NULL,
    id_usuario INTEGER NOT NULL
    );

CREATE TABLE IF NOT EXISTS upeu_venta_detalle (
                                                  id_venta_detalle IDENTITY PRIMARY KEY,
                                                  pu DOUBLE NOT NULL,
                                                  cantidad DOUBLE NOT NULL,
                                                  descuento DOUBLE NOT NULL,
                                                  subtotal DOUBLE NOT NULL,
                                                  id_venta INTEGER NOT NULL,
                                                  id_producto INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS upeu_compra_detalle (
                                                   id_compra_detalle IDENTITY PRIMARY KEY,
                                                   pu DOUBLE NOT NULL,
                                                   cantidad DOUBLE NOT NULL,
                                                   subtotal DOUBLE NOT NULL,
                                                   id_compra INTEGER NOT NULL,
                                                   id_producto INTEGER NOT NULL
);

-- =========================================================
-- FOREIGN KEYS
-- =========================================================

ALTER TABLE upeu_usuario
    ADD CONSTRAINT IF NOT EXISTS perfil_usuario_fk
    FOREIGN KEY (id_perfil)
    REFERENCES upeu_perfil(id_perfil);

ALTER TABLE upeu_compra
    ADD CONSTRAINT IF NOT EXISTS proveedor_compra_fk
    FOREIGN KEY (id_proveedor)
    REFERENCES upeu_proveedor(id_proveedor);

ALTER TABLE upeu_producto
    ADD CONSTRAINT IF NOT EXISTS unid_medida_producto_fk
    FOREIGN KEY (id_unidad)
    REFERENCES upeu_unid_medida(id_unidad);

ALTER TABLE upeu_compra
    ADD CONSTRAINT IF NOT EXISTS usuario_compra_fk
    FOREIGN KEY (id_usuario)
    REFERENCES upeu_usuario(id_usuario);

ALTER TABLE upeu_venta
    ADD CONSTRAINT IF NOT EXISTS usuario_venta_fk
    FOREIGN KEY (id_usuario)
    REFERENCES upeu_usuario(id_usuario);

ALTER TABLE upeu_vent_carrito
    ADD CONSTRAINT IF NOT EXISTS usuario_carrito_fk
    FOREIGN KEY (id_usuario)
    REFERENCES upeu_usuario(id_usuario);

ALTER TABLE upeu_comp_carrito
    ADD CONSTRAINT IF NOT EXISTS usuario_comp_carrito_fk
    FOREIGN KEY (id_usuario)
    REFERENCES upeu_usuario(id_usuario);

ALTER TABLE upeu_compra_detalle
    ADD CONSTRAINT IF NOT EXISTS compra_compra_detalle_fk
    FOREIGN KEY (id_compra)
    REFERENCES upeu_compra(id_compra);

ALTER TABLE upeu_venta
    ADD CONSTRAINT IF NOT EXISTS cliente_venta_fk
    FOREIGN KEY (dniruc)
    REFERENCES upeu_cliente(dniruc);

ALTER TABLE upeu_venta_detalle
    ADD CONSTRAINT IF NOT EXISTS venta_venta_detalle_fk
    FOREIGN KEY (id_venta)
    REFERENCES upeu_venta(id_venta);

ALTER TABLE upeu_producto
    ADD CONSTRAINT IF NOT EXISTS marca_producto_fk
    FOREIGN KEY (id_marca)
    REFERENCES upeu_marca(id_marca);

ALTER TABLE upeu_producto
    ADD CONSTRAINT IF NOT EXISTS categoria_producto_fk
    FOREIGN KEY (id_categoria)
    REFERENCES upeu_categoria(id_categoria);

ALTER TABLE upeu_compra_detalle
    ADD CONSTRAINT IF NOT EXISTS producto_compra_detalle_fk
    FOREIGN KEY (id_producto)
    REFERENCES upeu_producto(id_producto);

ALTER TABLE upeu_venta_detalle
    ADD CONSTRAINT IF NOT EXISTS producto_venta_detalle_fk
    FOREIGN KEY (id_producto)
    REFERENCES upeu_producto(id_producto);

-- ============================================================
-- Datos iniciales mínimos (solo se insertan si la tabla esta vacia)
-- ============================================================
MERGE INTO upeu_perfil (id_perfil, nombre, codigo)
    KEY(id_perfil) VALUES (1, 'Root', 'ROOT'),
    (2, 'Administrador', 'ADM'),
    (3, 'Reporte', 'REP');

MERGE INTO upeu_usuario (id_usuario, usuario, clave, estado, id_perfil)
    KEY(id_usuario) VALUES (1, 'admin', 'admin123', 'ACTIVO', 1);
