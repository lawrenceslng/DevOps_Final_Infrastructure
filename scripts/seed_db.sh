#!/bin/bash

sudo dnf update -y
sudo dnf install mariadb105 -y

# Connect to RDS and create multiple databases
mysql -h <RDS_ENDPOINT> -u <DB_USER> -P 3306 -p<DB_PASSWORD> <<EOF
CREATE DATABASE IF NOT EXISTS orderdb;
USE orderdb;
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_number VARCHAR(50) NOT NULL UNIQUE,
  user_email VARCHAR(255) NOT NULL,
  status ENUM('placed', 'shipped', 'delivered') DEFAULT 'placed',
  total_price DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Sample seed data
INSERT INTO orders (order_number, user_email, status, total_price) VALUES
('ORD-10001', 'alice@example.com', 'placed', 59.99),
('ORD-10002', 'bob@example.com', 'shipped', 129.50),
('ORD-10003', 'charlie@example.com', 'delivered', 249.00),
('ORD-10004', 'alice@example.com', 'delivered', 19.99),
('ORD-10005', 'david@example.com', 'placed', 75.00);

-- init.sql

CREATE DATABASE IF NOT EXISTS productdb;
USE productdb;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  quantity INT NOT NULL DEFAULT 0,
  price DECIMAL(10,2) NOT NULL
);

INSERT INTO products (name, quantity, price) VALUES
('Wireless Mouse', 50, 19.99),
('Mechanical Keyboard', 30, 89.99),
('USB-C Cable', 100, 9.99),
('Laptop Stand', 40, 29.99),
('Webcam 1080p', 25, 49.99),
('Noise Cancelling Headphones', 20, 149.99),
('Monitor 27"', 15, 229.99),
('Portable SSD 1TB', 35, 119.99),
('Smartphone Tripod', 60, 24.99),
('Bluetooth Speaker', 45, 39.99);
EOF