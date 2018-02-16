def isIn(char, aStr):
    '''
    char: a single character
    aStr: an alphabetized string
    
    returns: True if char is in aStr; False otherwise
    '''
    # Your code here
    if aStr=='':
        return False
    elif aStr[(len(aStr)-1)/2]==char:
        return True
    elif aStr[-1]==aStr[0]:
        return False
    elif char> aStr[(len(aStr)-1)/2]:
        return isIn(char, aStr[((len(aStr)-1)/2+1):len(aStr)])
    else:
        return isIn(char, aStr[0:((len(aStr)-1)/2)])
