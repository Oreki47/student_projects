class Solution(object):
    def singleNumber(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        # Match approach

        # Bit manipulation

        # Passed O(n) for time and O(n) for space
        stack = {}
        for num in nums:
            stack[num] = 1 + stack.get(num, 0)
        
        for key in stack.keys():
            if stack[key] == 1:
                return key
        
        # Time-limit reached, yet O(n^2) if the list is increasing sequentially.
        stack = {}
        for num in nums:
            if num in stack.keys():
                stack.pop(num)
            else:
                stack[num] = 0
        return stack.keys()[0]

        # a better way to do is is to use EAFP
        stack = {}
        for num in nums:
            try:
                stack.pop(num)
            except:
                stack[num] = 0
        return stack.keys()[0]