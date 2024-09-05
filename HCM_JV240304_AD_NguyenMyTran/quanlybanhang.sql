use session8_HAKATHON1;
drop table if exists Category;
alter table room drop foreign key room_ibfk_1;
drop table if exists Room;
alter table BookingDetail drop foreign key bookingDetail_ibfk_1;
alter table BookingDetail drop foreign key bookingDetail_ibfk_2;
drop table if exists Customer;
drop table if exists Booking;
alter table Booking drop foreign key booking_ibfk_1;
drop table if exists BookingDetail;

CREATE TABLE Category (
id int primary key auto_increment,
Name varchar(100) NOT NULL UNIQUE,
Status tinyint default(1), check(Status IN (0,1))
);
CREATE TABLE Room (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(150) NOT NULL,
    Status TINYINT DEFAULT(1) CHECK (Status IN (0, 1)),
    Price FLOAT NOT NULL CHECK (Price >= 100000),
    SalePrice FLOAT DEFAULT(0),
    CreatedDate DATE DEFAULT(current_date()),
    CategoryId INT NOT NULL,
    INDEX idx_name (Name),
    INDEX idx_price (Price),
    INDEX idx_created_date (CreatedDate),
    FOREIGN KEY (CategoryId) REFERENCES Category(Id)
);
CREATE TABLE Customer (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(150) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE CHECK (Email LIKE '%_@__%.__%'),
    Phone VARCHAR(50) NOT NULL UNIQUE,
    Address VARCHAR(255),
    CreatedDate DATE DEFAULT(CURDATE()),
    Gender TINYINT NOT NULL CHECK (Gender IN (0, 1, 2)),
    BirthDay DATE NOT NULL
);
CREATE TABLE Booking (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    CustomerId INT NOT NULL,
    Status TINYINT DEFAULT(1) CHECK (Status IN (0, 1, 2, 3)),
    BookingDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerId) REFERENCES Customer(Id)
);
CREATE TABLE BookingDetail (
    BookingId INT NOT NULL,
    RoomId INT NOT NULL,
    Price FLOAT NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    PRIMARY KEY (BookingId, RoomId),
    FOREIGN KEY (BookingId) REFERENCES Booking(Id),
    FOREIGN KEY (RoomId) REFERENCES Room(Id),
    CHECK (EndDate > StartDate)
);

INSERT INTO Category (Name, Status) VALUES
('Standard', 1),
('Deluxe', 1),
('Suite', 1),
('Executive', 1),
('Presidential', 1);

INSERT INTO Room (Name, Status, Price, SalePrice, CreatedDate, CategoryId) VALUES
('Phòng Tiêu Chuẩn 101', 1, 150000, 0, NULL, 1),
('Phòng Tiêu Chuẩn 102', 1, 150000, 100000, NULL, 1),
('Phòng Deluxe 201', 1, 250000, 0, '2024-09-04', 2),
('Phòng Deluxe 202', 1, 250000, 0, '2024-09-04', 2),
('Phòng Suite 301', 1, 400000, 0, NULL, 3),
('Phòng Suite 302', 1, 400000, 350000, '2024-08-10', 3),
('Phòng Executive 401', 1, 600000, 0, '2024-08-15', 4),
('Phòng Executive 402', 1, 600000, 580000, NULL, 4),
('Phòng Presidential 501', 1, 1000000, 0, '2024-08-20', 5),
('Phòng Presidential 502', 1, 1000000, 0, NULL, 5),
('Phòng Tiêu Chuẩn 103', 1, 150000, 0, NULL, 1),
('Phòng Deluxe 203', 1, 250000, 0, '2024-09-2', 2),
('Phòng Suite 303', 1, 400000, 0, '2024-08-30', 3),
('Phòng Executive 403', 1, 600000, 0, '2024-08-30', 4),
('Phòng Presidential 503', 1, 1000000, 0, NULL, 5);

INSERT INTO Customer (Name, Email, Phone, Address, Gender, BirthDay) VALUES
('Mai Thị D', 'maithid@example.com', '0904567890', '321 Đường XYZ, Quận 4, TP.HCM', 1, '1988-03-12'),
('Phan Văn E', 'phanvane@example.com', '0905678901', '654 Đường JKL, Quận 5, TP.HCM', 0, '1975-07-22'),
('Trịnh Thị F', 'trinhthif@example.com', '0906789012', '987 Đường MNO, Quận 6, TP.HCM', 1, '1992-11-30'),
('Nguyễn Văn A', 'nguyenvana@example.com', '0901234567', '123 Đường ABC, Quận 1, TP.HCM', 1, '1980-05-15'),
('Trần Thị B', 'tranthib@example.com', '0902345678', '456 Đường DEF, Quận 2, TP.HCM', 0, '1985-06-20'),
('Lê Văn C', 'levanc@example.com', '0903456789', '789 Đường GHI, Quận 3, TP.HCM', 0, '1990-12-05');

