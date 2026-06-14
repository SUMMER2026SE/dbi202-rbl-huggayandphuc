-- ================================================================
-- HỆ THỐNG QUẢN LÝ CHẠY QUẢNG CÁO FACEBOOK
-- DBI202 - RBL Assignment
-- ================================================================

-- Tạo và sử dụng database
CREATE DATABASE IF NOT EXISTS QuanLyQuangCaoFacebook
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE QuanLyQuangCaoFacebook;

-- ================================================================
-- 1. BẢNG KHÁCH HÀNG
-- ================================================================
CREATE TABLE KhachHang (
    KhachHangID   INT AUTO_INCREMENT PRIMARY KEY,
    HoTen         NVARCHAR(100)  NOT NULL,
    Email         VARCHAR(100)   NOT NULL UNIQUE,
    SoDienThoai   VARCHAR(15),
    DiaChi        NVARCHAR(200),
    NgayDangKy    DATE           NOT NULL DEFAULT (CURDATE()),
    GhiChu        NVARCHAR(500)
);

-- ================================================================
-- 2. BẢNG NHÂN VIÊN
-- ================================================================
CREATE TABLE NhanVien (
    NhanVienID    INT AUTO_INCREMENT PRIMARY KEY,
    HoTen         NVARCHAR(100)  NOT NULL,
    Email         VARCHAR(100)   NOT NULL UNIQUE,
    SoDienThoai   VARCHAR(15),
    ChucVu        NVARCHAR(50)   NOT NULL,  -- 'Nhân viên', 'Trưởng nhóm', 'Quản lý'
    NgayVaoLam    DATE           NOT NULL
);

-- ================================================================
-- 3. BẢNG HỢP ĐỒNG
-- ================================================================
CREATE TABLE HopDong (
    HopDongID       INT AUTO_INCREMENT PRIMARY KEY,
    KhachHangID     INT            NOT NULL,
    NhanVienID      INT            NOT NULL,
    NgayBatDau      DATE           NOT NULL,
    NgayKetThuc     DATE           NOT NULL,
    GiaTriHopDong   DECIMAL(15,2)  NOT NULL,
    TrangThai       VARCHAR(20)    NOT NULL DEFAULT 'Dang thuc hien',
                    -- 'Dang thuc hien', 'Het han', 'Da huy'
    GhiChu          NVARCHAR(500),
    CONSTRAINT FK_HopDong_KhachHang FOREIGN KEY (KhachHangID)
        REFERENCES KhachHang(KhachHangID),
    CONSTRAINT FK_HopDong_NhanVien  FOREIGN KEY (NhanVienID)
        REFERENCES NhanVien(NhanVienID),
    CONSTRAINT CHK_HopDong_Ngay CHECK (NgayKetThuc > NgayBatDau),
    CONSTRAINT CHK_HopDong_TrangThai CHECK (
        TrangThai IN ('Dang thuc hien', 'Het han', 'Da huy')
    )
);

-- ================================================================
-- 4. BẢNG CHIẾN DỊCH
-- ================================================================
CREATE TABLE ChienDich (
    ChienDichID   INT AUTO_INCREMENT PRIMARY KEY,
    HopDongID     INT            NOT NULL,
    TenChienDich  NVARCHAR(200)  NOT NULL,
    MucTieu       NVARCHAR(100)  NOT NULL,
                  -- 'Tang nhan dien', 'Tao chuyen doi', 'Tang tuong tac'
    NgayBatDau    DATE           NOT NULL,
    NgayKetThuc   DATE           NOT NULL,
    TrangThai     VARCHAR(20)    NOT NULL DEFAULT 'Dang chay',
                  -- 'Dang chay', 'Tam dung', 'Ket thuc'
    CONSTRAINT FK_ChienDich_HopDong FOREIGN KEY (HopDongID)
        REFERENCES HopDong(HopDongID),
    CONSTRAINT CHK_ChienDich_Ngay CHECK (NgayKetThuc > NgayBatDau),
    CONSTRAINT CHK_ChienDich_TrangThai CHECK (
        TrangThai IN ('Dang chay', 'Tam dung', 'Ket thuc')
    )
);

