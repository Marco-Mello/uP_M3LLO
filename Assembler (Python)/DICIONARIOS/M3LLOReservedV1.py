# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 09:31:02 2019

@author: MarcoASMA
"""

from INStoBIN import *
from REGtoBIN import *
from ADRtoBIN import *

Reserved = INS
Reserved.update(REG)
Reserved.update(ADR)
            
#print(Reserved)

#for i in range(0,len())