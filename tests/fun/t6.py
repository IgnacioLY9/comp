def add(i: int, j: int) -> int:
    return i + j

def mult(i: int, j: int) -> int:
    return i * j

def chooseAdd(b: bool) -> Callable[[int, int], int]:
    if b:
        return add
    else:
        return mult

x = 1
y = 1
test = True
print(chooseAdd(test)(x,y))
test = False
print(chooseAdd(test)(x,y))