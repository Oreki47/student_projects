def howMany(aDict):
    '''
    aDict: A dictionary, where all the values are lists.

    returns: int, how many values are in the dictionary.
    '''
    # Your Code Here
    count=0
    aValue=aDict.values()
    for a in aValue:
        count += len(a)  
        
    return count