-- ================================================================
-- 5. BẢNG NGÂN SÁCH
-- ================================================================
CREATE TABLE NganSach (
    NganSachID    INT AUTO_INCREMENT PRIMARY KEY,
    ChienDichID   INT            NOT NULL UNIQUE,  -- 1-1 với ChienDich
    TongNganSach  DECIMAL(15,2)  NOT NULL,
    DaChiTieu     DECIMAL(15,2)  NOT NULL DEFAULT 0,
    DonViTien     VARCHAR(10)    NOT NULL DEFAULT 'VND',
    NgayCapNhat   DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP
                  ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT FK_NganSach_ChienDich FOREIGN KEY (ChienDichID)
        REFERENCES ChienDich(ChienDichID),
    CONSTRAINT CHK_NganSach_ChiTieu CHECK (DaChiTieu <= TongNganSach),
    CONSTRAINT CHK_NganSach_TongNganSach CHECK (TongNganSach > 0)
);

-- ================================================================
-- 6. BẢNG QUẢNG CÁO
-- ================================================================
CREATE TABLE QuangCao (
    QuangCaoID    INT AUTO_INCREMENT PRIMARY KEY,
    ChienDichID   INT            NOT NULL,
    TenQuangCao   NVARCHAR(200)  NOT NULL,
    LoaiQuangCao  VARCHAR(20)    NOT NULL,
                  -- 'Hinh anh', 'Video', 'Carousel', 'Story'
    NoiDung       NVARCHAR(1000),
    DuongDanMedia VARCHAR(500),
    TrangThai     VARCHAR(20)    NOT NULL DEFAULT 'Dang chay',
                  -- 'Dang chay', 'Tam dung', 'Da dung'
    NgayTao       DATE           NOT NULL DEFAULT (CURDATE()),
    CONSTRAINT FK_QuangCao_ChienDich FOREIGN KEY (ChienDichID)
        REFERENCES ChienDich(ChienDichID),
    CONSTRAINT CHK_QuangCao_Loai CHECK (
        LoaiQuangCao IN ('Hinh anh', 'Video', 'Carousel', 'Story')
    ),
    CONSTRAINT CHK_QuangCao_TrangThai CHECK (
        TrangThai IN ('Dang chay', 'Tam dung', 'Da dung')
    )
);

-- ================================================================
-- 7. BẢNG BÁO CÁO HIỆU QUẢ
-- ================================================================
CREATE TABLE BaoCaoHieuQua (
    BaoCaoID      INT AUTO_INCREMENT PRIMARY KEY,
    QuangCaoID    INT            NOT NULL,
    NgayBaoCao    DATE           NOT NULL,
    LuotXem       INT            NOT NULL DEFAULT 0,
    LuotNhanChuot INT            NOT NULL DEFAULT 0,
    LuotChuyenDoi INT            NOT NULL DEFAULT 0,
    DoanhThu      DECIMAL(15,2)  NOT NULL DEFAULT 0,
    ChiPhi        DECIMAL(15,2)  NOT NULL DEFAULT 0,
    CONSTRAINT FK_BaoCao_QuangCao FOREIGN KEY (QuangCaoID)
        REFERENCES QuangCao(QuangCaoID),
    CONSTRAINT UQ_BaoCao_QC_Ngay UNIQUE (QuangCaoID, NgayBaoCao),
    CONSTRAINT CHK_BaoCao_LuotXem CHECK (LuotXem >= 0),
    CONSTRAINT CHK_BaoCao_Click CHECK (LuotNhanChuot >= 0),
    CONSTRAINT CHK_BaoCao_DoanhThu CHECK (DoanhThu >= 0),
    CONSTRAINT CHK_BaoCao_ChiPhi CHECK (ChiPhi >= 0)
);