INSERT INTO Booking (CustomerId, Status, BookingDate) VALUES
(1, 0, '2024-09-01 10:00:00'), -- Mai Thị D
(2, 3, '2024-09-02 11:00:00'), -- Phan Văn E
(3, 1, '2024-09-03 12:00:00'), --  Trịnh Thị F
(4, 0, '2024-09-04 10:00:00'),  -- Nguyễn Văn A
(1, 1, '2024-09-05 11:00:00'),  -- Mai Thị D
(5, 2, '2024-09-06 12:00:00');  -- Trần Thị B

-- Mai Thị D
INSERT INTO BookingDetail (BookingId, RoomId, Price, StartDate, EndDate) VALUES
(1, 1, 150000, '2024-09-01 14:00:00', '2024-09-02 12:00:00'),  -- Phòng Tiêu Chuẩn 101
(1, 2, 150000, '2024-09-01 14:00:00', '2024-09-02 12:00:00'),  -- Phòng Tiêu Chuẩn 102
-- Phan Văn E
(2, 3, 250000, '2024-09-02 14:00:00', '2024-09-03 12:00:00'),  -- Phòng Deluxe 201
(2, 4, 250000, '2024-09-02 14:00:00', '2024-09-03 12:00:00'),  -- Phòng Deluxe 202
-- Trịnh Thị F
(3, 5, 400000, '2024-09-03 14:00:00', '2024-09-04 12:00:00'),  -- Phòng Suite 301
(3, 6, 400000, '2024-09-03 14:00:00', '2024-09-04 12:00:00'), -- Phòng Suite 302
-- Nguyễn Văn A (BookingId = 4)
(4, 4, 150000, '2024-09-04 14:00:00', '2024-09-05 12:00:00'),  -- Phòng Tiêu Chuẩn 103
(4, 8, 150000, '2024-09-04 14:00:00', '2024-09-05 12:00:00'),  -- Phòng Tiêu Chuẩn 104
-- Mai Thị D (BookingId = 5)
(1, 9, 250000, '2024-09-05 14:00:00', '2024-09-06 12:00:00'),  -- Phòng Deluxe 203
(1, 10, 250000, '2024-09-05 14:00:00', '2024-09-06 12:00:00'),  -- Phòng Deluxe 204
-- Trần Thị B (BookingId = 6)
(5, 11, 400000, '2024-09-06 14:00:00', '2024-09-07 12:00:00'),  -- Phòng Suite 303
(5, 12, 400000, '2024-09-06 14:00:00', '2024-09-07 12:00:00');  -- Phòng Suite 304


# Yêu cầu 1 ( Sử dụng lệnh SQL để truy vấn cơ bản ): (15đ)
-- 1. Lấy ra danh phòng có sắp xếp giảm dần theo Price gồm các cột sau: Id, Name, Price,SalePrice, Status, CategoryName, CreatedDate (3đ)
select room.*, (select Name from category where id= room.CategoryId) as CategoryName
from room 
order by Price DESC;

-- 2. Lấy ra danh sách Category gồm: Id, Name, TotalRoom, Status 
-- (Trong đó cột Status nếu = 0,Ẩn, = 1 là Hiển thị )
select c.*, COUNT(r.id) as TotalRoom, 
CASE
WHEN c.Status = 1 then 'Hiển thị' ELSE 'Ẩn' 
END as STatus
from category c
LEFT JOIN room r ON r.categoryId = c.id
group by c.id, c.Name, c.Status;

-- 3. Truy vấn danh sách Customer gồm: Id, Name, Email, Phone, Address, CreatedDate, Gender,
-- BirthDay, Age (Age là cột suy ra từ BirthDay, Gender nếu = 0 là Nam, 1 là Nữ,2 là khác)
select Id, Name, Email, Phone, Address, CreatedDate, 
    CASE WHEN Gender=0 then 'Nam'
    WHEN Gender =1 then 'Nữ' 
	ELSE 'Khác' 
    END as Gender,
    Birthday, 
    timestampdiff(YEAR, BirthDay, CURDATE()) as Age 
FROM Customer;


#Yêu cầu 2 ( Sử dụng lệnh SQL tạo View ): (15đ)
-- 1. View v_getRoomInfo Lấy ra danh sách của 10 phòng có giá cao nhất (7,5đ)
create view v_getRoomInfo as 
select * from room order by Price DESC limit 10;

