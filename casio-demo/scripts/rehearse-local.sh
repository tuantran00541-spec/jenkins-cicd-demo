#!/usr/bin/env bash
# Chạy thử 4 stage của Jenkinsfile ngay trên máy, không cần Jenkins (dùng để tập dượt).
# Lệnh trong từng stage giống hệt Jenkinsfile.
set -e
cd "$(dirname "$0")/.."
export BUILD_NUMBER="${BUILD_NUMBER:-local}"

echo "=== Stage 1. Lấy mã nguồn ==="
git log -1 --pretty=format:"Commit %h - %s (%an)" 2>/dev/null || echo "(chưa có commit)"; echo

echo "=== Stage 2. Biên dịch ==="
rm -rf build __pycache__
mkdir -p build
python3 -m compileall -q app.py
tar -czf build/casio-demo.tgz app.py
ls -l build/casio-demo.tgz

echo "=== Stage 3. Chạy kiểm thử ==="
python3 -m unittest -v test_app.py

echo "=== Stage 4. Triển khai ==="
rm -rf release
mkdir -p release
tar -xzf build/casio-demo.tgz -C release
{
    echo "build=${BUILD_NUMBER}"
    echo "commit=$(git rev-parse --short HEAD 2>/dev/null || echo none)"
    echo "deployed_at=$(date '+%Y-%m-%d %H:%M:%S')"
} > release/BUILD_INFO.txt
echo "--- Smoke check trên bản vừa triển khai ---"
python3 release/app.py power 2 10
python3 release/app.py factorial 5
cat release/BUILD_INFO.txt
echo "=== HOÀN TẤT ==="
