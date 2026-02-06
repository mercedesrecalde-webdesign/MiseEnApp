-- =============================================
-- MISE EN APP - SCHEMA SUPABASE
-- Ejecutar en SQL Editor de Supabase
-- =============================================

-- Tabla de usuarios
CREATE TABLE IF NOT EXISTS users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    surname TEXT NOT NULL,
    full_name TEXT NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('Docente', 'Administrativo')),
    signature TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de inventario
CREATE TABLE IF NOT EXISTS inventory (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    qty INTEGER NOT NULL DEFAULT 0,
    cat TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de cursos
CREATE TABLE IF NOT EXISTS courses (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de pedidos
CREATE TABLE IF NOT EXISTS orders (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    teacher_id UUID REFERENCES users(id),
    teacher_name TEXT NOT NULL,
    teacher_email TEXT NOT NULL,
    career TEXT NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    status TEXT NOT NULL DEFAULT 'Solicitado' CHECK (status IN ('Solicitado', 'En Curso', 'Devolución Pendiente', 'Finalizado', 'Pendiente Compra', 'Compra Aprobada', 'Compra Rechazada', 'Compra Realizada')),
    observations TEXT,
    resolution TEXT,
    signature TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de items de pedido
CREATE TABLE IF NOT EXISTS order_items (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    item_id UUID REFERENCES inventory(id),
    item_name TEXT NOT NULL,
    qty INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de historial de movimientos de stock
CREATE TABLE IF NOT EXISTS stock_history (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    item_id UUID REFERENCES inventory(id),
    item_name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('in', 'out')),
    amount INTEGER NOT NULL,
    reason TEXT NOT NULL,
    note TEXT,
    before_qty INTEGER NOT NULL,
    after_qty INTEGER NOT NULL,
    user_name TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- HABILITAR ROW LEVEL SECURITY (RLS)
-- =============================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock_history ENABLE ROW LEVEL SECURITY;

-- =============================================
-- POLÍTICAS DE ACCESO PÚBLICO (para app sin auth)
-- =============================================

-- Users: cualquiera puede leer y crear
CREATE POLICY "Users are viewable by everyone" ON users FOR SELECT USING (true);
CREATE POLICY "Users can be created by everyone" ON users FOR INSERT WITH CHECK (true);
CREATE POLICY "Users can be updated by everyone" ON users FOR UPDATE USING (true);

-- Inventory: acceso completo
CREATE POLICY "Inventory viewable by everyone" ON inventory FOR SELECT USING (true);
CREATE POLICY "Inventory insertable by everyone" ON inventory FOR INSERT WITH CHECK (true);
CREATE POLICY "Inventory updatable by everyone" ON inventory FOR UPDATE USING (true);
CREATE POLICY "Inventory deletable by everyone" ON inventory FOR DELETE USING (true);

-- Courses: acceso completo
CREATE POLICY "Courses viewable by everyone" ON courses FOR SELECT USING (true);
CREATE POLICY "Courses insertable by everyone" ON courses FOR INSERT WITH CHECK (true);
CREATE POLICY "Courses deletable by everyone" ON courses FOR DELETE USING (true);

-- Orders: acceso completo
CREATE POLICY "Orders viewable by everyone" ON orders FOR SELECT USING (true);
CREATE POLICY "Orders insertable by everyone" ON orders FOR INSERT WITH CHECK (true);
CREATE POLICY "Orders updatable by everyone" ON orders FOR UPDATE USING (true);

-- Order Items: acceso completo
CREATE POLICY "Order items viewable by everyone" ON order_items FOR SELECT USING (true);
CREATE POLICY "Order items insertable by everyone" ON order_items FOR INSERT WITH CHECK (true);
CREATE POLICY "Order items updatable by everyone" ON order_items FOR UPDATE USING (true);
CREATE POLICY "Order items deletable by everyone" ON order_items FOR DELETE USING (true);

-- Stock History: acceso completo
CREATE POLICY "Stock history viewable by everyone" ON stock_history FOR SELECT USING (true);
CREATE POLICY "Stock history insertable by everyone" ON stock_history FOR INSERT WITH CHECK (true);

-- =============================================
-- DATOS INICIALES
-- =============================================

-- Cursos iniciales
INSERT INTO courses (name) VALUES 
    ('Cocinero Profesional'),
    ('Curso Corto / Taller'),
    ('MasterClass'),
    ('Maestro Pizzero'),
    ('Panadería Profesional'),
    ('Pastelero Profesional')
ON CONFLICT (name) DO NOTHING;

-- Inventario inicial
INSERT INTO inventory (name, qty, cat) VALUES 
    ('Asadera negra 30x40', 4, 'Batería'),
    ('Balanza digital', 10, 'Equipamiento'),
    ('Batidoras de mano', 8, 'Maquinaria'),
    ('Batidores de alambre', 12, 'Utensilios'),
    ('Bowl metálico chico', 15, 'Batería'),
    ('Bowl metálico grande', 12, 'Batería'),
    ('Bowl metálico mediano', 15, 'Batería'),
    ('Bowls plásticos grandes', 12, 'Batería'),
    ('Colador pequeño', 6, 'Utensilios'),
    ('Compoteras plástico', 20, 'Utensilios'),
    ('Cuchara de madera', 10, 'Utensilios'),
    ('Cucharas', 12, 'Utensilios'),
    ('Cuchillo de chef', 6, 'Cuchillería'),
    ('Cuchillo de pan', 1, 'Cuchillería'),
    ('Cuchillos', 12, 'Cuchillería'),
    ('Espátulas de goma', 10, 'Utensilios'),
    ('Espátulas pastelería', 8, 'Utensilios'),
    ('Jarras medidoras', 8, 'Utensilios'),
    ('Palos de amasar', 15, 'Utensilios'),
    ('Picos pasteleros', 12, 'Pastelería'),
    ('Pincel de silicona', 6, 'Utensilios'),
    ('Placa horno convector', 6, 'Batería'),
    ('Rejilla enfriado', 8, 'Batería'),
    ('Silpats', 12, 'Pastelería'),
    ('Tablas de corte', 6, 'Utensilios'),
    ('Tamiz', 10, 'Utensilios'),
    ('Tenedores', 12, 'Utensilios')
ON CONFLICT DO NOTHING;
