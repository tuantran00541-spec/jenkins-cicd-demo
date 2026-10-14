pipeline {
    agent any

    stages {
        stage('1. Lấy mã nguồn') {
            steps {
                // Jenkins tự pull code mới nhất từ GitHub (qua webhook)
                checkout scm
            }
        }

        stage('2. Biên dịch') {
            steps {
                sh 'python3 -m py_compile app.py'
                sh 'pip install -r requirements.txt'
            }
        }

        stage('3. Chạy kiểm thử') {
            steps {
                sh 'python3 -m pytest test_app.py -v'
            }
        }

        stage('4. Triển khai') {
            steps {
                // Demo: đóng gói app thành artifact triển khai
                sh 'mkdir -p deploy && cp app.py deploy/ && tar -czf deploy/calculator-app.tar.gz -C deploy app.py'
                echo 'Triển khai xong: deploy/calculator-app.tar.gz'
            }
        }
    }

    post {
        success {
            echo 'PIPELINE THÀNH CÔNG - code đã qua đủ 4 bước!'
        }
        failure {
            echo 'PIPELINE THẤT BẠI - kiểm tra log stage bị đỏ.'
        }
    }
}