-- ================================================================
-- INSERT DỮ LIỆU MẪU
-- ================================================================

INSERT INTO NhanVien (HoTen, Email, SoDienThoai, ChucVu, NgayVaoLam) VALUES
('Nguyen Van An',  'an.nguyen@agency.vn',  '0901111111', 'Quan ly',   '2022-01-10'),
('Tran Thi Bich',  'bich.tran@agency.vn',  '0902222222', 'Truong nhom','2022-06-15'),
('Le Van Cuong',   'cuong.le@agency.vn',   '0903333333', 'Nhan vien', '2023-03-01');

INSERT INTO KhachHang (HoTen, Email, SoDienThoai, DiaChi, NgayDangKy) VALUES
('Cong ty TNHH ABC',        'contact@abc.vn',   '0281111111', 'Q1, TP.HCM',    '2024-01-05'),
('Shop Thoi Trang XYZ',     'xyz@gmail.com',    '0909999999', 'Q3, TP.HCM',    '2024-03-20'),
('Nha hang Hai San Bien',   'haisanb@gmail.com','0288888888', 'Q7, TP.HCM',    '2024-05-10');

INSERT INTO HopDong (KhachHangID, NhanVienID, NgayBatDau, NgayKetThuc, GiaTriHopDong, TrangThai) VALUES
(1, 2, '2024-02-01', '2024-07-31', 30000000, 'Het han'),
(2, 3, '2024-04-01', '2024-09-30', 15000000, 'Het han'),
(3, 2, '2025-01-01', '2025-06-30', 20000000, 'Dang thuc hien');

INSERT INTO ChienDich (HopDongID, TenChienDich, MucTieu, NgayBatDau, NgayKetThuc, TrangThai) VALUES
(1, 'Tang nhan dien thuong hieu ABC Q2', 'Tang nhan dien', '2024-02-01', '2024-04-30', 'Ket thuc'),
(1, 'Chien dich ban hang ABC thang 5-7', 'Tao chuyen doi', '2024-05-01', '2024-07-31', 'Ket thuc'),
(2, 'Quang ba bo suu tap he XYZ',        'Tang tuong tac', '2024-04-01', '2024-06-30', 'Ket thuc'),
(3, 'Khuyen mai Tet Duong Lich 2025',    'Tao chuyen doi', '2025-01-01', '2025-01-31', 'Ket thuc'),
(3, 'Chien dich thuong hieu Q2 2025',    'Tang nhan dien', '2025-04-01', '2025-06-30', 'Dang chay');

INSERT INTO NganSach (ChienDichID, TongNganSach, DaChiTieu, DonViTien) VALUES
(1, 10000000,  9800000,  'VND'),
(2, 20000000, 18500000,  'VND'),
(3, 15000000, 14200000,  'VND'),
(4,  8000000,  7900000,  'VND'),
(5, 12000000,  4500000,  'VND');

INSERT INTO QuangCao (ChienDichID, TenQuangCao, LoaiQuangCao, NoiDung, TrangThai) VALUES
(1, 'Banner gioi thieu ABC', 'Hinh anh', 'Gioi thieu thuong hieu ABC - Uy tin - Chat luong', 'Da dung'),
(2, 'Video san pham ABC',    'Video',    'Video 30s gioi thieu san pham ban chay nhat',       'Da dung'),
(2, 'Carousel san pham ABC', 'Carousel', 'Bao gom 5 san pham hot nhat thang 5',               'Da dung'),
(3, 'Anh bo suu tap XYZ',    'Hinh anh', 'Bo suu tap ao he 2024 - Phong cach - Tre trung',    'Da dung'),
(4, 'Khuyen mai Tet 2025',   'Story',    'Giam 30% tat ca mon an - Chi trong thang 1/2025',   'Da dung'),
(5, 'Thuong hieu Q2 2025',   'Video',    'Cau chuyen thuong hieu - 5 nam hinh thanh',          'Dang chay');

