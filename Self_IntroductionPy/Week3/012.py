def isWordGuessed(secretWord, lettersGuessed):
    '''
    secretWord: string, the word the user is guessing
    lettersGuessed: list, what letters have been guessed so far
    returns: boolean, True if all the letters of secretWord are in lettersGuessed;
      False otherwise
    '''
    # FILL IN YOUR CODE HERE...
    flag=1
    for letter in secretWord:
        if letter in lettersGuessed:
            flag=flag
        else:
            flag=0
    return bool(flag)
    