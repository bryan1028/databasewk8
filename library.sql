-- Library Management System Database
-- Created by Bryan Mwalwala
-- Date: 06/05/2025

-- Create database
CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

-- Members table
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    join_date DATE NOT NULL,
    membership_status ENUM('Active', 'Expired', 'Suspended') DEFAULT 'Active',
    CHECK (email LIKE '%@%.%')
);

-- Authors table
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    nationality VARCHAR(50),
    birth_year INT
);

-- Publishers table
CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    website VARCHAR(100)
);

-- Books table
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    publisher_id INT,
    publication_year INT,
    genre VARCHAR(50),
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id)
);

-- Book-Author relationship (Many-to-Many)
CREATE TABLE book_authors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

-- Loans table
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('On Loan', 'Returned', 'Overdue') DEFAULT 'On Loan',
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    CHECK (due_date > loan_date),
    CHECK (return_date IS NULL OR return_date >= loan_date)
);

-- Insert sample data
INSERT INTO members (first_name, last_name, email, phone, join_date) VALUES
('John', 'Smith', 'john.smith@email.com', '555-0101', '2023-01-15'),
('Emily', 'Johnson', 'emily.j@email.com', '555-0102', '2023-02-20'),
('Michael', 'Williams', 'michael.w@email.com', NULL, '2023-03-10');

INSERT INTO publishers (name, address, website) VALUES
('Penguin Books', '123 Publishing Ave, New York', 'penguin.com'),
('HarperCollins', '456 Book Lane, London', 'harpercollins.com');

INSERT INTO authors (name, nationality, birth_year) VALUES
('Jane Austen', 'British', 1775),
('George Orwell', 'British', 1903),
('Toni Morrison', 'American', 1931);

INSERT INTO books (title, isbn, publisher_id, publication_year, genre, total_copies, available_copies) VALUES
('Pride and Prejudice', '978-0141439518', 1, 1813, 'Classic', 5, 3),
('1984', '978-0451524935', 2, 1949, 'Dystopian', 3, 2),
('Beloved', '978-1400033416', 2, 1987, 'Literary Fiction', 4, 4);

INSERT INTO book_authors VALUES
(1, 1), -- Pride and Prejudice by Jane Austen
(2, 2), -- 1984 by George Orwell
(3, 3); -- Beloved by Toni Morrison

INSERT INTO loans (book_id, member_id, loan_date, due_date, return_date, status) VALUES
(1, 1, '2023-06-01', '2023-06-15', NULL, 'On Loan'),
(2, 2, '2023-06-05', '2023-06-19', '2023-06-18', 'Returned');
