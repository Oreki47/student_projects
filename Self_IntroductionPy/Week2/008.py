# -*- coding: utf-8 -*-
"""
Created on Fri Aug 19 13:33:28 2016

@author: consT_000
"""

 # Paste your code into this box 
outnum=0
innum=0
k=0
po=0
while k<len(s)-1:
    if ord(s[k])<=ord(s[k+1]):
        innum=innum+1
    else:
        innum=0
    if outnum<innum:
        outnum=innum
        po=k-innum+1
    k=k+1
print s[po:po+outnum+1]