A = [2, 2]
B = [3, 3]
a = [A, B]
i = 0
prod = 0
while i != len(A):
    prod = prod + A[i] * B[i]
    i = i + 1
print(prod)
