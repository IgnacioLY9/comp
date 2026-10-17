def one(x:int) -> int:
    return x + 1
def two(x:int) -> int:
    return x + 2
def three(x:int) -> int:
    return x + 3
def four(x:int) -> int:
    return x + 4

A = [one, two, three, four]
print(A[1](5))