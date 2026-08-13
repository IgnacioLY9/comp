x = True
t = (False, x and False)
if t[1]:
    print(0)
else:
    print(1)
