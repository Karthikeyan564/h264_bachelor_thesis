'''
Dependencies:
	PIL
	Numpy

Arguments to be passed while executing script:
	Filename (note that the image should be in tiff format)
'''

from PIL import Image
import numpy as np
import sys

# Loading image onto 'img'
img = Image.open(sys.argv[1])

# Converting to numpy array, datatype is still int
# Yields an array whose dimension is (X,Y,3)
imgintarray = np.array(img)

# Converting int to hex
toHex = np.vectorize(lambda x : hex(x))
imghexarray = toHex(imgintarray)

print(imghexarray)
