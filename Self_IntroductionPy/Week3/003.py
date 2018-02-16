def gcdIter(a, b):
    '''
    a, b: positive integers
    
    returns: a positive integer, the greatest common divisor of a & b.
    '''
    # Your code here
    com=min(a,b)
    while com>1:
        if a%com==0 and b%com==0:
            return com
        else:
            com -=1 
    if com==1:
        return 1