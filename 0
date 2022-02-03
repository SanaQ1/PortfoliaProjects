#!/usr/bin/env python
# coding: utf-8

# In[86]:


#Importing Libraries

import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import matplotlib
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8)

pd.options.mode.chained_assignment = None



# read in the data
df = pd.read_csv(r'C:\Users\User\Desktop\movies1.csv')


# In[87]:


df.head()


# In[88]:


# Lets check if there is any missing data
for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, round(pct_missing*100)))


# In[6]:


df['rating'] = df['rating'].replace(np.nan, 0)


# In[89]:


#Filling in the missing values with zero
for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, round(pct_missing*100)))
    df['rating'] = df['rating'].replace(np.nan, 0)
    df['budget'] = df['budget'].replace(np.nan, 0)
    df['gross'] = df['gross'].replace(np.nan, 0)


# In[90]:


#Data types for our columns
df.dtypes


# In[91]:


# Changing the data type of Budget and gross columns so they look little neater.
df['budget'] = df['budget'].astype('int64')
df['gross']=df['gross'].astype('int64')
df.dtypes


# In[92]:


df.head()


# In[94]:


#Create a 'year and state' column from 'released' column 
df['year released'] = df['released'].astype('str').str.rsplit(',').str[-1]

df.head()


# In[96]:


df['released year'] = df['year released'].astype('str').str[:5]
df.head()


# In[97]:


del df['year released']


# In[98]:


df.head()


# In[100]:


# Sorting the data to see highest grossing movies

df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[102]:


# Selecting all the rows of the data without anything being hidden

pd.set_option ('display.max_rows', None)

df =df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[103]:


#Drop any duplicates in Company column
#df['company'] =df['company'].drop_duplicates()   --to drop
#But we don't want to drop all repeting companies so we just see how it works
df['company'].drop_duplicates()


# In[105]:



# Finding Correlation between Budget and Gross columns by Scatter plot

plt.scatter(x=df['budget'],y=df['gross'])
plt.title('Budget vs Gross Earning')
plt.xlabel('Budget')
plt.ylabel('Gross Earning')
plt.show()


# In[106]:


# Plotting budget vs gross using seaborn for regression plot to see if correlaion exists

sns.regplot(x='budget', y='gross',data=df, scatter_kws={"color": "red"},line_kws={"color":"blue"})


# In[107]:


# Looking at Correlation

df.corr()


# In[108]:


# Three types of correlaion -- pearson, kendall, spearson --default is pearson
df.corr(method="kendall")


# In[109]:


#There is a high correlaion between budget and gross
# lets create a heat map to have a better visual of the correlation matrix above

correlation_matrix = df.corr()

sns.heatmap(correlation_matrix, annot=True)
plt.title("Correlation Matrix of Numeric Features")
plt.xlabel("Movie Features")
plt.ylabel("Movie Features")
plt.show()


# In[110]:


# To see the correlaion of gross with non-numeric fields, we can numerized them


df_numerized = df


for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name]= df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes
        
df_numerized


# In[111]:


correlation_matrix = df_numerized.corr()

sns.heatmap(correlation_matrix, annot=True)
plt.title("Correlation Matrix of Numeric Features")
plt.xlabel("Movie Features")
plt.ylabel("Movie Features")
plt.show()


# In[112]:


df_numerized.corr()


# In[114]:


#Unstack the above matrix to get a better idea 

correlation_mat = df_numerized.corr()
corr_groups = correlation_mat.unstack()
corr_groups


# In[115]:


#Sorting the above corr_groups

sorted_group= corr_groups.sort_values()
sorted_group


# In[117]:


#Now lets see the high correlation ones

high_correlations = sorted_group[(sorted_group)>0.5]


# In[118]:


high_correlations


# In[ ]:




