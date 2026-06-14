# KHẢO SÁT YÊU CẦU NGHIỆP VỤ
## Đề tài: Hệ thống Quản lý Chạy Quảng cáo Facebook

---

## 1. GIỚI THIỆU HỆ THỐNG

### 1.1 Bối cảnh
Trong thời đại số, các agency quảng cáo cần quản lý nhiều khách hàng, nhiều chiến dịch và theo dõi hiệu quả quảng cáo trên Facebook một cách chuyên nghiệp. Hệ thống giúp tổ chức toàn bộ quy trình từ ký hợp đồng, lên chiến dịch, phân bổ ngân sách đến báo cáo doanh thu.

### 1.2 Phạm vi
- Đối tượng sử dụng: Nhân viên agency, quản lý, khách hàng
- Nền tảng: Hệ thống quản lý nội bộ của agency chạy quảng cáo Facebook
- Quy mô: Quản lý từ 1-2 SV nhóm nhỏ đến agency chuyên nghiệp

---

## 2. ĐỐI TƯỢNG SỬ DỤNG

| Vai trò | Mô tả |
|---------|-------|
| Quản lý | Xem tổng quan, duyệt hợp đồng, phân công nhân viên |
| Nhân viên | Quản lý chiến dịch, tạo quảng cáo, cập nhật báo cáo |
| Khách hàng | Xem báo cáo hiệu quả, theo dõi ngân sách đã chi |

---

## 3. YÊU CẦU NGHIỆP VỤ

### 3.1 Quản lý Khách hàng & Hợp đồng

**Mô tả:**
Agency tiếp nhận khách hàng mới và ký kết hợp đồng dịch vụ chạy quảng cáo. Mỗi khách hàng có thể ký nhiều hợp đồng theo từng đợt hoặc từng gói dịch vụ. Mỗi hợp đồng được giao cho một nhân viên phụ trách.

**Yêu cầu chức năng:**
- Thêm, sửa, xóa thông tin khách hàng
- Tạo và quản lý hợp đồng dịch vụ
- Gán nhân viên phụ trách cho từng hợp đồng
- Theo dõi trạng thái hợp đồng (Đang thực hiện / Hết hạn / Đã hủy)

**Thực thể liên quan:** `KhachHang`, `HopDong`, `NhanVien`

---

### 3.2 Quản lý Chiến dịch & Ngân sách

**Mô tả:**
Mỗi hợp đồng có thể triển khai nhiều chiến dịch quảng cáo khác nhau (ví dụ: chiến dịch tăng nhận diện thương hiệu, chiến dịch bán hàng, chiến dịch tương tác). Mỗi chiến dịch được phân bổ một ngân sách riêng và được theo dõi mức chi tiêu theo thời gian thực.

**Yêu cầu chức năng:**
- Tạo chiến dịch theo từng hợp đồng
- Đặt mục tiêu chiến dịch (Tăng nhận diện / Tạo chuyển đổi / Tăng tương tác)
- Phân bổ và theo dõi ngân sách từng chiến dịch
- Cảnh báo khi ngân sách sắp cạn (chi tiêu > 80% tổng ngân sách)
- Cập nhật trạng thái chiến dịch (Đang chạy / Tạm dừng / Kết thúc)

**Thực thể liên quan:** `ChienDich`, `NganSach`, `HopDong`

---

### 3.3 Quản lý Mẫu Quảng cáo

**Mô tả:**
Trong mỗi chiến dịch, nhân viên tạo ra nhiều mẫu quảng cáo (Ad) với nội dung, hình ảnh và định dạng khác nhau để chạy thử nghiệm (A/B testing). Hệ thống lưu trữ thông tin từng mẫu quảng cáo và trạng thái hoạt động.

**Yêu cầu chức năng:**
- Tạo, chỉnh sửa mẫu quảng cáo trong từng chiến dịch
- Phân loại theo định dạng: Hình ảnh / Video / Carousel / Story
- Quản lý trạng thái: Đang chạy / Tạm dừng / Đã dừng
- Lưu trữ nội dung và đường dẫn hình ảnh/video

**Thực thể liên quan:** `QuangCao`, `ChienDich`

---

### 3.4 Báo cáo Doanh thu & Hiệu quả

**Mô tả:**
Hệ thống ghi nhận và tổng hợp kết quả của từng mẫu quảng cáo theo ngày: số lượt xem, lượt nhấp chuột, lượt chuyển đổi (mua hàng), chi phí và doanh thu phát sinh. Dữ liệu này giúp đánh giá hiệu quả chiến dịch và tối ưu ngân sách.

**Yêu cầu chức năng:**
- Nhập kết quả quảng cáo theo ngày cho từng mẫu
- Tính toán các chỉ số: CTR (Click-through rate), CPC (Cost per click), ROAS (Return on ad spend)
- Xuất báo cáo tổng hợp theo chiến dịch / theo hợp đồng / theo khách hàng
- So sánh hiệu quả giữa các mẫu quảng cáo trong cùng chiến dịch

**Thực thể liên quan:** `BaoCaoHieuQua`, `QuangCao`

---

## 4. QUY TRÌNH NGHIỆP VỤ CHÍNH

```
Tiếp nhận KH → Ký Hợp đồng → Tạo Chiến dịch → Phân bổ Ngân sách
     → Tạo mẫu Quảng cáo → Chạy quảng cáo → Ghi nhận kết quả → Báo cáo KH
```

---

## 5. YÊU CẦU PHI CHỨC NĂNG

| Tiêu chí | Yêu cầu |
|----------|---------|
| Bảo mật | Phân quyền theo vai trò (quản lý / nhân viên) |
| Hiệu năng | Truy vấn báo cáo dưới 3 giây |
| Tính toàn vẹn | Không xóa khách hàng khi còn hợp đồng active |
| Mở rộng | Hỗ trợ thêm nền tảng quảng cáo khác trong tương lai |

