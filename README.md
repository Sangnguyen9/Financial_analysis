# Phân tích Tài chính
# 📌 Phân tích Tài chính
**Power BI, SQL Programming, Data Visualization**  

## 📌 Mục tiêu  

Phân tích hiệu suất kinh doanh theo vùng, hiệu quả sử dụng nguồn lực và vốn thông qua lập trình SQL và trực quan hóa BI bằng dữ liệu tài chính và vận hành nội bộ.
Mục tiêu là xác định các vùng hoạt động hiệu quả, tối ưu hóa nguồn nhân lực và cải thiện chiến lược phân bổ vốn để tăng lợi nhuận dài hạn.

## 📁 Cấu trúc Dự án

Financial_analysis_project/  
│── **Financial_analysis.pbix**: Power BI dashboard containing all visualizations and insights  
│── **SQL Programming** 

    1. Hiểu Logic Nghiệp vụ: Nghiên cứu lĩnh vực kinh doanh và liệt kê tất cả thuật ngữ liên quan để hiểu rõ dữ liệu đầu vào và đầu ra mong đợi.
 
 2. Thiết kế Bảng DIM Cơ cấu Vốn: Xây dựng bảng chiều (DIM) để lưu trữ tiêu chí cơ cấu vốn.
 
 3. Xây dựng Bảng FACT Số dư Hàng ngày: Tạo bảng FACT để lưu trữ số dư khách hàng hàng ngày về tiền gửi và khoản vay, được chia theo kỳ hạn và loại sản phẩm.
 
 4. Tạo Bảng Tổng hợp Nguồn & Sử dụng Vốn: Xây dựng bảng tổng hợp để theo dõi nguồn và cách sử dụng vốn dựa trên tiêu chí đã xác định ở bước 1.
 
 5. Phát triển Thủ tục Xử lý Dữ liệu hỗ trợ Backdate: Viết stored procedure để xử lý dữ liệu hỗ trợ chạy với ngày lịch sử (backdate).
 
 6. Kiểm tra Kịch bản Dữ liệu: Xác thực dữ liệu bằng cách thực thi và kiểm tra các trường hợp biên và kịch bản khác nhau.
 
 7. Viết Script Báo cáo Tổng hợp: Viết script SQL để tạo đầu ra báo cáo tổng hợp cuối cùng.
 
 8. Tạo View và Kết nối với Công cụ BI: Tạo view SQL cho mục đích báo cáo và sử dụng chế độ Direct Query để kết nối chúng với Power BI hoặc Tableau để trực quan hóa dữ liệu.
     
│── **Dataset/**: Dữ liệu đã xử lý xuất từ File Excel để sử dụng offline 
│── **README.md**: Tài liệu dự án  

---  

## 📊 Đóng góp Chính
  
### 1️⃣ Giới thiệu
- Xác định các phân khúc khách hàng chính và hành vi mua hàng.
  
- Phân tích hiệu suất bán hàng theo vùng để phát hiện xu hướng thị trường.  

### 2️⃣ KQKD theo Khu vực
- Hiệu suất tài chính của từng vùng dựa trên các chỉ số khác nhau (thu nhập, chi phí, lợi nhuận, v.v.).
  
- So sánh hiệu suất giữa các vùng và hỗ trợ ra quyết định về chiến lược và phân bổ nguồn lực.
  
### 3️⃣ Phân tích KQKD 
- Xu hướng tài chính theo vùng thông qua các chỉ số như lợi nhuận, CIR, margin và năng suất nhân viên.
  
- So sánh hiệu suất giữa các vùng và hỗ trợ điều chỉnh chiến lược kinh doanh.

### 4️ Tổng quan KPI ASM
- Kết quả KPI của từng ASM theo vùng trong tháng, dựa trên tổng điểm và các chỉ số hiệu suất cụ thể.

- Đánh giá và so sánh hiệu suất ASM để hỗ trợ xếp hạng, khen thưởng hoặc điều chỉnh.

### 5️⃣ Top and Bot 10 Nhân viên kinh doanh
- Top 10 và Bottom 10 nhân viên kinh doanh dựa trên tổng điểm, điểm quy mô và điểm tài chính, được phân tích theo vùng và cá nhân.

- Xác định những người làm việc hiệu quả và kém hiệu quả để hỗ trợ đánh giá hiệu suất và quyết định nhân sự.

### 6️⃣ Thuật ngữ
- Bảng thuật ngữ giải thích các từ viết tắt và mã được sử dụng trong hệ thống phân tích tài chính.

- Hỗ trợ người dùng hiểu rõ nội dung báo cáo và tránh nhầm lẫn khi xem xét và phân tích dữ liệu.


---  

## 🛠️ Tools Used  
- **Power BI, SQL Programming (PostgreSQL)**
- **Xử lý Dữ liệu:** Stored procedure hỗ trợ thực thi backdate hàng tháng
- **Trực quan hóa:** Power BI 
- **Statistical Analysis:** Thống kê mô tả để đánh giá xu hướng

---  
📌 **Tất cả insights và biểu đồ tương tác có thể truy cập trong `Financial_analysis.pbix`.**  



