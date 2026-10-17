def twoByTwoGEMM(A: list[list[int]], B: list[list[int]]) -> list[list[int]]:
    C = [[0,0], [0,0]]
    i = 0
    while i < len(A):
        j = 0
        while j < len(B[0]):
            sum = 0
            k = 0
            while k < len(A[0]):
                sum = sum + A[i][k] * B[k][j]
                k = k + 1
            C[i][j] = sum
            j = j + 1
        i = i + 1
    return C

A = [[1,2,3],[4,1,2]]
B = [[2,1],[2,0],[0,3]]
C = twoByTwoGEMM(A, B)

t = 0
while t < len(C):
    p = 0
    while p < len(C[0]):
        print(C[t][p])
        p = p + 1
    t = t + 1