def randomFind(size, array):
    xLength = array.shape[0]
    yLength = array.shape[1]
    output = randXs = randYs = []
    
    randX = np.random.randint(0, xLength)
    randY = np.random.randint(0, yLength)
    
    for i in range(0, size):
        while randXs == randX and randYs == randY:
            randX = np.random.randint(0, xLength)
            randY = np.random.randint(0, yLength)
        else:
            randXs.append(randX)
            randYs.append(randY)
        
        output[i] = [randXs[i], randYs[i]]
     
    return output