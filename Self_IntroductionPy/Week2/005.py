# -*- coding: utf-8 -*-
"""
Created on Fri Aug 19 13:33:28 2016

@author: consT_000
"""

def isVowel2(char):
    '''
    char: a single letter of any case

    returns: True if char is a vowel and False otherwise.
    '''
    if char in "aeiouAEIOU":   
        return True
    else:
        return False