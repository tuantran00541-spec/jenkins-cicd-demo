import unittest

from app import ScienceCalculator


class TestScienceCalculator(unittest.TestCase):
    """5 unit test: 4 kiểm tra kết quả đúng và 1 kiểm tra bắt ngoại lệ."""

    def test_add(self):
        """Cộng 2 + 3 phải bằng 5"""
        self.assertEqual(ScienceCalculator.add(2, 3), 5)

    def test_power(self):
        """2 mũ 10 phải bằng 1024"""
        self.assertEqual(ScienceCalculator.power(2, 10), 1024)

    def test_sqrt(self):
        """Căn bậc hai của 144 phải bằng 12"""
        self.assertEqual(ScienceCalculator.sqrt(144), 12)

    def test_sqrt_negative_raises(self):
        """Căn bậc hai của số âm phải báo ValueError"""
        with self.assertRaises(ValueError):
            ScienceCalculator.sqrt(-1)

    def test_factorial(self):
        """5 giai thừa phải bằng 120"""
        self.assertEqual(ScienceCalculator.factorial(5), 120)


if __name__ == "__main__":
    unittest.main()
