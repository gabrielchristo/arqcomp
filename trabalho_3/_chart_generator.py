from os import listdir
from os.path import isfile, join

is_using_cache_l2 = False

gnuplot_file = '_chart.plt'
gnuplot_misses = '_chart_misses.plt'

# L1
_bsize = open("_chart_bsize.txt", 'w')
_assoc = open("_chart_assoc.txt", 'w')
_size = open('_chart_size.txt', 'w')
_bsize_tma = open("_chart_bsize_tma.txt", 'w')
_assoc_tma = open("_chart_assoc_tma.txt", 'w')
_size_tma = open('_chart_size_tma.txt', 'w')

# L2
if is_using_cache_l2 is True:
	_bsize_l2 = open("_chart_bsize_l2.txt", 'w')
	_assoc_l2 = open("_chart_assoc_l2.txt", 'w')
	_size_l2 = open('_chart_size_l2.txt', 'w')
	_bsize_tma_l2 = open("_chart_bsize_tma_l2.txt", 'w')
	_assoc_tma_l2 = open("_chart_assoc_tma_l2.txt", 'w')
	_size_tma_l2 = open('_chart_size_tma_l2.txt', 'w')
	
# Misses
l1_compulsory = open('_chart_compulsory.txt', 'w')
l1_capacity = open('_chart_capacity.txt', 'w')
l1_conflict = open('_chart_conflict.txt', 'w')
if is_using_cache_l2 is True:
	l2_compulsory = open('_chart_compulsory_l2.txt', 'w')
	l2_capacity = open('_chart_capacity_l2.txt', 'w')
	l2_conflict = open('_chart_conflict_l2.txt', 'w')

TA1 = 3 #ns
TA2 = 15 #ns

pltDefine1 = "set title 'Capacidade da cache'\nset xlabel 'Valor (KB)'\nset ylabel 'Taxa de falha (%)'\nset multiplot layout 1,2 columnsfirst\nset style line 1 lc rgb 'blue' pt 7\n"
pltPlot1 = "plot '_chart_size.txt' notitle w p ls 1\n"
pltDefine2 = "set title ' '\nset xlabel 'Valor (KB)'\nset ylabel 'Tempo médio de acesso (ns)'\n"
pltPlot2 = "plot '_chart_size_tma.txt' notitle w p ls 1"

### Misses ###
pltDefine3 = "set title 'Misses'\nset xlabel 'Valor (KB)'\nset ylabel 'Compulsory'\nset multiplot layout 1,3 columnsfirst\nset style line 1 lc rgb 'blue' pt 7\n"
pltPlot3 = "plot '_chart_compulsory.txt' notitle w p ls 1\n"
pltDefine4 = "set title ' '\nset xlabel 'Valor (KB)'\nset ylabel 'Capacity'\n"
pltPlot4 = "plot '_chart_capacity.txt' notitle w p ls 1\n"
pltDefine5 = "set xlabel 'Valor (KB)'\nset ylabel 'Conflict'\n"
pltPlot5 = "plot '_chart_conflict.txt' notitle w p ls 1\n"

def getTF(lineSize):
	return 35 + (int(lineSize)/8)*5

def getCurrentDirFiles():
	# return current dir files without the script
	files = [f for f in listdir("./") if isfile(join("./", f))]
	# removing generated files from list
	files.remove('_chart_generator.py')
	files.remove(gnuplot_file)
	files.remove(gnuplot_misses)
	# L1
	files.remove('_chart_size.txt')
	files.remove('_chart_bsize.txt')
	files.remove('_chart_assoc.txt')
	files.remove('_chart_size_tma.txt')
	files.remove('_chart_bsize_tma.txt')
	files.remove('_chart_assoc_tma.txt')
	files.remove('_chart_compulsory.txt')
	files.remove('_chart_capacity.txt')
	files.remove('_chart_conflict.txt')
	# L2
	if is_using_cache_l2 is True:
		files.remove('_chart_size_l2.txt')
		files.remove('_chart_bsize_l2.txt')
		files.remove('_chart_assoc_l2.txt')
		files.remove('_chart_size_tma_l2.txt')
		files.remove('_chart_bsize_tma_l2.txt')
		files.remove('_chart_assoc_tma_l2.txt')
		files.remove('_chart_compulsory_l2.txt')
		files.remove('_chart_capacity_l2.txt')
		files.remove('_chart_conflict_l2.txt')
	
	files.remove('24_1_16_128.txt') # nao rodou esse caso
	return files
	
def getAverageAcessTime(missRate, lineSize, missRateL2 = 0):
	h1 = 1.0 - float(missRate)
	h2 = 1.0 - float(missRateL2)
	if(is_using_cache_l2 is True):
		return h1*TA1 + float(missRate)*(TA2 + float(missRateL2)*getTF(lineSize))
	else:
		return h1*TA1 + float(missRate)*getTF(lineSize)
	
