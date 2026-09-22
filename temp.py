def load(l, idx):
    return l[idx]

def exit():
    raise Exception ('exit')

A = [[1,2], [3,4]]
print((
    load((load(A, 0) 
          if (len(A) > 0 
              if 0 >= 0 
              else False) 
          else exit()), 1)
    if (len((load(A, 0) if (len(A) > 0 if 0 >= 0 else False) else exit())) > 1 
        if 1 >= 0 
        else False)
    else exit()))