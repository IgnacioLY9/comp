z = False
x = 1
y = 1
if z:
    print(y + 2 if (x == 0 if x < 1 else x == 2) else y + 10)
else:
    print(y + 3 if (x == 0 if x < 1 else x == 2) else y + 12)
