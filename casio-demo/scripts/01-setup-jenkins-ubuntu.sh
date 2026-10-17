#!/usr/bin/env bash
# Cài Jenkins LTS trên Ubuntu 22.04/24.04 (OpenJDK 21 + khóa apt 2026).
# Chạy:  sudo ./01-setup-jenkins-ubuntu.sh
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "Hãy chạy bằng sudo:  sudo $0"; exit 1
fi

echo "==> 1/4 Cài nền tảng: Java 21, Python 3, Git"
apt-get update
apt-get install -y fontconfig openjdk-21-jre python3 git curl wget

echo "==> 2/4 Thêm khóa và kho Jenkins LTS (khóa 2026)"
install -d -m 0755 /etc/apt/keyrings
wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  > /etc/apt/sources.list.d/jenkins.list

echo "==> 3/4 Cài và chạy dịch vụ Jenkins"
apt-get update
apt-get install -y jenkins
systemctl enable --now jenkins

echo "==> 4/4 Chờ Jenkins khởi động (tối đa ~90 giây)"
for i in $(seq 1 45); do
  if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then break; fi
  sleep 2
done

echo
echo "Xong. Mở trình duyệt: http://localhost:8080"
echo "Mật khẩu mở khóa ban đầu:"
cat /var/lib/jenkins/secrets/initialAdminPassword 2>/dev/null || echo "(chưa có, đợi thêm rồi chạy: sudo cat /var/lib/jenkins/secrets/initialAdminPassword)"
