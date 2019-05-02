def loadDataSet(location, skiplist):
	import pandas as pd
	
	dataset = pd.DataFrame()
	
	types_dict = {'Line':str,'Tape':str,'File':str,'Date':np.uint16,'Time':str,
		'Depth_at_Airgun(m)':np.float32,'Depth_at_Reciever(m)':np.float32,
		'X_Airgun':np.float32,'Y_Airgun':np.float32,'Z_Airgun':np.float32,
		'X_R1':np.float32,'Y_R1':np.float32,'Z_R1':np.float32,'Peak_Index':np.float32,
		'Peak_1':np.float32,'Peak_2':np.float32,'Peak_3':np.float32,'Peak_4':np.float32,
		'Peak_5':np.float32,'Peak_6':np.float32,'Peak_7':np.float32,'Peak_8':np.float32,
		'Peak_9':np.float32,'Peak_10':np.float32,'Peak_11':np.float32,'Peak_12':np.float32,
		'Peak_13':np.float32,'T90_1':np.float32,'T90_2':np.float32,'T90_3':np.float32,
		'T90_4':np.float32,'T90_5':np.float32,'T90_6':np.float32,'T90_7':np.float32,
		'T90_8':np.float32,'T90_9':np.float32,'T90_10':np.float32,'T90_11':np.float32,
		'T90_12':np.float32,'T90_13':np.float32,'T90_full':np.float32,'RMS_1':np.float32,
		'RMS_2':np.float32,'RMS_3':np.float32,'RMS_4':np.float32,'RMS_5':np.float32,
		'RMS_6':np.float32,'RMS_7':np.float32,'RMS_8':np.float32,'RMS_9':np.float32,
		'RMS_10':np.float32,'RMS_11':np.float32,'RMS_12':np.float32,'RMS_13':np.float32,
		'RMS_full':np.float32,'SEL_1':np.float32,'SEL_2':np.float32,'SEL_3':np.float32,
		'SEL_4':np.float32,'SEL_5':np.float32,'SEL_6':np.float32,'SEL_7':np.float32,
		'SEL_8':np.float32,'SEL_9':np.float32,'SEL_10':np.float32,'SEL_11':np.float32,
		'SEL_12':np.float32,'SEL_13':np.float32,'SEL_full':np.float32,'SPL_MLM_1':np.float32,
		'SPL_MLM_2':np.float32,'SPL_MLM_3':np.float32,'SPL_MLM_4':np.float32,
		'SPL_MLM_5':np.float32,'SPL_MLM_6':np.float32,'SPL_MLM_7':np.float32,
		'SPL_MLM_8':np.float32,'SPL_MLM_9':np.float32,'SPL_MLM_10':np.float32,
		'SPL_MLM_11':np.float32,'SPL_MLM_12':np.float32,'SPL_MLM_13':np.float32,
		'SPL_MLM_full':np.float32,'SEL_MLM_1':np.float32,'SEL_MLM_2':np.float32,
		'SEL_MLM_3':np.float32,'SEL_MLM_4':np.float32,'SEL_MLM_5':np.float32,
		'SEL_MLM_6':np.float32,'SEL_MLM_7':np.float32,'SEL_MLM_8':np.float32,
		'SEL_MLM_9':np.float32,'SEL_MLM_10':np.float32,'SEL_MLM_11':np.float32,
		'SEL_MLM_12':np.float32,'SEL_MLM_13':np.float32,'SEL_MLM_full':np.float32}
	
	files = os.listdir(location)
	file = open(skiplist, 'rb',0)
    s = mmap.mmap(file.fileno(), 0, access=mmap.ACCESS_READ)
    
    for filename in sorted(files):
        if s.find(str.encode(filename)) == -1:
            dirname = csv_train_path + filename
            with open(dirname) as csvFile:
                dataset = dataset.append(pd.read_csv(location,sep=',',header=0,dtype=types_dict,skiprows=0),ignore_index = True)
	return dataset
