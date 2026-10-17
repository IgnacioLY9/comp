def extend(t: tuple[int, int]) -> tuple[int, int, int, int]:
    return (t[0], t[1], t[0], t[1])

x = (3,5)
y = extend(x)
print(y[0])
print(y[1])
print(y[2])
print(y[3])