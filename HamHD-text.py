import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.metrics import accuracy_score

# Path to dataset file.
f_ = './spam.csv'
f = './refMem_Ham_Binary.txt'
file = './dictMem.txt'

# Read dataset from file and process into data and labels.
def ReadCSV(f_path):
    df = pd.read_csv(f_path, delimiter=',', encoding='latin-1')
    df.drop(['Unnamed: 2', 'Unnamed: 3', 'Unnamed: 4'], axis=1, inplace=True)
    X = df.v2
    Y = df.v1
    le = LabelEncoder()
    Y = le.fit_transform(Y)
    return X, Y

# Generate item memory.
def memGen(dim = 10000, num_char = 37):
    dictMem = np.random.randint(2, size=(num_char, dim), dtype = 'int32')
    dictMem[dictMem == 0] = -1
    return dictMem

# Encode message into an HV and performa bipolarization.
def encode(msg, dictMem, dim = 10000):
    HV = np.zeros(dim, dtype='int32')
    for letter in msg:
        #HV = np.roll(HV, int(dim/200))
        # if letter == 0:
        #     continue
        # else:
        HV = np.add(HV, dictMem[letter])
    
    HV_avg = np.average(HV)
    HV[HV > HV_avg] = 1
    HV[HV < HV_avg] = -1
    HV[HV == HV_avg] = 0
    return HV

# Train the associative memory.
def train(X, Y, dictMem, dim = 10000, n_class = 2):
    refMem = np.zeros((n_class, dim), dtype='int32')
    msg_idx = 0
    for msg in X:
        HV = encode(msg, dictMem, dim = dim)
        refMem[Y[msg_idx]] = np.add(refMem[Y[msg_idx]],HV)       
        msg_idx += 1
    return refMem

# Inference using the trained AM.
def test(X, Y, dictMem, refMem, dim = 10000):
    Y_pred = []
    msg_idx = 0
    for msg in X:
        HV = encode(msg, dictMem, dim = dim)
        sim = [0, 0]
        sim[0] = cosine_similarity([HV, refMem[0]])[0][1]
        sim[1] = cosine_similarity([HV, refMem[1]])[0][1]
        if sim[0] > sim[1]:
            Y_pred.append(0)
        else:
            Y_pred.append(1)
        msg_idx += 1

    return accuracy_score(Y, Y_pred)

# Retrain the AM
def retrain(X, Y, dictMem, refMem, dim = 10000):
    msg_idx = 0
    for msg in X:
        HV = encode(msg, dictMem, dim = dim)
        sim = [0, 0]
        sim[0] = cosine_similarity([HV, refMem[0]])[0][1]
        sim[1] = cosine_similarity([HV, refMem[1]])[0][1]
        if sim[0] > sim[1]:
            y_pred = 0
        else:
            y_pred = 1
        if y_pred != Y[msg_idx]:
            refMem[Y[msg_idx]] = np.add(refMem[Y[msg_idx]], HV)
            refMem[y_pred] = np.subtract(refMem[y_pred], HV)
        msg_idx += 1
    return refMem


dim = 10000 # Dimension
num_char = 37 # Number of characters for unique item memory entry
epoch = 8 # Retraining epochs

if __name__ == '__main__':
    X, Y = ReadCSV(f_)
    X_ = []
    
    # Tokenization of messages. This needs refactoring. 
    for item in X:
        token_item = []
        for letter in item.lower():
            #print(letter)
            if ord(letter) >= ord('a') and ord(letter) <= ord('z'):
                token_item.append(ord(letter) - ord('a') + 11)
            elif ord(letter) >= ord('0') and ord(letter) <= ord('9'):
                token_item.append(ord(letter) - ord('0') + 1)
            else:
                token_item.append(0)
        X_.append(token_item)
        
    X_train, X_test, Y_train, Y_test = train_test_split(X_, Y, test_size = 0.2, random_state = 556)

    dictMem = memGen(dim = dim, num_char = num_char)
    refMem = train(X_train, Y_train, dictMem, dim = dim)
    
    #print(cosine_similarity([refMem[0], refMem[1]]))
    acc = test(X_test, Y_test, dictMem, refMem, dim = dim)
    print(acc)

    while(epoch != 0):
        refMem = retrain(X_train, Y_train, dictMem, refMem, dim = dim)
        acc = test(X_test, Y_test, dictMem, refMem, dim = dim)
        print(acc)
        epoch -= 1

    #Generate refMem_Ham and refMem_Spam
    f_Ham = open("./refMem_Ham_Binary.txt", "w")
    f_Spam = open("./refMem_Spam_Binary.txt","w")
    f_dict = open("./dictMem.txt","w")
    for i in refMem[0]:
        f_Ham.write(format(int(i & 0xffff),"b").zfill(16) + "\n")
    f_Ham.close()

    for i in refMem[1]:
        f_Spam.write(format(int(i & 0xffff),"b").zfill(16) + "\n")
    f_Spam.close()

    for i in dictMem:
        for j in i:
            f_dict.write(format(int(j & 0xffff),"b").zfill(16) + "\n")
    f_dict.close()
    print("done")
