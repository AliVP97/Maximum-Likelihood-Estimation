import numpy as np
from numpy.random.mtrand import random

def testTrainDivider(array, percent):
    A = []
    for i in range(0, array.shape[0]):
        for j in range(0, array.shape[1]):
            A.append([i, j])
    B= []
    indexHistory = []
    for i in range(0, int(percent*len(A))):
        tempIndex = np.random.randint(0, len(A))
        if tempIndex != indexHistory:
            B.append(A[tempIndex])
            A.pop(tempIndex)
            indexHistory.append(tempIndex)
    
    return [B, A]