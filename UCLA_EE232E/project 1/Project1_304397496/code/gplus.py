import pandas as pd
import os
pd.set_option('display.expand_frame_repr', False)

''' 
Find all circles
Create index
'''
idx = pd.DataFrame(os.listdir('plus')).apply(lambda x: str(x)[5:26], axis=1).\
    drop_duplicates().reset_index(drop=True)
idx.index += 1


'''
Reshape all +2 .circle
Save as .csv
'''
for i in idx.index:
    with open('plus/' + str(idx[i]) + '.circles') as f:
        content = f.readlines()
    if len(content) > 1:
        df = pd.DataFrame()
        for line in content:
            temp = line.split()
            temp = pd.DataFrame({temp[0]:temp[1:]})
            df = pd.concat([df, temp], axis=1)
        df.to_csv('circles/' + str(idx[i]) + '.csv', index=False)
    else:
        idx.drop(i, inplace=True)

'''
Save index as .csv
'''
idx.to_csv('index.csv', index=True)

for i in idx.index:
    with open('plus/' + str(idx[i]) + '.circles') as f:
        content = f.readlines()




