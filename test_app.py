"""Test suite cho app mẫu - chạy bằng pytest trong stage 'Chạy kiểm thử'."""

import pytest

from app import add, subtract, multiply, divide


def test_add():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0


def test_subtract():
    assert subtract(10, 4) == 6
    assert subtract(0, 5) == -5


def test_multiply():
    assert multiply(6, 7) == 42
    assert multiply(-2, 3) == -6


def test_divide():
    assert divide(20, 5) == 4
    assert divide(7, 2) == 3.5


def test_divide_by_zero():
    with pytest.raises(ValueError):
        divide(10, 0)
