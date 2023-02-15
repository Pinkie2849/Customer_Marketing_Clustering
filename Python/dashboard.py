import streamlit as st
import pandas as pd
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
import seaborn as sns
import plotly.graph_objs as go

df = pd.read_csv('Python/market.csv')

 
# Create the Streamlit app layout
st.title('Customer Segmentation App')
st.write('Please enter the following details to find your customer segment:')
age = st.slider('Age', 18,70, 30)
income = st.slider('Annual Income (k$)', 15, 137, 50)
spending = st.slider('Spending Score (1-100)', 1, 100, 50)


# Scale the input data
X= df[['Age','Annual Income (k$)','Spending Score (1-100)']].values
pca = PCA()
pca.fit(X)


pca = PCA(n_components=2)
pca.fit(X)

df_pca_components = pd.DataFrame(
    data=pca.components_.round(2),
    columns=df[['Age','Annual Income (k$)','Spending Score (1-100)']].columns.values,
    index=['component 1', 'component 2'])


pca_scores = pca.transform(X)

results = {}

for i in range(1, 11):
    kmeans_pca = KMeans(n_clusters=i, init='k-means++', random_state=42)
    kmeans_pca.fit(pca_scores)
    results[i] = kmeans_pca.inertia_

kmeans_pca = KMeans(n_clusters=5, init='k-means++', random_state=42)
kmeans_pca.fit(pca_scores)
df_segm_pca = pd.concat([df.reset_index(drop=True), pd.DataFrame(pca_scores)], axis=1)
df_segm_pca.columns.values[-2:] = ['component 1', 'component 2']
df_segm_pca['K-means PCA'] = kmeans_pca.labels_

df_segm_pca_analysis = df_segm_pca.groupby(['K-means PCA']).mean().round(4)
df_segm_pca['Segment'] = df_segm_pca['K-means PCA'].map({
    0: 'Average Income/Spenders',
    1: 'High Income/Spenders',
    2: 'Low Income/Spenders',
    3: 'High Income/Low Spenders',
    4: 'Low Income/High Spenders'
})

# Preprocess the input data
input_data = pd.DataFrame({'Age': [age], 'Annual Income (k$)': [income], 'Spending Score (1-100)': [spending]})
input_data = input_data[df[['Age', 'Annual Income (k$)', 'Spending Score (1-100)']].columns]


# Transform the input data using the PCA object
pca_input = pca.transform(input_data)

# Predict the segment using the KMeans object
segment = kmeans_pca.predict(pca_input)

# Return the segment assigned to the input data
st.write(f'Your customer segment is: {df_segm_pca.loc[segment[0], "Segment"]}')

# Create the scatter plot using Plotly Go
fig = go.Figure()

# Add traces for each segment
segments = df_segm_pca['Segment'].unique()
colors = ['green', 'red', 'cyan', 'magenta', 'blue']

for i, segment in enumerate(segments):
    x = df_segm_pca.loc[df_segm_pca['Segment'] == segment, 'component 2']
    y = df_segm_pca.loc[df_segm_pca['Segment'] == segment, 'component 1']
    fig.add_trace(go.Scatter(x=x, y=y, mode='markers', marker=dict(size=10, color=colors[i], line=dict(width=2, color=colors[i])), name=segment))
fig.add_trace(go.Scatter(x=[pca_input[0,0]], y=[pca_input[0,1]]))


# Set the layout
fig.update_layout(title='Component 1 vs Component 2', width=800, height=600)

st.plotly_chart(fig)