USE [Library Management System];
GO

CREATE TABLE Authors (
    AuthorID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    BirthYear INT
);

CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL
);

CREATE TABLE Books (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    AuthorID INT NOT NULL,
    CategoryID INT NOT NULL,
    ISBN NVARCHAR(20),
    PublishedYear INT,
    CopiesAvailable INT DEFAULT 1,
    CONSTRAINT FK_Books_Authors FOREIGN KEY (AuthorID)
        REFERENCES Authors(AuthorID),
    CONSTRAINT FK_Books_Categories FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID)
);

CREATE TABLE Members (
    MemberID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100),
    JoinDate DATE DEFAULT GETDATE()
);

CREATE TABLE Staff (
    StaffID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Position NVARCHAR(50)
);

CREATE TABLE Loans (
    LoanID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT NOT NULL,
    MemberID INT NOT NULL,
    StaffID INT NOT NULL,
    LoanDate DATE DEFAULT GETDATE(),
    DueDate DATE,
    ReturnDate DATE,
    CONSTRAINT FK_Loans_Books FOREIGN KEY (BookID)
        REFERENCES Books(BookID),
    CONSTRAINT FK_Loans_Members FOREIGN KEY (MemberID)
        REFERENCES Members(MemberID),
    CONSTRAINT FK_Loans_Staff FOREIGN KEY (StaffID)
        REFERENCES Staff(StaffID)
);

INSERT INTO Authors (Name, BirthYear)
VALUES
('J.K. Rowling', 1965),
('George Orwell', 1903),
('Agatha Christie', 1890),
('Dan Brown', 1964),
('Haruki Murakami', 1949);

INSERT INTO Categories (CategoryName)
VALUES
('Fiction'),
('Science Fiction'),
('Mystery'),
('Biography'),
('Self-Help');

INSERT INTO Books (Title, AuthorID, CategoryID, ISBN, PublishedYear, CopiesAvailable)
VALUES
('Harry Potter and the Philosopher''s Stone', 1, 1, '9780747532699', 1997, 5),
('1984', 2, 2, '9780451524935', 1949, 3),
('Murder on the Orient Express', 3, 3, '9780007119318', 1934, 4),
('The Da Vinci Code', 4, 1, '9780385504201', 2003, 6),
('Kafka on the Shore', 5, 1, '9781400079278', 2002, 2);

INSERT INTO Members (Name, Email)
VALUES
('Ahmed Ali', 'ahmed.ali@example.com'),
('Sara Mohamed', 'sara.mohamed@example.com'),
('Omar Hassan', 'omar.hassan@example.com'),
('Nour Said', 'nour.said@example.com'),
('Mona Adel', 'mona.adel@example.com');

INSERT INTO Staff (Name, Position)
VALUES
('Mohamed Salah', 'Librarian'),
('Fatma Kamal', 'Assistant Librarian'),
('Hany Taha', 'Library Manager');

INSERT INTO Loans (BookID, MemberID, StaffID, LoanDate, DueDate, ReturnDate)
VALUES
(1, 1, 1, '2026-03-01', '2026-03-15', NULL),
(2, 2, 2, '2026-03-02', '2026-03-16', '2026-03-10'),
(3, 3, 1, '2026-03-03', '2026-03-17', NULL),
(4, 4, 3, '2026-03-01', '2026-03-15', '2026-03-14'),
(5, 5, 2, '2026-03-04', '2026-03-18', NULL);

--****************************************************
SELECT 
    B.BookID,
    B.Title,
    A.Name AS Author,
    C.CategoryName,
    B.CopiesAvailable
FROM Books B
JOIN Authors A ON B.AuthorID = A.AuthorID
JOIN Categories C ON B.CategoryID = C.CategoryID;
--******************************************************
SELECT 
    L.LoanID,
    B.Title AS BookTitle,
    M.Name AS MemberName,
    S.Name AS StaffName,
    L.LoanDate,
    L.DueDate
FROM Loans L
JOIN Books B ON L.BookID = B.BookID
JOIN Members M ON L.MemberID = M.MemberID
JOIN Staff S ON L.StaffID = S.StaffID
WHERE L.ReturnDate IS NULL;
--*****************************************************
SELECT 
    L.LoanID,
    B.Title AS BookTitle,
    M.Name AS MemberName,
    L.DueDate,
    DATEDIFF(DAY, L.DueDate, GETDATE()) AS DaysOverdue
FROM Loans L
JOIN Books B ON L.BookID = B.BookID
JOIN Members M ON L.MemberID = M.MemberID
WHERE L.ReturnDate IS NULL AND L.DueDate < GETDATE();
--****************************************************
SELECT 
    M.Name AS MemberName,
    COUNT(L.LoanID) AS TotalLoans
FROM Members M
LEFT JOIN Loans L ON M.MemberID = L.MemberID
GROUP BY M.Name;
--***************************************************
SELECT 
    S.Name AS StaffName,
    COUNT(L.LoanID) AS ProcessedLoans
FROM Staff S
LEFT JOIN Loans L ON S.StaffID = L.StaffID
GROUP BY S.Name;