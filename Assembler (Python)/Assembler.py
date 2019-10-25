# -*- coding: utf-8 -*-
"""
Spyder Editor

Este é um arquivo de script temporário.
"""

import re #remover espaços em brancos e tabs
import numpy as np
from INStoBIN import *
from REGtoBIN import *
from ADRtoBIN import *

path = 'prog1.txt'
file = open(path,'r')
tamanho = len(open(path).readlines())
qtdLabel = 0
nomesLabels = []
posLabels = []
Label = ''
#programa = file.read()

#print(tamanho)

#################Le o arquivo em .ASM e encontra as Labels################
print('Quantidade de Linhas no codigo: ',tamanho)

for i in range(0,tamanho):
        linha = file.readline()
        if ":" in linha:
            print()
            print('Linha em que esta a label: ',i)
            posLabels.append(i)
            #linha.split()
            #print(len(linha))
            print('Quantidade de letras da Label: ',len(linha))
            qtdLabel = qtdLabel+1
            Label = ''
            for i in range(0, len(linha)-2):
                #print(linha[i])
                Label = Label+linha[i]
            print('Label :',Label)
            nomesLabels.append(Label)
print('\nQtd de Labels:',len(nomesLabels))
print(nomesLabels)
print(posLabels)
file.close() 
#============================================================================

#################Copia o arquivo para ser modificado################
with open("prog1.txt") as f:
    with open("montador.txt", "w") as f1:
        for line in f:
            if "" in line:
                f1.write(line)
f.close()
f1.close()
#====================================================================



#==================================================================       

#################Remove as linhas de Label e as Tabs################
with open("montador.txt", "r") as f:
    lines = f.readlines()
with open("montador.txt", "w") as f:
    for line in lines:
        if ":" in line:
            pass
        else:
            line = re.sub(r"[\t]*", "", line)
            f.write(line)
f.close()
#==================================================================


#################Remove Comentários################
with open("montador.txt", "r") as f:
    lines = f.readlines()
with open("montador.txt", "w") as f:
    for line in lines:
        if "--" in line:
            linSplited = line.split('--',1)
            f.write(linSplited[0]+'\n')
        else:
            f.write(line)
f.close()
#################################################          
            
 #################Remove ','################
with open("montador.txt", "r") as f:
    lines = f.readlines()
with open("montador.txt", "w") as f:
    for line in lines:
        if "," in line:
            line = re.sub(r",", "", line)
            f.write(line)
        else:
            f.write(line)
f.close()
#==================================================================================



################# SUBSTITUI OS LABELS PELAS POSIÇÕES das LINHAS################
################# EM CASOS DE JUMP##############################################
with open("montador.txt", "r") as f:
    lines = f.readlines()
with open("montador.txt", "w") as f:
    for line in lines:
        if "." in line:
            lineSPLIT = re.sub("\n","",line)
            lineSPLIT = re.split("\s\.|\n",lineSPLIT) #remove '.' separa INSTRUCAO de IMEDIAGO
            #print(lineSPLIT)
            for i in range (0,len(nomesLabels)):
                if nomesLabels[i] == lineSPLIT[1]:
                    #print(lineSPLIT[1])
                    lineSPLIT[1] = str(posLabels[i])
                    #print(lineSPLIT[1])
                    lineSPLIT[1] = str(np.binary_repr(int(lineSPLIT[1],16))).zfill(12)
                    #s = ""
                    #s = ','.join(lineSPLIT)
                    #print(lineSPLIT)
            s = ""
            s = ','.join(lineSPLIT)
            lineSPLIT = s + '\n'
            #print(lineSPLIT)
            f.write(lineSPLIT)
                    #lineSPLIT[1] = 
                #lineSPLIT[1] = 
                #print(lineSPLIT)
            #f.write(linSplited[0]+'\n')
        else:
            f.write(line)
        #print(line)
f.close()
#################################################       


#################Remove # e converte valor em binário ################
################# depois junta todos os termos separados por vírgulas######
########################################################################
with open("montador.txt", "r") as f:
    lines = f.readlines()
with open("montador.txt", "w") as f:
    for line in lines:
        if "#" in line:
            line = line.split(' ')
            #print(line)
            for i in range(0,len(line)):
                if(re.match(r'#',line[i])):
                    lineSPLIT = re.split('(#|\n)',line[i]) #remove '#' e \n
                    for conv in range (0,len(lineSPLIT)):
                        if '#' in  lineSPLIT[conv]:
                            line[i] = str(np.binary_repr(int(lineSPLIT[conv+1],16))).zfill(8) #converte para int ->> o que está na base 16 (hexa)                      
                    #print(lineSPLIT)
                    s = ""
                    s = s.join(lineSPLIT)
                    #print(s)
                    r = ""
                    r = ",".join(line)
                    #print(r)
                    line = r + '\n'
            f.write(line)
        else:
            
            line = re.sub(' ',',',line)
            f.write(line)
            
f.close()
#===========================================================================

#################### SUBSTITUI AS INSTRUCOES POR BINARIO ##########################
with open("montador.txt", "r") as f:
    lines = f.readlines()
with open("montador.txt", "w") as f:
    for line in lines:
        #print(line)
        line = re.split(',',line)
        for i in range (0,len(INS)):
            if line[0] in INS_RESERVADO[i]:
                line[0] = INS_BIN[i]
        #print(line)
        s = ""
        s = ','.join(line)
        f.write(s)    
        #print(s)
f.close()
#==========================================================================



#################### SUBSTITUI OS REGISTRADOR POR BINARIO  ##########################
with open("montador.txt", "r") as f:
    lines = f.readlines()
with open("montador.txt", "w") as f:
    for line in lines:
        #print(line)
        line = re.sub('\n','',line)
        line = re.split(',|\n',line)
        
        #print(line)
        print(len(line))
        print(line)
        for j in range (0,len(line)):
            for i in range (0,len(REG)):
                print(i,j)
                if line[j] in REG_RESERVADO[i]:
                   line[j] = REG_BIN[i]
            
        s = ""
        s = ','.join(line)
        line = s + '\n'
        f.write(line)    
        print(line)
f.close()
#========================================================================== 




#################### SUBSTITUI OS ADRESSS POR BINARIO  ##########################
with open("montador.txt", "r") as f:
    lines = f.readlines()
with open("montador.txt", "w") as f:
    for line in lines:
        #print(line)
        line = re.sub('\n','',line)
        line = re.split(',|\n',line)
        
        #print(line)
        print(len(line))
        print(line)
        for j in range (0,len(line)):
            for i in range (0,len(ADR)):
                print(i,j)
                if line[j] in ADR_RESERVADO[i]:
                   line[j] = ADR_BIN[i]
            
        s = ""
        s = ','.join(line)
        line = s + '\n'
        f.write(line)    
        print(line)
f.close()
#==========================================================================  



 #################Remove ','################
with open("montador.txt", "r") as f:
    lines = f.readlines()
with open("montador.txt", "w") as f:
    for line in lines:
        if "," in line:
            line = re.sub(r",", "", line)
            f.write(line)
        else:
            f.write(line)
f.close()
#==================================================================================

          
            #print('SUCESSO')
#print(file.readline())
#print(file.readline())
#print(file.readline())
#print(programa)
