"""
# Employee info
class Employee(object):
    def __init__(self, id, importance, subordinates):
        # It's the unique id of each node.
        # unique id of this employee
        self.id = id
        # the importance value of this employee
        self.importance = importance
        # the id of direct subordinates
        self.subordinates = subordinates
"""
class Solution(object):
    def getImportance(self, employees, id):
        """
        :type employees: Employee
        :type id: int
        :rtype: int
        """
        #O(n) time and O(n) space
        # Wait I feel like I used BFS here.
        # There is only n employees in total 
        emp_dict = {}
        for employee in employees:
            emp_dict[employee.id] = employee
            
        temp = {}
        tot_imp = 0
        temp[id] = emp_dict[id]
        
        while temp != {}:
            for leader_id in temp.keys():
                tot_imp += emp_dict[leader_id].importance
                for sub_id in emp_dict[leader_id].subordinates:
                    temp[sub_id] = emp_dict[sub_id].subordinates
                temp.pop(leader_id)
            
                    
        return tot_imp