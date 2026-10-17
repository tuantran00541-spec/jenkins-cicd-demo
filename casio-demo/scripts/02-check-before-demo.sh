#!/usr/bin/env bash
# Kiểm tra nhanh trước khi bấm quay. Chạy trong thư mục repo:  ./scripts/02-check-before-demo.sh
cd "$(dirname "$0")/.." || exit 1
ok()   { echo "  [OK]  $1"; }
fail() { echo "  [LỖI] $1"; FAILED=1; }
FAILED=0

echo "1) Jenkins"
if systemctl is-active --quiet jenkins 2>/dev/null; then ok "dịch vụ jenkins đang chạy"; else fail "jenkins chưa chạy (sudo systemctl start jenkins)"; fi
code=$(curl -s -o /dev/null -w '%{http_code}' http://localhost:8080/login 2>/dev/null)
if [ "$code" = "200" ]; then ok "http://localhost:8080 trả mã 200"; else fail "cổng 8080 trả mã '$code'"; fi

echo "2) User jenkins có đủ công cụ"
for tool in git python3 tar; do
  if sudo -n -u jenkins "$tool" --version >/dev/null 2>&1 || sudo -u jenkins which "$tool" >/dev/null 2>&1; then
    ok "user jenkins chạy được $tool"
  else
    fail "user jenkins không thấy $tool"
  fi
done

echo "3) Mã nguồn và Git"
if python3 -m unittest test_app.py >/dev/null 2>&1; then ok "5 unit test đạt trên máy này"; else fail "unit test đang lỗi (chạy ./scripts/05-demo-restore.sh)"; fi
if git remote get-url origin >/dev/null 2>&1; then ok "remote origin: $(git remote get-url origin)"; else fail "chưa có git remote origin"; fi
if git diff --quiet && git diff --cached --quiet; then ok "không có thay đổi chưa commit"; else fail "còn thay đổi chưa commit"; fi

echo "4) Webhook (kiểm tra thủ công)"
echo "  - GitHub > Settings > Webhooks > Recent Deliveries phải báo 200"
echo "  - Nếu đổi địa chỉ tunnel, hãy cập nhật lại Payload URL"

echo
if [ "$FAILED" = "0" ]; then echo "Sẵn sàng quay."; else echo "Còn mục lỗi, hãy sửa trước khi quay."; fi
exit "$FAILED"
