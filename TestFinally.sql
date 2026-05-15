-- PHẦN 1: DDL – THIẾT KẾ CSDL
CREATE DATABASE patient_management ;
USE patient_management;

CREATE TABLE patients(
	patient_id int primary key,
    full_name varchar(20) not null,
    phone_number varchar(15) unique,
    gender varchar(10) not null,
    date_of_birth date
);

CREATE TABLE doctors(
	doctor_id int primary key,
    full_name varchar(30) not null,
    specialty varchar(7) not null,
    phone_number varchar(16) unique,
    rating float(10, 1) default 5.0
);

CREATE TABLE appointments(
	appointment_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_time DATETIME NOT NULL,
    fee INT CHECK(fee > 0),
    status VARCHAR(10),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE visit_log(
	log_id INT PRIMARY KEY,
    record_id INT NOT NULL,
    doctor_id INT NOT NULL,
    log_time DATETIME NOT NULL,
    note TEXT(50),
    FOREIGN KEY (record_id) REFERENCES medical_records(record_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE medical_records(
	record_id INT PRIMARY KEY,
    appointment_id INT NOT NULL,
	symptoms VARCHAR(60) NOT NULL,
	diagnosis VARCHAR(50) NOT NULL,
	prescription TEXT(30) ,
	record_date DATETIME DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

-- PHẦN 2: DML – INSERT, UPDATE, DELETE 
-- Câu 1 – INSERT
INSERT INTO patients
VALUES 
(1, 'Nguyen Thi Lan', '0901234567', 'Female', '3/12/1999'),
(2, 'Tran Van Minh', '0902345678', 'Male', '11/25/1996'),
(3, 'Le Hoai Phuong', '0913456789', 'Female', '7/8/2001'),
(4, 'Pham Duc Anh', '0984567890', 'Male', '1/19/1998'),
(5, 'Hoang Ngoc Mai', '0975678901', 'Female', '9/30/2000');

INSERT INTO doctors
VALUES 
(1, 'BS. Nguyen Van Hai', 'Noi', '0931112223', 4.8),
(2, 'BS. Tran Thu Ha', 'Nhi', '0932223334', 5),
(3, 'BS. Le Quoc Tuan', 'Ngoai', '0933334445', 4.6),
(4, 'BS. Pham Minh Chau, Da lieu', '0934445556', 4.9),
(5, 'BS. Hoang Gia Bao', 'Tim mach', '0935556667', 4.7);

INSERT INTO appointments
VALUES 
(7001, 1, 1, '5/20/2024 8:00', 200000, 'Booked'),
(7002, 2, 2, '5/20/2024 9:30', 250000, 'Completed'),
(7003, 3, 3, '5/20/2024 10:15', 300000, 'Booked'),
(7004, 45, '5/21/2024 7:00', 350000, 'Completed'),
(7005, 5, 4, '5/21/2024 8:45', 220000, 'Cancelled');

INSERT INTO medical_records
VALUES 
(8001, 7002, 'Sốt cao, ho', 'Viêm họng', 'Paracetamol + siro ho', '5/20/2024 10:00'),
(8002, 7004, 'Đau ngực nhẹ', 'Theo dõi tim mạch', 'Vitamin + tái khám', '5/21/2024 8:00'),
(8003, 7001, 'Đau bụng', 'Rối loạn tiêu hóa', 'Men tiêu hóa', '5/20/2024 9:00'),
(8004, 7003, 'Đau vai gáy', 'Căng cơ', 'Giảm đau + nghỉ ngơi', '5/20/2024 11:00'),
(8005, 7005, 'Ngứa da', 'Dị ứng', 'Thuốc bôi ngoài da', '5/21/2024 9:00');

INSERT INTO visit_log
VALUES 
(1, 8003, 1, '5/20/2024 9:05', 'Đã khám lần đầu'),
(2, 8001, 2, '5/20/2024 10:05', 'Hoàn tất khám'),
(3, 8004, 3, '5/20/2024 11:10', 'Tư vấn vật lý trị liệu'),
(4, 8002, 5, '5/21/2024 8:10', 'Hướng dẫn tái khám'),
(5, 8005, 4, '5/21/2024 9:05', 'Bệnh nhân hủy hẹn');


--  Câu 2 – UPDATE & DELETE
UPDATE appointments
JOIN patients  ON patients.patient_id = appointments.patient_id
SET fee = fee*1.1
WHERE status = 'Completed'
AND YEAR(date_of_birth) < 2000 ;

DELETE FROM visit_log 
WHERE log_time < '20/05/2024';

-- PHẦN 3: TRUY VẤN CƠ BẢN
-- Câu 1: Liệt kê các thông tin bác sĩ gồm full_name, specialty và rating của những bác sĩ có rating lớn hơn 4.7 hoặc thuộc chuyên khoa “Nhi”.
SELECT full_name, specialty, rating
FROM doctors
WHERE rating > 4.7 
OR specialty = 'Nhi' ;

-- Câu 2: Liệt kê các thông tin bệnh nhân gồm full_name và phone_number của những bệnh nhân có ngày sinh trong khoảng từ 1998-01-01 đến 2001-12-31 và số điện thoại bắt đầu bằng “090”.
SELECT full_name, phone_number
FROM patients
WHERE date_of_birth BETWEEN '1998-01-01' AND '2001-12-31' 
AND phone_number LIKE'090%' ;

-- Câu 3: Liệt kê các phiếu hẹn gồm appointment_id, appointment_time và fee, trong đó danh sách được sắp xếp theo fee giảm dần và chỉ hiển thị 2 phiếu ở trang thứ hai.
SELECT appointment_id, appointment_time, fee
FROM appointments
ORDER BY fee DESC 
LIMIT 2 OFFSET 2;

-- PHẦN 4: TRUY VẤN NÂNG CAO 
-- Câu 1: Liệt kê các thông tin khám gồm họ tên bệnh nhân, họ tên bác sĩ, chuyên khoa, phí khám và thời điểm hẹn khám, với dữ liệu được lấy từ các bảng liên quan trong hệ thống.
SELECT p.full_name, d.full_name, d.specialty, a.fee, a.appointment_time
FROM appointments a
JOIN patients p ON p.patient_id = a.patient_id
JOIN doctors d ON d.doctor_id = a.doctor_id ;

--  Câu 2: Liệt kê các thông tin bác sĩ gồm họ tên bác sĩ và tổng phí khám mà bác sĩ đó đã thực hiện (chỉ tính phiếu Completed), chỉ hiển thị những bác sĩ có tổng phí lớn hơn 500.000.
SELECT a.full_name, SUM(fee) 
FROM appointments a
JOIN doctors d ON d.doctor_id = a.doctor_id
WHERE status = 'Completed' 
GROUP BY a.doctor_id, a.full_name
HAVING SUM(fee) > 500000 ;

--  Câu 3: Liệt kê các thông tin bác sĩ gồm doctor_id, full_name và rating của những bác sĩ có điểm đánh giá cao nhất.
SELECT  doctor_id, full_name, rating
FROM doctors d1
WHERE doctor_id = (
	SELECT doctor_id, MAX(rating)
    FROM doctors d2
    WHERE d1.doctor_id = d2.doctor_id
);

-- PHẦN 5: INDEX & VIEW
-- Câu 1: Tạo một chỉ mục trên bảng appointments dựa trên hai thông tin là trạng thái hẹn khám và phí khám nhằm phục vụ việc tối ưu truy vấn.
CREATE INDEX idx_app ON appointments(status, fee) ;

-- Câu 2: Tạo một khung nhìn dữ liệu hiển thị họ tên bác sĩ, tổng số phiếu hẹn mà bác sĩ đã nhận và tổng doanh thu phí khám mà bác sĩ đó mang lại, trong đó không tính các phiếu bị hủy.
 CREATE VIEW vw_doctoc AS
 SELECT d.full_name, COUNT(a.appointment_id), SUM(a.fee)
 FROM appointments a
 JOIN doctors d ON a.doctor_id = d.doctor_id
 WHERE a.status <> 'Cancelled' 
 GROUP BY a.doctor_id ;
 
 -- PHẦN 6: TRIGGER
 -- Câu 1: Viết một trigger sao cho khi trạng thái của một phiếu hẹn trong bảng appointments được cập nhật sang giá trị Completed thì hệ thống tự động thêm một bản ghi mới vào bảng visit_log với các thông tin sau:
-- appointment_id/record_id: hồ sơ tương ứng của phiếu vừa cập nhật
-- doctor_id: bác sĩ của phiếu hẹn
-- note: Visit completed
-- log_time: thời gian hiện tại của hệ thống

DELIMITER //
CREATE TRIGGER tg_app
AFTER UPDATE ON appointments 
FOR EACH ROW 
BEGIN
	IF NEW.status = 'Completed' AND ( OLD.status <> 'Completed' OR OLD.status IS NULL ) THEN
    INSERT INTO visit_log(record_id, doctor_id, log_time, note)
    VALUES (NEW.record_id, NEW.doctor_id, now(), 'Visit completed');
    END IF ;
END //
DELIMITER ;

 -- PHẦN 7: STORED PROCEDURE 
 --  Câu 1 (5 điểm): Viết một stored procedure nhận vào mã bác sĩ và trả về một thông báo kết quả, trong đó:
-- Nếu tổng phí khám Completed của bác sĩ > 1,000,000 thì trả về High revenue.
-- Nếu bằng nhau thì trả về Target met.
-- Nếu nhỏ hơn thì trả về Normal.

DELIMITER //
CREATE PROCEDURE pcd_doctor(IN doctor_id int, OUT p_message varchar(30)) 
BEGIN 
    DECLARE v_total int ;
	SELECT SUM(fee) total 
	FROM appointments
	WHERE status = 'Completed'
    GROUP BY doctor_id ;
    
    SELECT total INTO v_total 
    FROM appointments ;
    
    IF v_total > 1000000 THEN 
    SET p_message = 'High revenue';
    ELSEIF v_total = 1000000 THEN
    SET p_message = 'Target met';
    ELSE 
    SET p_massage = 'Normal';
    END IF ;
END //
DELIMITER ;
 
 