INSERT INTO BaoCaoHieuQua (QuangCaoID, NgayBaoCao, LuotXem, LuotNhanChuot, LuotChuyenDoi, DoanhThu, ChiPhi) VALUES
(1, '2024-02-10', 15000, 450,  20,  2000000,  800000),
(1, '2024-02-17', 18000, 540,  28,  2800000,  960000),
(2, '2024-05-05', 25000, 900,  75, 15000000, 3000000),
(2, '2024-05-12', 30000, 1200, 95, 19000000, 3600000),
(3, '2024-05-06', 12000, 600,  40,  8000000, 1800000),
(4, '2024-04-08', 20000, 800,  0,        0,  2400000),
(5, '2025-01-08', 35000, 1400, 120, 24000000, 4200000),
(6, '2025-04-10', 10000, 300,  15,  3000000,  900000);

-- ================================================================
-- CÁC TRUY VẤN BÁO CÁO HỮU ÍCH
-- ================================================================

-- 1. Tổng chi phí và doanh thu theo từng chiến dịch
SELECT
    cd.TenChienDich,
    SUM(bc.ChiPhi)    AS TongChiPhi,
    SUM(bc.DoanhThu)  AS TongDoanhThu,
    ROUND(SUM(bc.DoanhThu) / NULLIF(SUM(bc.ChiPhi), 0), 2) AS ROAS
FROM ChienDich cd
JOIN QuangCao  qc ON qc.ChienDichID = cd.ChienDichID
JOIN BaoCaoHieuQua bc ON bc.QuangCaoID = qc.QuangCaoID
GROUP BY cd.ChienDichID, cd.TenChienDich
ORDER BY ROAS DESC;

-- 2. CTR (Click-through rate) của từng mẫu quảng cáo
SELECT
    qc.TenQuangCao,
    qc.LoaiQuangCao,
    SUM(bc.LuotXem)        AS TongLuotXem,
    SUM(bc.LuotNhanChuot)  AS TongLuotClick,
    ROUND(SUM(bc.LuotNhanChuot) * 100.0 / NULLIF(SUM(bc.LuotXem), 0), 2) AS CTR_Percent
FROM QuangCao qc
JOIN BaoCaoHieuQua bc ON bc.QuangCaoID = qc.QuangCaoID
GROUP BY qc.QuangCaoID, qc.TenQuangCao, qc.LoaiQuangCao
ORDER BY CTR_Percent DESC;

-- 3. Ngân sách còn lại của các chiến dịch đang chạy
SELECT
    cd.TenChienDich,
    ns.TongNganSach,
    ns.DaChiTieu,
    (ns.TongNganSach - ns.DaChiTieu) AS ConLai,
    ROUND(ns.DaChiTieu * 100.0 / ns.TongNganSach, 1) AS PhanTramDaChiTieu
FROM ChienDich cd
JOIN NganSach ns ON ns.ChienDichID = cd.ChienDichID
WHERE cd.TrangThai = 'Dang chay'
ORDER BY PhanTramDaChiTieu DESC;

-- 4. Doanh thu theo từng khách hàng
SELECT
    kh.HoTen AS KhachHang,
    COUNT(DISTINCT hd.HopDongID)  AS SoHopDong,
    COUNT(DISTINCT cd.ChienDichID) AS SoChienDich,
    SUM(bc.DoanhThu)              AS TongDoanhThu
FROM KhachHang kh
JOIN HopDong   hd ON hd.KhachHangID = kh.KhachHangID
JOIN ChienDich cd ON cd.HopDongID   = hd.HopDongID
JOIN QuangCao  qc ON qc.ChienDichID = cd.ChienDichID
JOIN BaoCaoHieuQua bc ON bc.QuangCaoID = qc.QuangCaoID
GROUP BY kh.KhachHangID, kh.HoTen
ORDER BY TongDoanhThu DESC;

