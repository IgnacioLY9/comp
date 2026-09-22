A = [1,2,3,4,5]
B = [2,3,1,0,1]

dot = 0
i = 0
while i < len(A):
    dot = dot + A[i] * B[i]
    i = i + 1

print(dot)