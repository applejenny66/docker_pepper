import sys
import pickle

with open('conceptNetCache.pickle', 'rb') as f:
	conceptNetDict = pickle.load(f)

print(conceptNetDict)