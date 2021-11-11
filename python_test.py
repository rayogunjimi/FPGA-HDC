import numpy, math

#Tanimoto/Jaccard Coefficient
msgVector = []
hamVector = []
spamVector = []
i = 0
j = 0
k = 0

with open('./msg.txt') as x:
   for line in x:
      msgVector.append(line)

with open('./refMem_Ham_Binary.txt') as y:
   for line in y:
      hamVector.append(line)

with open('./refMem_Spam_Binary.txt') as z:
   for line in z:
      spamVector.append(line)

x.close()
y.close()
z.close()


def twos_comp(val, bits):
   """compute the 2's complement of int value val"""
   if (val & (1 << (bits - 1))) != 0:  # if sign bit is set e.g., 8bit: 128-255
      val = val - (1 << bits)  # compute negative value
   return val

def sumNsquare(arr, sum):
   for i in arr:
      sum += i*i
   return sum

intMVector = []
intHVector = []
intSVector = []
for b in msgVector:
   if twos_comp(int(b,2),16) == -32768:
      intMVector.append(1)
   else:
      intMVector.append(twos_comp(int(b,2),16))
for b in hamVector:
   intHVector.append(twos_comp(int(b,2),16))
for b in spamVector:
   intSVector.append(twos_comp(int(b,2),16))

sumM = 0
sumH = 0
sumS = 0

print(sumNsquare(intHVector, sumM))
print(sumNsquare(intSVector, sumS))

MVssr = math.sqrt(sumNsquare(intMVector, sumM))
HVssr = math.sqrt(sumNsquare(intHVector, sumH))
SVssr = math.sqrt(sumNsquare(intSVector, sumS))

print(MVssr)
print(HVssr)
print(SVssr)

dotMH = numpy.dot(intMVector, intHVector)
dotMS = numpy.dot(intMVector, intSVector)

print("Dot prod ham", dotMH)
print("Dot prod spam", dotMS)

resultHam = dotMH/(MVssr*HVssr)
resultSpam = dotMS/(MVssr*SVssr)

print(resultHam)
print(resultSpam)


# intMVector = numpy.asarray(intMVector, dtype='int32')
# intHVector = numpy.asarray(intHVector, dtype='int32')
# intSVector = numpy.asarray(intSVector, dtype='int32')

# resultHam = 1 - spatial.distance.cosine(msgVector, hamVector)
# resultSpam = 1 - spatial.distance.cosine(msgVector, spamVector)
# print('Ham Result: ', resultHam)
# print('Spam Result: ', resultSpam)