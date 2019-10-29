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
       "JMP",
       "STORE",
       "LOAD"
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
       "1011",
       "1100",
       "1101",
       ]

for i in range(0, len(INS_BIN)):
    INS[INS_RESERVADO[i]] = INS_BIN[i]
    

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
    
ADR = {}

ADR_RESERVADO = [
       "DSP0",      
       "DSP1",
       "DSP2",
       "DSP3",
       "DSP4",
       "DSP5",
       "DSP6",
       "DSP7",
       "----",
       "----",
       "----",
       "----",
       "----",
       "----",
       "----",
       "----",
       ]

ADR_BIN = [
       "00000000",      
       "00010000",
       "00100000",
       "00110000",
       "01000000",
       "01010000",
       "01100000",
       "01110000",
       "10000000",
       "10010000",
       "10100000",
       "10110000",
       "11000000",
       "11010000",
       "11100000",
       "11110000",
       ]

for i in range(0, len(ADR_BIN)):
    ADR[ADR_RESERVADO[i]] = ADR_BIN[i]

Reserved = INS
Reserved.update(REG)
Reserved.update(ADR)