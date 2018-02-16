def compChooseWord(hand, wordList, n):
    """
    Given a hand and a wordList, find the word that gives 
    the maximum value score, and return it.

    This word should be calculated by considering all the words
    in the wordList.

    If no words in the wordList can be made from the hand, return None.

    hand: dictionary (string -> int)
    wordList: list (string)
    returns: string or None
    """
    # Create a new variable to store the maximum score seen so far (initially 0)
    scoreMax=0
    # Create a new variable to store the best word seen so far (initially None)  
    wordBest=0
    # For each word in the wordList
    for eachword in wordList:
        if isValidWord(eachword, hand, wordList):
            if  getWordScore(eachword, n)>scoreMax:
                scoreMax=getWordScore(eachword, n)
                wordBest=eachword
                
    if wordBest==0:
        return None                  
    return wordBest
            
    