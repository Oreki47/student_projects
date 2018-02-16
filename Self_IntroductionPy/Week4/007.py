def playHand(hand, wordList, n):
    """
    Allows the user to play the given hand, as follows:

    * The hand is displayed.
    * The user may input a word or a single period (the string ".") 
      to indicate they're done playing
    * Invalid words are rejected, and a message is displayed asking
      the user to choose another word until they enter a valid word or "."
    * When a valid word is entered, it uses up letters from the hand.
    * After every valid word: the score for that word is displayed,
      the remaining letters in the hand are displayed, and the user
      is asked to input another word.
    * The sum of the word scores is displayed when the hand finishes.
    * The hand finishes when there are no more unused letters or the user
      inputs a "."

      hand: dictionary (string -> int)
      wordList: list of lowercase strings
      n: integer (HAND_SIZE; i.e., hand size required for additional points)
      
    """
    score=0
    currentHand=hand.copy()
    isFinished=True
    while(isFinished):
        print 'Current Hand:',
        for letter in hand.keys():
            for j in range(hand[letter]):
                print letter,              # print all on the same line
        print  
        word=raw_input('Enter word, or a "." to indicate that you are finished: ')
        if word=='.':
            print 'Goodbye! Total score: '+str(score)+' points.'
            isFinished=False
            break          
        if isValidWord(word, hand, wordList):
            score=score+getWordScore(word, n)
            currentHand=updateHand(currentHand, word) 
            print '"' +word + '" earned ' + str(getWordScore(word, n)) + ' points.',
            print 'Total: ' + str(score) + ' points'          
        else:
            print 'Invalid word, please try again.'
        
        if calculateHandlen(currentHand)==0:
            print 'Run out of letters. Total score: ' + str(score) + ' points.'
            isFinished=False


