class Solution(object):
    def anagramMappings(self, A, B):
        """
        :type A: List[int]
        :type B: List[int]
        :rtype: List[int]
        """
        # using hash-map O(n) time and O(n) space 
        temp = {}
        for i, b in enumerate(B):
            if b not in temp:
                temp[b] = i
        return [temp[a] for a in A]
                     
        # stupid way O(n^2) time and O(n) space
        result = []
        for num_A in A:
            for j, num_B in enumerate(B):
                if num_A == num_B:
                    result.append(j)
                    break
        return result