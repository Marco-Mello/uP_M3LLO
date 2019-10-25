# -*- coding: utf-8 -*-
"""
Created on Wed Oct 23 14:44:26 2019

@author: MarcoASMA
"""

INS = {}

INS_RESERVADO = [
       "MOV",      
       "MOVi",
       "ADD",
       "ADDi",
       "DIV",
       "DIVi",
       "CMP",
       "CMPi",
       "SUB",
       "SUBi",
       "JE",
       "JNE",
       "JC",
       "STORE"
       ]

INS_BIN = [
       "0000",      
       "0001",
       "0010",
       "0011",
       "0100",
       "0101",
       "0110",
       "0111",
       "0110",
       "0111",
       "1000",
       "1001",
       "1010",
       "1011"
       ]

for i in range(0, len(INS_BIN)):
    INS[INS_RESERVADO[i]] = INS_BIN[i]