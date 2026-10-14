"""App mẫu cho demo pipeline Jenkins - máy tính bỏ túi đơn giản."""


def add(a, b):
    return a + b


def subtract(a, b):
    return a - b


def multiply(a, b):
    return a * b


def divide(a, b):
    if b == 0:
        raise ValueError("Không thể chia cho 0")
    return a / b


if __name__ == "__main__":
    print("Máy tính bỏ túi:")
    print(f"2 + 3 = {add(2, 3)}")
    print(f"10 - 4 = {subtract(10, 4)}")
    print(f"6 * 7 = {multiply(6, 7)}")
    print(f"20 / 5 = {divide(20, 5)}")
