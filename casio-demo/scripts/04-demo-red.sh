#!/usr/bin/env bash
# LƯỢT ĐỎ: đổi kỳ vọng trong test_add từ 5 thành 99 rồi push. Stage 3 sẽ đỏ, stage 4 bị bỏ qua.
set -euo pipefail
cd "$(dirname "$0")/.."
if ! grep -q 'ScienceCalculator.add(2, 3), 5)' test_app.py; then
  echo "Không tìm thấy dòng kỳ vọng '5'. Có thể test đang ở trạng thái lỗi; chạy 05-demo-restore.sh trước."; exit 1
fi
sed -i 's/ScienceCalculator.add(2, 3), 5)/ScienceCalculator.add(2, 3), 99)/' test_app.py
git add test_app.py
git commit -m "test: giả lập lỗi logic (kỳ vọng add = 99)"
git push
echo
echo "Đã push bản lỗi. Quan sát: stage 3 đỏ, stage 4 skipped, release/ giữ nguyên bản cũ."
