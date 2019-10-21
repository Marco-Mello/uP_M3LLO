# -*- coding: utf-8 -*-
"""
Spyder Editor

Este é um arquivo de script temporário.
"""


path = 'prog1.txt'
file = open(path,'r')
tamanho = len(open(path).readlines())
qtdLabel = 0
nomesLabels = []
Label = ''
#programa = file.read()

#print(tamanho)
print('Quantidade de Linhas no codigo: ',tamanho)

for i in range(0,tamanho):
        linha = file.readline()
        if ":" in linha:
            print()
            print('Linha em que esta a label: ',i)
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
print(nomesLabels)
            #print('SUCESSO')
#print(file.readline())
#print(file.readline())
#print(file.readline())
#print(programa)
