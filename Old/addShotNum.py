import os
import scipy.io as sp
import pandas
import pickle

df = pickle.load(open("D:\CSV\Pickles\MGL1212.pickel", 'rb'))#load dataframe as df

#load each P190
nav = loadmat('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\Full\')['nav']

df['Shot_Number'] = 0#default initialization


