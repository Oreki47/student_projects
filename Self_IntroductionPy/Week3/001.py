def iterPower(base, exp):
    '''
    base: int or float.
    exp: int >= 0
 
    returns: int or float, base^exp
    '''
    # Your code here
    p=1
    while exp>0:   
        p=p*base
        exp=exp-1
    return p
