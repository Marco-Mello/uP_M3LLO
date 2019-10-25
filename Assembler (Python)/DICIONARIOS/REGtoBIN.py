# -*- coding: utf-8 -*-
"""
Created on Wed Oct 23 16:05:07 2019

@author: MarcoASMA
"""

REG = {}

REG_RESERVADO = [
       "R0",      
       "R1",
       "R2",
       "R3",
       "R4",
       "R5",
       "R6",
       "R7",
       "R8",
       "R9",
       "R10",
       "R11",
       "R12",
       "R13",
       "R14",
       "R15",
       ]

REG_BIN = [
       "0000",      
       "0001",
       "0010",
       "0011",
       "0100",
       "0101",
       "0110",
       "0111",
       "1000",
       "1001",
       "1010",
       "1011",
       "1100",
       "1101",
       "1110",
       "1111",
       ]

for i in range(0, len(REG_BIN)):
    REG[REG_RESERVADO[i]] = REG_BIN[i]