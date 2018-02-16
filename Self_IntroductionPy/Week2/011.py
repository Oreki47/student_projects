# -*- coding: utf-8 -*-
"""
Created on Fri Aug 19 13:33:28 2016

@author: consT_000
"""

 # Paste your code into this box 
# Paste your code into this box
lo=round(balance/12,2)
hi=round(balance*(1+annualInterestRate/12)**12/12,2)
monthlyInterestRate = annualInterestRate/12
guess=round((lo+hi)/2,2)
for a in range(1000):
    k=1
    remainingbalance=balance
    while(k<13):
        remainingbalance=round(remainingbalance-guess,2)
        remainingbalance=round(remainingbalance*(1+monthlyInterestRate),2)
        k=k+1
    if (remainingbalance>1):
        lo=guess
    elif (remainingbalance<-1):
        hi=guess
    else:
        break
    guess=round((lo+hi)/2,2)
print "Lowest Payment:"+str(guess)
        
        