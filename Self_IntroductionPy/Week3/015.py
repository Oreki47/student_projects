def hangman(secretWord):
    '''
    secretWord: string, the secret word to guess.

    Starts up an interactive game of Hangman.

    * At the start of the game, let the user know how many 
      letters the secretWord contains.

    * Ask the user to supply one guess (i.e. letter) per round.

    * The user should receive feedback immediately after each guess 
      about whether their guess appears in the computers word.

    * After each round, you should also display to the user the 
      partially guessed word so far, as well as letters that the 
      user has not yet guessed.

    Follows the other limitations detailed in the problem write-up.
    '''
    # FILL IN YOUR CODE HERE...
    numLeft=8
    lettersGuessed=[]
    flag=0
    str1=''
    print 'Welcome to the game, Hangman!'
    print 'I am thinking of a word that is ' + str(len(secretWord)) + ' letters long.\n'
    
    while(flag==0):
        print'-----------'
        print 'You have ' + str(numLeft) + ' guesses left.'
        print "Available letters: " + getAvailableLetters(lettersGuessed)
        letterThisRound=raw_input('Please guess a letter: ')
        if letterThisRound in lettersGuessed:
            str1=getGuessedWord(secretWord, lettersGuessed)
            print "Oops! You've already guessed that letter:" + str1

        else:
            lettersGuessed.append(letterThisRound)
            if letterThisRound in secretWord:
                str1=getGuessedWord(secretWord, lettersGuessed)
                print 'Good guess: ' + str1
                if '_' not in getGuessedWord(secretWord, lettersGuessed):
                    flag=1
                    print'-----------'
                    print 'Congratulations, you won!'
            else:
                str1=getGuessedWord(secretWord, lettersGuessed)
                print 'Oops! That letter is not in my word: ' + str1
                numLeft -= 1
            if numLeft==0:
                print'-----------'
                print 'Sorry, you ran out of guesses. The word was ' + secretWord + '.'
                break