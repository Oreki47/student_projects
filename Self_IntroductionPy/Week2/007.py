# -*- coding: utf-8 -*-
"""
Created on Fri Aug 19 13:33:28 2016

@author: consT_000
"""

 # Paste your code into this box 
n=0
k=0
while (k<len(s)-2):
    if (s[k]=='b' and s[k+1]=='o' and s[k+2]=='b'):
        n=n+1
    k=k+1
print ("Number of times bob occurs is: " +str(n))