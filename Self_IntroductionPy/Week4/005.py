def isValidWord(word, hand, wordList):
    """
    Returns True if word is in the wordList and is entirely
    composed of letters in the hand. Otherwise, returns False.

    Does not mutate hand or wordList.
   
    word: string
    hand: dictionary (string -> int)
    wordList: list of lowercase strings
    """
    isTrue=True
    if word not in wordList:
        isTrue = False
    handWord=getFrequencyDict(word)
    for letter in handWord.keys():
        if handWord[letter]>hand.get(letter, -1):
            isTrue = False
            break
    return isTrue  
