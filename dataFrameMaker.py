from loadDataSet import loadDataSet
import pickle

skiplist = r'C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Lists\skip.txt'

data1 = loadDataSet(r'D:\CSV\Line_01', skiplist)
pickle.dump(data1, open(r'D:\CSV\Pickles\Line_01.pickel', 'wb'))

data2 = loadDataSet(r'D:\CSV\Line_02', skiplist)
pickle.dump(data2, open(r'D:\CSV\Pickles\Line_02.pickel', 'wb'))

data3 = loadDataSet(r'D:\CSV\Line_03', skiplist)
pickle.dump(data3, open(r'D:\CSV\Pickles\Line_03.pickel', 'wb'))

data4 = loadDataSet(r'D:\CSV\Line_04', skiplist)
pickle.dump(data4, open(r'D:\CSV\Pickles\Line_04.pickel', 'wb'))

data5 = loadDataSet(r'D:\CSV\Line_05', skiplist)
pickle.dump(data5, open(r'D:\CSV\Pickles\Line_05.pickel', 'wb'))

data6 = loadDataSet(r'D:\CSV\Line_06', skiplist)
pickle.dump(data6, open(r'D:\CSV\Pickles\Line_06.pickel', 'wb'))

data7 = loadDataSet(r'D:\CSV\Line_07', skiplist)
pickle.dump(data7, open(r'D:\CSV\Pickles\Line_07.pickel', 'wb'))

data8 = loadDataSet(r'D:\CSV\Line_08', skiplist)
pickle.dump(data8, open(r'D:\CSV\Pickles\Line_08.pickel', 'wb'))

data9 = loadDataSet(r'D:\CSV\Line_09', skiplist)
pickle.dump(data9, open(r'D:\CSV\Pickles\Line_09.pickel', 'wb'))

data10 = loadDataSet(r'D:\CSV\Line_10', skiplist)
pickle.dump(data10, open(r'D:\CSV\Pickles\Line_10.pickel', 'wb'))

data11 = loadDataSet(r'D:\CSV\Line_11', skiplist)
pickle.dump(data11, open(r'D:\CSV\Pickles\Line_11.pickel', 'wb'))

dataat = loadDataSet(r'D:\CSV\Line_AT', skiplist)
pickle.dump(dataat, open(r'D:\CSV\Pickles\Line_AT.pickel', 'wb'))

data = pd.concat([data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, dataat], ignore_index=True, sort=False)
pickle.dump(data, open(r'D:\CSV\Pickles\MGL1212.pickel', 'wb'))

xd = pickle.load(open("D:\CSV\Pickles\MGL1212.pickel", 'rb'))#809250
print(xd.shape)


