def getAvailableLetters(lettersGuessed):
    '''
    lettersGuessed: list, what letters have been guessed so far
    returns: string, comprised of letters that represents what letters have not
      yet been guessed.
    '''
    # FILL IN YOUR CODE HERE...
    string1=string.ascii_lowercase
    string2=''
    for letter in string1:
        if letter not in lettersGuessed:
            string2 += letter
    return string2