-- ############################# KHỞI TẠO CREATE VÀ INSERT, EDIT, DELETE TABLE TRONG ORACLE #############################
-- ##1/ LỆNH TẠO CREATE TABLE
CREATE TABLE USERS(
 id NUMBER GENERATED ALWAYS AS IDENTITY, -- LƯU Ý: generated always as identity là giá trị tự tăng trong oracle
 name VARCHAR2(100) NOT NULL,
 email VARCHAR2(100) NOT NULL,
 address VARCHAR(200) NOT NULL,
 -- nên đặt tên contraints cho khóa chính để tiện xóa thay đổi
 CONSTRAINT pk_users PRIMARY KEY(ID)
);

CREATE TABLE DEMO(
 ID NUMBER GENERATED ALWAYS AS IDENTITY,
 name VARCHAR2(100) NOT NULL,
 type VARCHAR2(100) NOT NULL,
 address VARCHAR2(200),
 -- KHOA CHINH
 CONSTRAINT pk_demo PRIMARY KEY(ID)
);

-- ##2/ THÊM CỘT MỚI VÀO BẢNG
-- có thể lưu ý khi thêm nhiều cột vào table thì nên bỏ vào dấu ()
ALTER TABLE USERS ADD phone number;

-- ##3/ SỮA KIỂU DỮ LIỆU CỘT 
ALTER TABLE USERS MODIFY phone varchar2(50);

-- ##4/ CÁCH XÓA CỘT TRONG TABLE 
ALTER TABLE USERS DROP COLUMN phone;

-- ##5/ ĐỔI TÊN CỘT TRONG TABLE 
ALTER TABLE USERS RENAME COLUMN address TO diachi; 

-- ##6/ ĐỔI TÊN TABLE TỪ TÊN CŨ SANG TÊN MỚI
ALTER TABLE USERS RENAME TO NGUOIDUNG;

-- ##7/ CÁCH LÊNH XÓA TABLE VÀ VALUES TRONG TABLE 
-- lệnh xóa table: DROP TABLE USERS;
-- LỆNH xóa value trong table: TRUNCATE TABLE USERS;
-- XÓA value có điều kiện kèm theo: DELETE FROM USERS WHERER ID = 1;

-- ##8/ XEM THÔNG TIN TABLE(xem lại table đó có các cột gì, null or not null, và type của nó....)
DESCRIBE USERS;

-- ##################################################################################################

-- ##9/ LỆNH CHÈN VALUE VÀO TABLE INSERT VALUES DỮ LIỆU VÀO TABLE
/* NOTE: 
 - lưu ý: khi chèn value vào table với id thi có giá trị tự tăng với 
 oracle*/
-- chèn 1 dòng
INSERT INTO USERS(NAME, EMAIL, ADDRESS)
VALUES('Phuc', 'cantho1995ct@gmail.com', 'cantho');

-- chèn nhiều dòng(# với mysql, sql server không thể chèn nhiều dòng chỉ sau dấu , được mà phải có lệnh riêng)
INSERT INTO USERS(NAME, EMAIL, ADDRESS)
    SELECT 'Phuong', 'phuong20@gmail.com', 'Cantho' FROM DUAL UNION ALL
    SELECT 'Ngoc', 'ngoc20@gmail.com', 'Cantho' FROM DUAL UNION ALL
    SELECT 'Hoang', 'hoang26@gmail.com', 'Saigon' FROM DUAL;
COMMIT; -- Luôn nhớ commit để lưu dữ liệu vĩnh viễn nếu khong có commit khi khởi động lại máy sẽ mất values


-- ##10 Nhóm lệnh update values trong table
UPDATE USERS
SET ADDRESS = 'Hochiminh City'
WHERE ID = 4;
COMMIT; -- Luôn nhớ commit để lưu dữ liệu vĩnh viễn


-- ##11 Nhóm lệnh xóa value một dòng theo diều kiện trong table
DELETE FROM USERS WHERE id=4;
COMMIT; -- Luôn nhớ commit để lưu dữ liệu vĩnh viễn


SELECT * FROM USERS