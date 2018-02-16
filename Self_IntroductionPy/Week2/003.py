print 'Please think of a number between 0 and 100!'
low=0
high=100
guess=(low+high)/2
while(True):
    print ("Is your secret number " + str(guess) + '?')
    command=(raw_input("Enter 'h' to indicate the guess is too high. Enter 'l' to indicate the guess is too low. Enter 'c' to indicate I guessed correctly. "))
    if command=='c':
        break
    elif command=='l':
        low=guess
        guess=(low+high)/2
    elif command=='h':
        high=guess
        guess=(low+high)/2
    else:
        print 'Sorry, I did not understand your input.'
print ('Game over. Your secret number was: ' + str(guess))