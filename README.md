# Jenkins CI/CD Demo

Repo demo cho đề tài **#37 — Jenkins trong tự động hóa CI/CD** (môn Nhập môn Công nghệ Phần mềm).

Pipeline 4 stage đúng yêu cầu đề bài: **Lấy mã nguồn → Biên dịch → Chạy kiểm thử → Triển khai**.

## Cấu trúc

| File | Mô tả |
|---|---|
| `app.py` | App mẫu: máy tính bỏ túi (cộng/trừ/nhân/chia) |
| `test_app.py` | 5 test pytest cho app mẫu |
| `Jenkinsfile` | Pipeline khai báo 4 stage |
| `requirements.txt` | `pytest` |

## Chạy test local

```bash
python3 -m venv .venv && .venv/bin/pip install -r requirements.txt
.venv/bin/python -m pytest test_app.py -v
```

## Dùng với Jenkins

1. Cài Jenkins trên Ubuntu, mở `http://<server>:8080`
2. Tạo **New Item → Pipeline**, đặt tên `calculator-demo`
3. Mục **Pipeline → Definition**: chọn *Pipeline script from SCM*
   - SCM: Git — Repository URL: `https://github.com/tuantran00541-spec/jenkins-cicd-demo.git`
   - Script Path: `Jenkinsfile`
4. Cấu hình **GitHub webhook** để push code tự trigger build
5. Push 1 commit bất kỳ → xem 4 stage chạy xanh trên Jenkins

## Demo fail thì sao?

Quay video màn hình lúc pipeline chạy xanh trước — live demo mà lỗi thì bật video chữa cháy.
