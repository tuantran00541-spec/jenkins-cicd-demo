"""ScienceCalculator - ứng dụng mẫu cho demo Jenkins CI/CD (Đề tài 37).

Chạy thử từ dòng lệnh:
    python3 app.py add 2 3          -> 5
    python3 app.py power 2 10       -> 1024
    python3 app.py sqrt 144         -> 12.0
    python3 app.py factorial 5      -> 120
"""
import math
import sys


class ScienceCalculator:
    """Bốn phép tính tĩnh, đủ nhỏ để minh họa Build, Test và Deploy."""

    @staticmethod
    def add(a, b):
        return a + b

    @staticmethod
    def power(base, exponent):
        return base ** exponent

    @staticmethod
    def sqrt(x):
        if x < 0:
            raise ValueError("Không thể lấy căn bậc hai của số âm")
        return math.sqrt(x)

    @staticmethod
    def factorial(n):
        if not isinstance(n, int) or n < 0:
            raise ValueError("Giai thừa chỉ áp dụng cho số nguyên không âm")
        return math.factorial(n)


def _number(text):
    """Đọc số nguyên nếu được, nếu không thì đọc số thực."""
    try:
        return int(text)
    except ValueError:
        return float(text)


def main(argv):
    operations = {
        "add": (ScienceCalculator.add, 2),
        "power": (ScienceCalculator.power, 2),
        "sqrt": (ScienceCalculator.sqrt, 1),
        "factorial": (ScienceCalculator.factorial, 1),
    }
    if len(argv) < 2 or argv[1] not in operations:
        print("Cách dùng: python3 app.py <add|power|sqrt|factorial> <số> [số]")
        return 2
    func, arity = operations[argv[1]]
    args = [_number(a) for a in argv[2:]]
    if len(args) != arity:
        print(f"Phép '{argv[1]}' cần {arity} số.")
        return 2
    try:
        print(func(*args))
    except ValueError as err:
        print(f"Lỗi: {err}")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
