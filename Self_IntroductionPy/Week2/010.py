# -*- coding: utf-8 -*-
"""
Created on Fri Aug 19 13:33:28 2016

@author: consT_000
"""

 # Paste your code into this box 
paid=0
k=1
monthlyInterestRate = annualInterestRate/12
for a in range(99):
    k=1
    paid=paid+1
    remainingbalance=balance
    while(k<13):
        remainingbalance=round(remainingbalance-paid*10,2)
        remainingbalance=round(remainingbalance*(1+monthlyInterestRate),2)
        k=k+1
    if remainingbalance<0:
        break
print "Lowest Payment: "+ str(paid*10)