def biggest(aDict):
    '''
    aDict: A dictionary, where all the values are lists.

    returns: The key with the largest number of values associated with it
    '''
    # Your Code Here
    if len(aDict.keys())==0:
        return None
    num=-1
    aKey=aDict.keys()
    for a in aKey:
        if num<len(aDict[a]):
            num=len(aDict[a])
            keys=a
    return keys
