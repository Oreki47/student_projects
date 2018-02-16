class Solution(object):
    def islandPerimeter(self, grid):
        """
        :type grid: List[List[int]]
        :rtype: int
        """
        
        # adjusted: i + 1 will not be a problem
        # since it will captured by try/except block
        # O(nm) time 
        n = len(grid)
        m = len(grid[0])
        sqr_cnt = 0
        int_cnt = 0
        for i in range(n):
            for j in range(m):
                if grid[i][j] == 1:
                    sqr_cnt += 1
                    
                    try:
                        if grid[i+1][j] == 1:
                            int_cnt += 1
                    except: pass

                    try:
                        if grid[i][j+1] == 1:
                            int_cnt += 1
                    except: pass
                    
        
        # return sqr_cnt*4 - int_cnt*2


        # O(nm) time
        # wrong because for instance [0-1] would go back to the other side
        n = len(grid)
        m = len(grid[0])
        sqr_cnt = 0
        int_cnt = 0
        for i in range(n):
            for j in range(m):
                if grid[i][j] == 1:
                    sqr_cnt += 1
                    
                    try:
                        if grid[i+1][j] == 1:
                            int_cnt += 1
                    except: pass

                    try:
                        if grid[i-1][j] == 1:
                            int_cnt += 1
                    except: pass

                    try:
                        if grid[i][j+1] == 1:
                            int_cnt += 1
                    except: pass

                    try:
                        if grid[i][j-1] == 1:
                            int_cnt += 1
                    except: pass
                    
        
        return sqr_cnt*4 - int_cnt