-- 2. View v_getBookingList hiển thị danh sách phiếu đặt hàng gồm: Id, BookingDate, Status, CusName, Email, Phone, TotalAmount 
-- ( Trong đó cột Status nếu = 0 Chưa duyệt, = 1 Đã duyệt, = 2 Đã thanh toán, = 3 Đã hủy )
create view v_getBookingList as 
select b.id, b.bookingDate,
case
when b.status=0 then 'Chưa duyệt'
when b.status=1 then 'Đã duyệt'
when b.status=2 then 'Đã thanh toán'
else 'Đã hủy'
END as Status
,
c.Name as CusName, c.email, c.phone, SUM(bd.Price) as TotalAmonut
from Booking b
JOIN Customer c ON  b.CustomerId = c.Id
LEFT JOIN bookingDetail bd ON b.Id = bd.BookingId
GROUP BY b.Id, b.BookingDate, b.Status, c.Name, c.Email, c.Phone;


# Yêu cầu 3
-- 1. Thủ tục addRoomInfo thực hiện thêm mới Room, khi gọi thủ tục truyền đầy đủ các giá trị của bảng Room ( Trừ cột tự động tăng )
DELIMITER //
CREATE PROCEDURE addRoomInfo (
    p_Name VARCHAR(150),
    p_Status TINYINT,
    p_Price FLOAT,
    p_SalePrice FLOAT,
    p_CreatedDate DATE,
    p_CategoryId INT
)
BEGIN
    insert into Room (Name, Status, Price, SalePrice, CreatedDate, CategoryId) VALUES
    ( p_Name,p_Status,p_Price,p_SalePrice,p_CreatedDate,p_CategoryId);
END //
DELIMITER ;

-- 2. Thủ tục getBookingByCustomerId hiển thị danh sách phieus đặt phòng của khách hàng theo Id khách hàng gồm: Id, BookingDate, Status, TotalAmount
-- (Trong đó cột Status nếu = 0 Chưa duyệt, = 1 Đã duyệt, = 2 Đã thanh toán, = 3 Đã hủy), Khi gọi thủ tục truyền vào id của khách hàng
DELIMITER //
CREATE PROCEDURE getBookingByCustomerId(
    IN p_CusId INT
)
BEGIN
select b.id, b.bookingDate,
case
when b.status=0 then 'Chưa duyệt'
when b.status=1 then 'Đã duyệt'
when b.status=2 then 'Đã thanh toán'
else 'Đã hủy'
END as Status
, SUM(bd.Price) as TotalAmonut
from Booking b
JOIN Customer c ON  b.CustomerId = c.Id
LEFT JOIN bookingDetail bd ON b.Id = bd.BookingId
where c.Id = p_CusId
GROUP BY b.Id, b.BookingDate, b.Status;
END//
DELIMITER ;

-- 3. Thủ tục getRoomPaginate lấy ra danh sách phòng có phân trang gồm: Id, Name, Price, SalePrice, Khi gọi thủ tuc truyền vào limit và page (5đ)
DELIMITER //
CREATE PROCEDURE getRoomPaginate(
    p_limit INT,
    p_page INT
)
BEGIN
    DECLARE offset INT;
    SET offset = (p_page - 1) * p_limit;
    select Id, Name, Price, SalePrice
    from Room 
    where Status = 1
    LIMIT p_limit OFFSET offset;
END //
DELIMITER ;
call getRoomPaginate(5,2);


#Yêu cầu 4 ( Sử dụng lệnh SQL tạo Trigger ) (15đ)
-- 1. Tạo trigger tr_Check_Price_Value sao cho khi thêm hoặc sửa phòng Room g.trị của Price > 5000000 thì tự động chuyển về 5000000 và in ra thông báo ‘Giá phòng lớn nhất 5 triệu’
DELIMITER //
CREATE TRIGGER tr_Check_Price_Value
BEFORE INSERT ON Room
FOR EACH ROW
BEGIN
    IF NEW.Price > 5000000 THEN
        SET NEW.Price = 5000000;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Giá phòng lớn nhất 5 triệu';
    END IF;
END //

CREATE TRIGGER tr_Check_Price_Value_Update
BEFORE UPDATE ON Room
FOR EACH ROW
BEGIN
    IF NEW.Price > 5000000 THEN
        SET NEW.Price = 5000000;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Giá phòng lớn nhất 5 triệu';
    END IF;
END //
DELIMITER ;

-- 2. Tạo trigger tr_check_Room_NotAllow khi thực hiện đặt pòng, nếu ngày đến (StartDate)
-- và ngày đi (EndDate) của đơn hiện tại mà phòng đã có người đặt rồi thì thông báo 'Phòng đã được đặt'
DELIMITER //
CREATE TRIGGER tr_check_Room_NotAllow
BEFORE INSERT ON BookingDetail
FOR EACH ROW
BEGIN
    DECLARE roomBookedCount INT;
    SELECT COUNT(*)
    INTO roomBookedCount
    FROM BookingDetail
    WHERE RoomId = NEW.RoomId
    AND (NEW.StartDate < EndDate AND NEW.EndDate > StartDate);
    IF roomBookedCount > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Phòng đã được đặt';
    END IF;
END //
DELIMITER ;