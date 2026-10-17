def fib(n: int) -> int:
    if n == 0:
        return 0
    if n == 1:
        return 1
    minus1 = fib(n-1)
    minus2 = fib(n-2)
    return minus1 + minus2

print(fib(8))