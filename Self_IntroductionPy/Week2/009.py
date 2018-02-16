# -*- coding: utf-8 -*-
"""
Created on Fri Aug 19 13:33:28 2016

@author: consT_000
"""

 # Paste your code into this box 
k=1
monthlyInterestRate = annualInterestRate/12
paid=0
while(k<13):
    minimunMonthlyPayment=round(monthlyPaymentRate*balance,2)
    remainingBalance=round(balance-minimunMonthlyPayment,2)
    remainingBalance=round(remainingBalance*(1+monthlyInterestRate),2) 
    print "Month: " + str(k)
    print "Minimum monthly payment: " + str(minimunMonthlyPayment)
    print "Remaining balance: " + str(remainingBalance)
    balance=remainingBalance
    paid=paid+minimunMonthlyPayment
    k=k+1
print "Total paid: "+str(paid)
print "Remaining balance: " + str(remainingBalance)