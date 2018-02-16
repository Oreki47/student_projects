class Solution(object):
    def intersection(self, nums1, nums2):
        """
        :type nums1: List[int]
        :type nums2: List[int]
        :rtype: List[int]
        """

        # other solutions are just like playing smart and use implementations of python
        # one shot it, O(n+m) time, O(n+m) space
        temp1 = {}
        temp2 = {}
        intersect = []
        for num in nums1:
            try:
                temp1[num]
            except:
                temp1[num] = 0
        for num in nums2:
            try:
                temp2[num]
            except:
                temp2[num] = 0
        for key in temp1.keys():
            try:
                temp2[key]
                intersect.append(key)
            except:
                pass
        return intersect