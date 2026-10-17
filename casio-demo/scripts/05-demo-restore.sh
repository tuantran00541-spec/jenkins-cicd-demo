#!/usr/bin/env bash
# KHÔI PHỤC: trả kỳ vọng về 5 rồi push. Jenkins sẽ build xanh trở lại.
set -euo pipefail
cd "$(dirname "$0")/.."
if ! grep -q 'ScienceCalculator.add(2, 3), 99)' test_app.py; then
  echo "Test không ở trạng thái lỗi chủ đích, không cần khôi phục."; exit 0
fi
sed -i 's/ScienceCalculator.add(2, 3), 99)/ScienceCalculator.add(2, 3), 5)/' test_app.py
git add test_app.py
git commit -m "fix: khôi phục kỳ vọng test_add về 5"
git push
echo "Đã push bản sửa. Jenkins sẽ build xanh trở lại."
