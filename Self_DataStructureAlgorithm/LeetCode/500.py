class Solution(object):
    def findWords(self, words):
        """
        :type words: List[str]
        :rtype: List[str]
        """
        # there is a regex that is way beyound me currently.

        # a bit faster 
        top = set('qwertyuiop')
        med = set('asdfghjkl')
        bot = set('zxcvbnm')
        results = []
        
        for word in words:
            w = set(word.lower())
            if w.issubset(top) or w.issubset(med) or w.issubset(bot):
                results.append(word)
        return results


        # set operation and interception O(nm) time and O(nm) space
        # a very long and primitive solution
        
        top = set('qwertyuiop')
        med = set('asdfghjkl')
        bot = set('zxcvbnm')
        results = []
        for word in words:
            
            lower = word.lower()
            flag = True
            
            for letter in lower:
                if letter not in top:
                    flag = False
            if flag == True:
                results.append(word)
            else: flag = True
                
            for letter in lower:
                if letter not in med:
                    flag = False       
            if flag == True:
                results.append(word)
            else: flag = True

            for letter in lower:
                if letter not in bot:
                    flag = False       
            if flag == True:
                results.append(word)
                
        return results