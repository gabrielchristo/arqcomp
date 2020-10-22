import os
import concurrent.futures as futures
capTot = [1,4,16,64,128]
assoc = [1,2,4,8,16]
tamLin = [8, 16,32,64,128]
#-lN-Tsize P     #capacidade total
#-lN-Tbsize P    #associacao 
#-lN-Tassoc U       

"""
- Capacidade total da cache nível 1: 1K bytes, 4K bytes, 16 Kbytes, 64 Kbytes e 128 Kbytes
- Associatividade: 1, 2, 4, 8 e 16 vias
- Tamanho do bloco ou linha: 8, 16, 32, 64 e 128 bytes .

- Adicione uma cache de nível 2 unificada com 256 Kbytes, com Ta2 = 5x Ta1, mesmo tamanho de linha e configurações de sua escolha e repita as simulações.
"""
def geraComando(i,j,k):
	cont = i*25 + j*5 + k
#comando sem l2	
#	comand = "./dineroIV " + "-l1-usize " + str(capTot[i]) + "K" +" -l1-uassoc " + str(assoc[j]) + " -l1-ubsize "  + str(tamLin[k])+ " -l1-uwalloc a  " + "-l1-uwback n "  +  " -l1-uccc " + "-l1-urepl l " + "-maxtrace 101" + " " +"-trname mcf_f2b "+ "-informat s " + ">" +str(cont)+ "_" + str(capTot[i]) + "_" + str(assoc[j]) + "_" + str(tamLin[k]) + ".txt"
#comando com l2
	comand = "./dineroIV " + "-l1-usize " + str(capTot[i]) + "K" +" -l1-uassoc " + str(assoc[j]) + " -l1-ubsize "  + str(tamLin[k])+ " -l1-uwalloc a  " + "-l1-uwback n "  +  " -l1-uccc " + "-l1-urepl l " + "-l2-usize " + "256K" +" -l2-uassoc " + str(assoc[j]) + " -l2-ubsize "  + str(tamLin[k] )+ " -l2-uwalloc a  " + "-l2-uwback n "  +  " -l2-uccc " + "-l2-urepl l " + "-maxtrace 101" + " " +"-trname mcf_f2b "+ "-informat s " + ">" +str(cont)+ "_" + str(capTot[i]) + "_" + str(assoc[j]) + "_" + str(tamLin[k]) + ".txt"
	print(comand)
	os.system(comand)

executor =  futures.ProcessPoolExecutor()
for i in range(len(capTot)):
	for j in range(len(assoc)):
		for k in range(len(tamLin)):
			executor.submit(geraComando,i,j,k)

#./dineroIV  -l1-dsize 2K -l1-isize 2K -l1-ibsize 16 -l1-dbsize 8 -l2-usize 1m -l2-ubsize 64 -l2-usbsize 16 -l2-uassoc 4 -l2-urepl l -l2-ufetch s -l2-uwalloc a -l2-uwback a -informat s -maxtrace 30 -trname ../dineroData/mcf_f2b
#./dineroIV -l1-usize "$i"K -l1-ubsize $k -l1-uassoc $j -l1-uwalloc a -l1-uwback a  -l1-uccc  -l2-usize 256K -l2-ubsize $k -l2-usbsize 8 -l2-uassoc 4 - -l2-ufetch s -l2-uwalloc a -l2-uwback a -l2-uccc -maxtrace 101 -trname gcc_f2b
