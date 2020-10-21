from os import listdir
from os.path import isfile, join

is_using_cache_l2 = True

gnuplot_file = '_chart.plt'

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

TA1 = 3 #ns
TA2 = 15 #ns

pltDefine1 = "set title 'Capacidade da cache'\nset xlabel 'Valor (KB)'\nset ylabel 'Taxa de falha (%)'\nset multiplot layout 2,1 columnsfirst\nset style line 1 lc rgb 'blue' pt 7\n"
pltPlot1 = "plot '_chart_size.txt' notitle w p ls 1\n"
pltDefine2 = "set title ' '\nset xlabel 'Valor (KB)'\nset ylabel 'Tempo médio de acesso (ns)'\n"
pltPlot2 = "plot '_chart_size_tma.txt' notitle w p ls 1"

def getTF(lineSize):
	return 35 + (int(lineSize)/8)*5

def getCurrentDirFiles():
	# return current dir files without the script
	files = [f for f in listdir("./") if isfile(join("./", f))]
	# removing generated files from list
	files.remove('_chart_generator.py')
	files.remove(gnuplot_file)
	# L1
	files.remove('_chart_size.txt')
	files.remove('_chart_bsize.txt')
	files.remove('_chart_assoc.txt')
	files.remove('_chart_size_tma.txt')
	files.remove('_chart_bsize_tma.txt')
	files.remove('_chart_assoc_tma.txt')
	# L2
	if is_using_cache_l2 is True:
		files.remove('_chart_size_l2.txt')
		files.remove('_chart_bsize_l2.txt')
		files.remove('_chart_assoc_l2.txt')
		files.remove('_chart_size_tma_l2.txt')
		files.remove('_chart_bsize_tma_l2.txt')
		files.remove('_chart_assoc_tma_l2.txt')
	
	
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

if __name__ == '__main__':

	# opening chart file
	chart = open(gnuplot_file, 'w')
	
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
		
	# writing to gnuplot file
	chart.write(pltDefine1)
	chart.write(pltPlot1)
	chart.write(pltDefine2)
	chart.write(pltPlot2)
	
	