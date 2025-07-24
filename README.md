# Rails tutorial - Sample App

# 1. Phiên bản cài đặt để chạy được dự án:

- Ruby: 3.2.2
- Rails: 7.0.7
- MySQL

# 2. Hướng dẫn cài dự án:

## 2.1 Cài đặt config(chỉ chạy lần đầu)

- Tạo config database cho dự án: cp config/database.yml.example config/database.yml
- Chạy lệnh để tạo database: rails db:create
- Bật server: rails s
  Truy cập đường dẫn http://localhost:3000/ hiển thị Rails là thành công

1. Research gem config

- gem config là gem dùng để quản lý biến cấu hình trong Rails/Ruby một cách gọn gàng, dễ maintain
- Thay vì hardcode hoặc phụ thuộc ENV, có thể:
  - Tạo file config/settings.yml hoặc settings.local.yml để lưu cấu hình.
  - Truy cập dễ dàng qua Settings.api_key hoặc Settings[:api_key]

2. Research I18n, I18n lazy lookup

- I18n (Internationalization) trong Rails cho phép ứng dụng hỗ trợ đa ngôn ngữ.
- Các chuỗi văn bản được lưu trong config/locales/\*.yml
- Rails tự động load theo I18n.locale

3. What is Attack CSRF, XSS? and How to prevent them in Rails?

- CSRF : Là tấn công khi attacker giả mạo request của user đã authenticated.
- Ví dụ: attacker gửi form POST từ site khác, user đang login sẽ thực hiện hành động trái phép.

4. XSS (Cross-Site Scripting)

- Là tấn công chèn script độc hại vào trang web, ví dụ:
- Ví dụ: <script>alert("Hacked!")</script>
- Để tránh XSS, sử dụng Rails helper như: sanitize, html_escape, raw

5. Distinguish: nil?, empty?, blank?, present?
6. Presenting the effect of helper folder, what case of using it

- app/helpers/ chứa các module helper hỗ trợ xử lý logic hiển thị trong view.
- Tác dụng: tách logic view và controller, dễ maintain, dễ debug,
  Giúp giữ view gọn gàng, tách biệt logic format ra khỏi template.
