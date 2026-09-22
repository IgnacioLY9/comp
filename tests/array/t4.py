A = [1,2,3,4,5]

i = 0
while i < len(A):
    if A[i] == 3:
        A[i] = 0
    print(A[i])
    i = i + 1