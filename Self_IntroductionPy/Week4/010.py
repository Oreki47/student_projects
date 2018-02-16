def compChooseWord(hand, wordList, n):
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
            
    

def compPlayHand(hand, wordList, n):
    score=0
    currentHand=hand.copy()
    isFinished=False

    while(not isFinished):
        wordNow=compChooseWord(currentHand, wordList, n)
        if wordNow!=None:
            print 'Current Hand:',
            for letter in currentHand.keys():
                for j in range(currentHand[letter]):
                     print letter,   
            print # print all on the same line    
            score=score+getWordScore(wordNow, n)
            currentHand=updateHand(currentHand, wordNow)
            for key in currentHand.keys():
                if currentHand[key]==0:
                    del currentHand[key]
            print '"' +wordNow + '" earned ' + str(getWordScore(wordNow, n)) + ' points.',
            print 'Total score: ' + str(score) + ' points'
        else:
            if currentHand!=None:
                for letter in currentHand.keys():
                    for j in range(currentHand[letter]):
                         print letter,   
                print # print all on the same line                 
            print 'Total: ' + str(score) + ' points'
            isFinished=True
            
            