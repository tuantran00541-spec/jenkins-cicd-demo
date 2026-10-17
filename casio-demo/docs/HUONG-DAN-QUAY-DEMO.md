# Hướng dẫn dựng và quay video demo Jenkins CI/CD (Đề tài 37)

Dự án demo: **casio-demo** (Python). Pipeline 4 stage: Lấy mã nguồn → Biên dịch → Chạy kiểm thử → Triển khai.
Video dự kiến dài khoảng **7 phút**, gồm hai lượt: **lượt xanh** (phát hành) và **lượt đỏ** (chặn lỗi).

---

## 1. Chuẩn bị một lần (làm trước khi quay)

**Yêu cầu:** máy Ubuntu 22.04 hoặc 24.04 (máy thật hoặc VM, RAM nên từ 4 GB), có Internet, tài khoản GitHub.

### 1.1 Đưa mã nguồn lên GitHub
1. Trên GitHub tạo repo **public** tên `casio-demo` (public để Jenkins không cần credential).
2. Giải nén gói này, rồi trong thư mục `casio-demo`:
```bash
git init -b main
git add -A
git commit -m "init: casio-demo"
git remote add origin https://github.com/<TÊN_BẠN>/casio-demo.git
git push -u origin main
```
GitHub không nhận mật khẩu khi push bằng HTTPS: hãy dùng **Personal Access Token** (hoặc SSH key) làm mật khẩu.

### 1.2 Cài Jenkins
```bash
sudo ./scripts/01-setup-jenkins-ubuntu.sh
```
Script cài OpenJDK 21, Python 3, Git, thêm khóa `jenkins.io-2026.key`, cài Jenkins LTS và bật systemd. Cuối script in mật khẩu mở khóa.

### 1.3 Mở khóa Jenkins
1. Mở `http://localhost:8080`, dán mật khẩu `initialAdminPassword`.
2. Chọn **Install suggested plugins** (đã gồm Pipeline, Git, GitHub, Timestamper).
3. Tạo tài khoản admin, giữ Jenkins URL mặc định.

### 1.4 Tạo Job Pipeline
1. **New Item** → tên `casio-demo` → chọn **Pipeline** → OK.
2. Mục **Build Triggers**: tích **GitHub hook trigger for GITScm polling**.
3. Mục **Pipeline**: Definition = **Pipeline script from SCM**; SCM = **Git**; Repository URL = URL repo của bạn; Branch = `*/main`; Script Path = `Jenkinsfile`.
4. **Save**, bấm **Build Now** một lần để kiểm tra: build #1 phải xanh cả 4 stage.

### 1.5 Mở đường cho GitHub gọi vào Jenkins
GitHub phải truy cập được Jenkins từ Internet. Nếu Jenkins chạy trên máy cá nhân, dùng một tunnel:
```bash
# Cách 1: cloudflared (không cần tài khoản)
cloudflared tunnel --url http://localhost:8080
# Cách 2: ngrok (cần đăng ký tài khoản miễn phí và authtoken)
ngrok http 8080
```
Lệnh sẽ in ra địa chỉ dạng `https://xxxx.trycloudflare.com` hoặc `https://xxxx.ngrok-free.app`. Đây là `<PUBLIC_URL>`.

Trên GitHub: repo → **Settings → Webhooks → Add webhook**:
- Payload URL: `https://<PUBLIC_URL>/github-webhook/` (nhớ có dấu `/` ở cuối)
- Content type: `application/json`
- Events: **Just the push event**

Sau khi lưu, mở **Recent Deliveries**: lần gửi đầu (ping) phải có dấu tích xanh và mã **200**.
Mỗi lần khởi động lại tunnel địa chỉ sẽ đổi, hãy cập nhật lại Payload URL.

**Phương án dự phòng nếu webhook không chạy:** trong Job → Build Triggers tích **Poll SCM** với lịch `* * * * *` (mỗi phút). Khi quay, hãy nói rõ đây là phương án thay thế.

### 1.6 Kiểm tra trước khi quay
```bash
./scripts/02-check-before-demo.sh
./scripts/rehearse-local.sh      # chạy thử 4 stage ngay trên máy, không cần Jenkins
```
Nên tập dượt toàn bộ kịch bản 1 lần (xanh → đỏ → khôi phục), rồi mới quay.

---

## 2. Kịch bản quay (khoảng 7 phút)

Mở sẵn 3 cửa sổ: **Terminal** (trong thư mục repo), **Jenkins** (trang job `casio-demo`), **GitHub** (trang Webhooks).

