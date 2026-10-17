# casio-demo — dự án mẫu cho demo Jenkins CI/CD (Đề tài 37)

Ứng dụng Python nhỏ `ScienceCalculator` (add, power, sqrt, factorial) dùng để
minh họa pipeline Jenkins 4 stage: **Lấy mã nguồn → Biên dịch → Chạy kiểm thử → Triển khai**.

## Chạy thử trên máy
```bash
python3 -m unittest -v test_app.py     # 5 unit test
python3 app.py power 2 10              # 1024
./scripts/rehearse-local.sh            # chạy thử cả 4 stage không cần Jenkins
```

## Cấu trúc
| Tệp | Vai trò |
|---|---|
| `app.py` | Mã nguồn ứng dụng |
| `test_app.py` | 5 unit test |
| `Jenkinsfile` | Định nghĩa pipeline 4 stage |
| `scripts/` | Script cài đặt, kiểm tra và chạy kịch bản demo |
| `docs/HUONG-DAN-QUAY-DEMO.md` | Hướng dẫn từng bước và kịch bản quay video |

## Nhật ký demo
