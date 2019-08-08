from loadDataSet import loadDataSet
import pickle

skiplist = r'C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Lists\skip.txt'

data = loadDataSet(r'D:\CSV\Line_01', skiplist)
pickle.dump(data, open(r'D:\CSV\Pickles\Line_01.pickel', 'wb'))
full = data

data = loadDataSet(r'D:\CSV\Line_02', skiplist)
pickle.dump(data, open(r'D:\CSV\Pickles\Line_02.pickel', 'wb'))
full = full.append(data,ignore_index = True)

data = loadDataSet(r'D:\CSV\Line_03', skiplist)
pickle.dump(data, open(r'D:\CSV\Pickles\Line_03.pickel', 'wb'))
full = full.append(data,ignore_index = True)

data = loadDataSet(r'D:\CSV\Line_04', skiplist)
pickle.dump(data, open(r'D:\CSV\Pickles\Line_04.pickel', 'wb'))
full = full.append(data,ignore_index = True)

data = loadDataSet(r'D:\CSV\Line_05', skiplist)
pickle.dump(data, open(r'D:\CSV\Pickles\Line_05.pickel', 'wb'))
full = full.append(data,ignore_index = True)

data = loadDataSet(r'D:\CSV\Line_06', skiplist)
pickle.dump(data, open(r'D:\CSV\Pickles\Line_06.pickel', 'wb'))
full = full.append(data,ignore_index = True)

data = loadDataSet(r'D:\CSV\Line_07', skiplist)
pickle.dump(data, open(r'D:\CSV\Pickles\Line_07.pickel', 'wb'))
full = full.append(data,ignore_index = True)

data = loadDataSet(r'D:\CSV\Line_08', skiplist)
pickle.dump(data, open(r'D:\CSV\Pickles\Line_08.pickel', 'wb'))
full = full.append(data,ignore_index = True)

data = loadDataSet(r'D:\CSV\Line_09', skiplist)
pickle.dump(data, open(r'D:\CSV\Pickles\Line_09.pickel', 'wb'))
full = full.append(data,ignore_index = True)

data = loadDataSet(r'D:\CSV\Line_10', skiplist)
pickle.dump(data, open(r'D:\CSV\Pickles\Line_10.pickel', 'wb'))
full = full.append(data,ignore_index = True)

data = loadDataSet(r'D:\CSV\Line_11', skiplist)
pickle.dump(data, open(r'D:\CSV\Pickles\Line_11.pickel', 'wb'))
full = full.append(data,ignore_index = True)

data = loadDataSet(r'D:\CSV\Line_AT', skiplist)
pickle.dump(data, open(r'D:\CSV\Pickles\Line_AT.pickel', 'wb'))
full = full.append(data,ignore_index = True)

pickle.dump(data, open(r'D:\CSV\Pickles\MGL1212.pickel', 'wb'))

#xd = pickle.load(open("D:\CSV\Pickles\Line_01.pickel", 'rb'))
#print(xd.shape)


