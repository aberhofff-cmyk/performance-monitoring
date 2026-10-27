CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    category VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products(id),
    quantity INTEGER NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Индекс для ускорения запросов
CREATE INDEX idx_orders_product_id ON orders(product_id);
CREATE INDEX idx_orders_created_at ON orders(created_at);

-- Тестовые пользователи (пароль: admin123)
INSERT INTO users (username, password_hash, email) VALUES 
('admin', '$2b$12$KIXxL0U5YlNcZQ8V.wx1teLLQROjBCBmPGWcYJrQ8HvFzBcKp1LG2', 'admin@test.com'),
('user1', '$2b$12$KIXxL0U5YlNcZQ8V.wx1teLLQROjBCBmPGWcYJrQ8HvFzBcKp1LG2', 'user1@test.com'),
('user2', '$2b$12$KIXxL0U5YlNcZQ8V.wx1teLLQROjBCBmPGWcYJrQ8HvFzBcKp1LG2', 'user2@test.com');

-- Тестовые товары
INSERT INTO products (name, description, price, stock, category) VALUES 
('Ноутбук Pro', 'Мощный ноутбук для разработчиков', 999.99, 50, 'electronics'),
('Смартфон X', 'Флагманский смартфон с отличной камерой', 699.99, 100, 'electronics'),
('Наушники Wireless', 'Беспроводные наушники с шумоподавлением', 149.99, 200, 'audio'),
('Клавиатура Mechanical', 'Механическая клавиатура с подсветкой', 89.99, 75, 'accessories'),
('Монитор 4K', '27-дюймовый монитор с разрешением 4K', 399.99, 30, 'electronics'),
('Мышь Gaming', 'Игровая мышь с 8 кнопками', 49.99, 150, 'accessories'),
('SSD 1TB', 'Твердотельный накопитель NVMe 1TB', 129.99, 80, 'storage'),
('Книга Python', 'Изучаем Python: полное руководство', 39.99, 60, 'books'),
('Кофеварка', 'Автоматическая кофеварка капельного типа', 199.99, 25, 'home'),
('Фитнес-браслет', 'Умный браслет для отслеживания активности', 59.99, 120, 'wearables');

-- Создаём тестовые заказы (для нагрузки)
INSERT INTO orders (product_id, quantity, total_price, status, created_at) 
SELECT 
    floor(random() * 10 + 1)::int,
    floor(random() * 5 + 1)::int,
    random() * 500 + 10,
    (ARRAY['pending', 'completed', 'shipped', 'cancelled'])[floor(random() * 4 + 1)],
    NOW() - (random() * INTERVAL '30 days')
FROM generate_series(1, 200);