def getEntry(text, line, column):
	return text.split('\n')[line-1].split()[column]
	
def getTotalDemandMissRate(text):
	if is_using_cache_l2 is False:
		return getEntry(text, 37, 3)
	return getEntry(text, 46, 3)
	
def getTotalDemandMissRateL2(text):
	return getEntry(text, 69, 3)
	
def getLineSize(text):
	if(is_using_cache_l2 is False):
		return float(getEntry(text, 12, 1)) / 1000.0 # Bytes to KB
	return float(getEntry(text, 13, 1)) / 1000.0 # Bytes to KB
	
def getLineSizeL2(text):
	return float(getEntry(text, 14, 1)) / 1000.0 # Bytes to KB
	
def getSize(text):
	return float(getEntry(text, 11, 1)) / 1000.0 # Bytes to KB
	
def getSizeL2(text):
	return float(getEntry(text, 12, 1)) / 1000.0 # Bytes to KB
	
def getAssoc(text):
	if(is_using_cache_l2 is False):
		return getEntry(text, 14, 1)
	return getEntry(text, 17, 1)
	
def getAssocL2(text):
	return getEntry(text, 18, 1)
	
	
### Compulsory Misses ###
def getCompulsory(text):
	if is_using_cache_l2 is False:
		return getEntry(text, 41, 2)
	return getEntry(text, 50, 2)
def getCompulsoryL2(text):
	return getEntry(text, 73, 2)

### Capacity Misses ###
def getCapacity(text):
	if is_using_cache_l2 is False:
		return getEntry(text, 42, 2)
	return getEntry(text, 51, 2)
def getCapacityL2(text):
	return getEntry(text, 74, 2)

### Conflict Misses ###
def getConflict(text):
	if is_using_cache_l2 is False:
		return getEntry(text, 43, 2)
	return getEntry(text, 52, 2)
def getConflictL2(text):
	return getEntry(text, 75, 2)
	
	

if __name__ == '__main__':

	# opening chart file
	chart = open(gnuplot_file, 'w')
	chart_misses = open(gnuplot_misses, 'w')
	
	# looping dinero files
	for file in getCurrentDirFiles():
		with open(file, 'r') as currentFile:
			content = currentFile.read()
			
			##### L1 #####
			# getting values
			missRate = getTotalDemandMissRate(content)
			size = getSize(content)
			assoc = getAssoc(content)
			lineSize = getLineSize(content)
			tma = getAverageAcessTime(missRate, lineSize)
			# writing to files
			_size.write("{} {}\n".format(size, missRate))
			_size_tma.write("{} {}\n".format(size, tma))
			_bsize.write("{} {}\n".format(lineSize, missRate))
			_bsize_tma.write("{} {}\n".format(lineSize, tma))
			_assoc.write("{} {}\n".format(assoc, missRate))
			_assoc_tma.write("{} {}\n".format(assoc, tma))
			# L1 misses
			l1_com = getCompulsory(content)
			l1_cap = getCapacity(content)
			l1_con = getConflict(content)
			l1_compulsory.write("{} {}\n".format(size, l1_com))
			l1_capacity.write("{} {}\n".format(size, l1_cap))
			l1_conflict.write("{} {}\n".format(size, l1_con))
			
			##### L2 #####
			if is_using_cache_l2 is True:
				# getting values
				missRate_l2 = getTotalDemandMissRateL2(content)
				size_l2 = getSizeL2(content)
				assoc_l2 = getAssocL2(content)
				lineSize_l2 = getLineSizeL2(content)
				tma_l2 = getAverageAcessTime(missRate_l2, lineSize_l2)
				# writing to files
				_size_l2.write("{} {}\n".format(size_l2, missRate_l2))
				_size_tma_l2.write("{} {}\n".format(size_l2, tma_l2))
				_bsize_l2.write("{} {}\n".format(lineSize_l2, missRate_l2))
				_bsize_tma_l2.write("{} {}\n".format(lineSize_l2, tma_l2))
				_assoc_l2.write("{} {}\n".format(assoc_l2, missRate_l2))
				_assoc_tma_l2.write("{} {}\n".format(assoc_l2, tma_l2))
				# L1 misses
				l2_com = getCompulsoryL2(content)
				l2_cap = getCapacityL2(content)
				l2_con = getConflictL2(content)
				l2_compulsory.write("{} {}\n".format(size, l2_com))
				l2_capacity.write("{} {}\n".format(size, l2_cap))
				l2_conflict.write("{} {}\n".format(size, l2_con))
		
	# writing to gnuplot file
	chart.write(pltDefine1)
	chart.write(pltPlot1)
	chart.write(pltDefine2)
	chart.write(pltPlot2)
	
	chart_misses.write(pltDefine3)
	chart_misses.write(pltPlot3)
	chart_misses.write(pltDefine4)
	chart_misses.write(pltPlot4)
	chart_misses.write(pltDefine5)
	chart_misses.write(pltPlot5)
	
	