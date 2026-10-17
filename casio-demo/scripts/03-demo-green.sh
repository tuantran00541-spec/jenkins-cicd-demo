#!/usr/bin/env bash
# LƯỢT XANH: sửa nhẹ README, commit và push. Không bấm Build Now, webhook sẽ tự kích hoạt Jenkins.
set -euo pipefail
cd "$(dirname "$0")/.."
echo "- $(date '+%Y-%m-%d %H:%M:%S'): chạy demo lượt xanh" >> README.md
git add README.md
git commit -m "docs: cập nhật nhật ký demo (lượt xanh)"
git push
echo
echo "Đã push. Chuyển sang Jenkins: build mới sẽ tự xuất hiện trong Build History."
