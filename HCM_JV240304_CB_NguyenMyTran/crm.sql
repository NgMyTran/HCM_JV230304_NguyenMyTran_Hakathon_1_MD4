use session8_HAKATHON1;
create table Books(
book_id int primary key auto_increment,
book_title varchar(100) NOT NULL,
book_author varchar(100) NOT NULL
);
create table Readers(
id int primary key auto_increment,
Name varchar(100) NOT NULL, -- chỉ mục
Phone varchar(100) NOT NULL UNIQUE,
email varchar(100)
);
create table BorrowingRecords(
id int primary key auto_increment,
borrow_date date NOT NULL,
return_date date,
book_id INT,
reader_id INT,
FOREIGN KEY (book_id) REFERENCES Books(book_id),
FOREIGN KEY (reader_id) REFERENCES Readers(id)
);
CREATE INDEX idx_name ON Readers(Name);

INSERT INTO Books (book_title, book_author) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald'),
('To Kill a Mockingbird', 'Harper Lee'),
('1984', 'George Orwell'),
('Pride and Prejudice', 'Jane Austen'),
('The Catcher in the Rye', 'J.D. Salinger');
INSERT INTO Readers (Name, Phone, email) VALUES
('Nguyễn Văn An', '090-123-4567', 'nguyen.an@example.com'),
('Trần Thị Bích', '090-234-5678', 'tran.bich@example.com'),
('Lê Văn Cường', '090-345-6789', 'le.cuong@example.com'),
('Phạm Thị Dung', '090-456-7890', 'pham.dung@example.com'),
('Hoàng Văn E', '090-567-8901', 'hoang.e@example.com'),
('Vũ Thị Hoa', '090-678-9012', 'vu.hoa@example.com'),
('Đặng Văn Hùng', '090-789-0123', 'dang.hung@example.com'),
('Bùi Thị Lan', '090-890-1234', 'bui.lan@example.com'),
('Ngô Văn Minh', '090-901-2345', 'ngo.minh@example.com'),
('Nguyễn Thị Nga', '090-012-3456', 'nguyen.nga@example.com'),
('Dương Văn Nam', '090-123-4568', 'duong.nam@example.com'),
('Lưu Thị Oanh', '090-234-5679', 'luu.oanh@example.com'),
('Hà Văn Phú', '090-345-6780', 'ha.phu@example.com'),
('Nguyễn Thị Quỳnh', '090-456-7891', 'nguyen.quynh@example.com'),
('Trần Văn Sơn', '090-567-8902', 'tran.son@example.com');
INSERT INTO BorrowingRecords (borrow_date, return_date, book_id, reader_id) VALUES
('2024-08-01', '2024-08-15', 1, 1),  -- Nguyễn Văn An --> 'The Great Gatsby'
('2024-08-05', '2024-08-20', 3, 2),  -- Trần Thị Bích --> '1984'
('2024-08-10', NULL, 5, 3);           -- Lê Văn Cường --> 'The Catcher in the Rye'
INSERT INTO BorrowingRecords (borrow_date, return_date, book_id, reader_id) VALUES
('2024-08-01', '2024-08-15', 2, 1);

# YÊU CẦU 1 
-- 1. Viết truy vấn SQL để lấy thông tin tất cả các giao dịch mượn sách, bao gồm tên sách, tên độc giả, ngày mượn, và ngày trả (3đ)
SELECT * FROM borrowingrecords;
-- 2. Viết truy vấn SQL để tìm tất cả các sách mà độc giả bất kỳ đã mượn (ví dụ độc giả có tên Nguyễn Văn A). (3đ)
select br.book_id, b.book_title, br.reader_id, r.name
from borrowingrecords br
JOIN books b ON br.book_id = b.book_id
JOIN readers r ON br.reader_id = r.id;
-- 3. Đếm số lần một cuốn sách đã được mượn (6đ)
select b.book_id, b.book_title, count(b.book_id) as SoLanMuon
from borrowingrecords br
JOIN books b ON br.book_id = b.book_id
group by b.book_id, b.book_title;
-- 4. Truy vấn tên của độc giả đã mượn nhiều sách nhất (5đ)
select r.name as Reader, count(b.book_id) as SoSachMuon
from borrowingrecords br
JOIN books b ON br.book_id = b.book_id
JOIN readers r ON br.reader_id = r.id
group by r.name
order by count(b.book_id) DESC limit 1;

# YÊU CẦU 2
-- 1. Tạo một view tên là borrowed_books để hiển thị thông tin của tất cả các sách đã được mượn, bao gồm tên sách, tên độc giả, và ngày mượn.
create view borrowed_books as
select book_title, r.name as ReaderName, br.borrow_date
from borrowingrecords br
JOIN books b ON br.book_id = b.book_id
JOIN readers r ON br.reader_id = r.id;

# YÊU CẦU 3
-- 1. Viết một thủ tục tên là get_books_borrowed_by_reader nhận một tham số là reader_id trả về
drop PROCEDURE if exists get_books_borrowed_by_reader;
DELIMITER //
CREATE PROCEDURE get_books_borrowed_by_reader(
    IN p_reader_id INT
)
BEGIN
--  danh sách các sách mà độc giả đó đã mượn, bao gồm tên sách và ngày mượn.
select r.Name as ReaderName, b.book_title BookTitle, br.borrow_date BorrowDate
from  borrowingrecords br
JOIN books b ON br.book_id = b.book_id
JOIN readers r ON br.reader_id = r.id
where r.id=p_reader_id
;
END//
DELIMITER ;

# YÊU CẦU 4
-- 1. Tạo một Trigger trong MySQL để tự động cập nhật ngày trả sách trong bảng BorrowingRecords khi cuốn sách được trả. 
-- Cụ thể, khi một bản ghi trong bảng BorrowingRecords được cập nhật với giá trị return_date , Trigger sẽ ghi lại ngày hiện tại (ngày trả sách) nếu return_date chưa được điền trước đó.
DELIMITER //
CREATE trigger update_return_date
before update ON BorrowingRecords
for each row
BEGIN
if old.return_date is null and new.return_date is not null then
set new.return_date = curdate();
END IF;
END//
DELIMITER ;