| Mốc | Cảnh | Thao tác trên màn hình | Gợi ý lời thoại |
|---|---|---|---|
| 0:00 | Mở đầu | Hiện slide mục tiêu hoặc terminal | "Demo này cho thấy mỗi lần push code, Jenkins tự lấy mã, biên dịch, chạy 5 unit test và chỉ triển khai khi tất cả đạt." |
| 0:30 | Cài đặt | Chiếu `01-setup-jenkins-ubuntu.sh` hoặc chạy (có thể tua nhanh khi quay), rồi `systemctl status jenkins` | "Cài OpenJDK 21, thêm khóa 2026 của Jenkins, cài gói jenkins và bật bằng systemd." |
| 1:15 | Mở khóa | Mở `localhost:8080`, nhập mật khẩu, Suggested Plugins | "Bốn plugin dùng cho demo: Pipeline, Git, GitHub, Timestamper." |
| 2:00 | Tạo Job | Cho thấy cấu hình Job: SCM, Script Path, GitHub hook trigger. Bấm Build Now, build #1 xanh | "Pipeline được định nghĩa bằng mã trong Jenkinsfile, nằm cùng repo." |
| 3:00 | Webhook | Trang GitHub Webhooks, Recent Deliveries mã 200 | "GitHub gửi sự kiện push tới Jenkins, đây là thứ giúp không cần bấm Build Now." |
| 3:45 | **Lượt xanh** | Terminal: `./scripts/03-demo-green.sh`. Chuyển sang Jenkins: build #2 tự xuất hiện | "Tôi chỉ sửa README rồi push, tôi không hề bấm Build Now." |
| 4:30 | Đọc kết quả | **Stage View** (4 stage xanh), **Console Output** (có mốc giờ), **Artifacts** (casio-demo.tgz), **Workspace** → `release/BUILD_INFO.txt` | "Bản release ghi rõ build số mấy, từ commit nào." |
| 5:15 | **Lượt đỏ** | Terminal: `./scripts/04-demo-red.sh`. Build #3: stage 3 đỏ, stage 4 xám (skipped). Mở Console, chỉ dòng `AssertionError: 5 != 99` | "Tôi cố tình đổi kỳ vọng của một test thành 99. Test fail nên pipeline dừng." |
| 6:15 | Bản cũ an toàn | Workspace → `release/BUILD_INFO.txt` vẫn `build=2` | "Bản lỗi không được triển khai, `release/` vẫn là bản tốt gần nhất." |
| 6:30 | Khôi phục, kết | Terminal: `./scripts/05-demo-restore.sh`. Build #4 xanh trở lại | "Sửa lại là pipeline xanh ngay. Đây là cổng chất lượng của CI/CD." |

Mẹo quay: tăng cỡ chữ terminal và trình duyệt (Ctrl + "+"), tắt thông báo hệ thống, ẩn mật khẩu/token/URL tunnel nếu định đăng video công khai.

---

## 3. Xử lý sự cố

| Hiện tượng | Nguyên nhân thường gặp | Cách xử lý |
|---|---|---|
| Push xong nhưng Jenkins không tự chạy | Tunnel đổi địa chỉ; chưa tích hook trigger; Payload URL thiếu `/` cuối | Cập nhật Payload URL, kiểm tra Recent Deliveries; hoặc bật Poll SCM `* * * * *` |
| Recent Deliveries báo lỗi 403/404 | Sai đường dẫn webhook | Dùng đúng `https://<PUBLIC_URL>/github-webhook/` |
| Stage 1 báo không clone được repo | Repo private mà chưa có credential | Đặt repo public hoặc thêm Credentials trong Jenkins |
| `python3: not found` trong build | Chưa cài Python cho máy chạy Jenkins | `sudo apt install -y python3` rồi chạy lại |
| `git push` bị từ chối | Dùng mật khẩu GitHub thay vì token | Tạo Personal Access Token, dùng làm mật khẩu |
| Jenkins không lên, cổng 8080 không mở | Chưa đủ RAM hoặc dịch vụ chưa khởi động xong | `sudo systemctl status jenkins`, `sudo journalctl -u jenkins -e` |
| Quên chạy khôi phục sau lượt đỏ | Test đang ở trạng thái lỗi | `./scripts/05-demo-restore.sh` |

**Phương án an toàn khi quay:** quay riêng từng cảnh (cài đặt, cấu hình, lượt xanh, lượt đỏ) rồi ghép lại. Giữ sẵn lịch sử build xanh/đỏ để có cảnh dự phòng.

---

## 4. Danh sách tệp

| Tệp | Công dụng |
|---|---|
| `app.py`, `test_app.py` | Ứng dụng ScienceCalculator và 5 unit test |
| `Jenkinsfile` | Pipeline 4 stage |
| `scripts/01-setup-jenkins-ubuntu.sh` | Cài Jenkins trên Ubuntu |
| `scripts/02-check-before-demo.sh` | Kiểm tra trước khi quay |
| `scripts/03-demo-green.sh` | Lượt xanh: sửa README, commit, push |
| `scripts/04-demo-red.sh` | Lượt đỏ: đổi kỳ vọng test thành 99, commit, push |
| `scripts/05-demo-restore.sh` | Khôi phục test về bình thường |
| `scripts/rehearse-local.sh` | Chạy thử 4 stage không cần Jenkins |
