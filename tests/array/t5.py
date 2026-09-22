A = [1,2,3,4,1,2]
B = [2,1,2,0,0,3]
C = [0,0,0,0]

Anr = 2
Anc = 3
Ars = 3
Acs = 1

Bnr = 3
Bnc = 2
Brs = 2
Bcs = 1

Cnr = 2
Cnc = 2
Crs = 2
Ccs = 1

i = 0
while i < Anr:
    j = 0
    while j < Bnc:
        sum = 0
        k = 0
        while k < Anc:
            sum = sum + A[i*Ars + k*Acs] * B[j*Bcs + k*Brs]
            k = k + 1
        C[i*Crs + j*Ccs] = sum
        j = j + 1
    i = i + 1

t = 0
while t < len(C):
    print(C[t])
    t = t + 1