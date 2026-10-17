def square(x: int) -> int:
    return x * x

def inc(x: int) -> int:
    return x + 1

def complicated(x: int) -> int:
    if x > 10:
        return x
    return complicated(inc(square(x)))

print(complicated(1))