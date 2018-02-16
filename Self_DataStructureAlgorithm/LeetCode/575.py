class Solution(object):
    def distributeCandies(self, candies):
        """
        :type candies: List[int]
        :rtype: int
        """

        # O(n) time and O(n) space 
        temp = {}
        for c in candies:
            temp[c] = 0
        return min(len(temp), len(candies) // 2)