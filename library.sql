-- Library Management System Database
-- Created by Bryan Mwalwala
-- Date: 06/05/2025

-- 1. Create the database and tables (if not exists)
CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

-- Create all tables with proper relationships
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

CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    website VARCHAR(100)
);

CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    nationality VARCHAR(50),
    birth_year INT
);

CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    publisher_id INT,
    publication_year INT,
    genre VARCHAR(50),
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id),
    CHECK (available_copies <= total_copies)
);

CREATE TABLE book_authors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);

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

-- 2. Insert sample data
-- Insert publishers
INSERT INTO publishers (name, address, website) VALUES
('Penguin Classics', '80 Strand, London, UK', 'penguinclassics.com'),
('HarperCollins', '195 Broadway, New York, NY', 'harpercollins.com'),
('Simon & Schuster', '1230 Avenue of the Americas, New York, NY', 'simonandschuster.com');

-- Insert authors
INSERT INTO authors (name, nationality, birth_year) VALUES
('Jane Austen', 'British', 1775),
('George Orwell', 'British', 1903),
('J.K. Rowling', 'British', 1965),
('Ernest Hemingway', 'American', 1899),
('Gabriel García Márquez', 'Colombian', 1927);

-- Insert members
INSERT INTO members (first_name, last_name, email, phone, join_date, membership_status) VALUES
('John', 'Smith', 'john.smith@email.com', '555-0101', '2023-01-15', 'Active'),
('Emily', 'Johnson', 'emily.j@email.com', '555-0102', '2023-02-20', 'Active'),
('Michael', 'Williams', 'michael.w@email.com', NULL, '2023-03-10', 'Suspended'),
('Sarah', 'Brown', 'sarah.b@email.com', '555-0104', '2023-04-05', 'Active'),
('David', 'Lee', 'david.lee@email.com', '555-0105', '2023-05-12', 'Expired');

-- Insert books
INSERT INTO books (title, isbn, publisher_id, publication_year, genre, total_copies, available_copies) VALUES
('Pride and Prejudice', '9780141439518', 1, 1813, 'Classic', 5, 3),
('1984', '9780451524935', 2, 1949, 'Dystopian', 3, 1),
('Harry Potter and the Philosopher''s Stone', '9780747532743', 2, 1997, 'Fantasy', 7, 5),
('The Old Man and the Sea', '9780684801223', 3, 1952, 'Literary Fiction', 4, 2),
('One Hundred Years of Solitude', '9780060883287', 2, 1967, 'Magical Realism', 6, 4);

-- Insert book-authors relationships
INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1), -- Pride and Prejudice by Jane Austen
(2, 2), -- 1984 by George Orwell
(3, 3), -- Harry Potter by J.K. Rowling
(4, 4), -- The Old Man and the Sea by Hemingway
(5, 5); -- One Hundred Years of Solitude by Márquez

-- Insert loans
INSERT INTO loans (book_id, member_id, loan_date, due_date, return_date, status) VALUES
(1, 1, '2023-06-01', '2023-06-15', NULL, 'On Loan'),
(2, 2, '2023-06-05', '2023-06-19', '2023-06-18', 'Returned'),
(3, 3, '2023-06-10', '2023-06-24', NULL, 'Overdue'),
(4, 4, '2023-06-15', '2023-06-29', NULL, 'On Loan'),
(5, 5, '2023-05-20', '2023-06-03', '2023-06-01', 'Returned');

-- 3. Verify data
SELECT 'Publishers' AS table_name, COUNT(*) AS record_count FROM publishers
UNION ALL
SELECT 'Authors', COUNT(*) FROM authors
UNION ALL
SELECT 'Members', COUNT(*) FROM members
UNION ALL
SELECT 'Books', COUNT(*) FROM books
UNION ALL
SELECT 'Book_Authors', COUNT(*) FROM book_authors
UNION ALL
SELECT 'Loans', COUNT(*) FROM loans;
