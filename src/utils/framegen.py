from random import randint

W = 800
L = 800

with open('frame.mem', 'w+') as out:
	for i in range(1, (W*L)+1):

		# Slot in the middle pattern
		WINDOW = 200
		value = (hex(255)[2:] + ' ') if (W/2)-WINDOW <= (i%W) <= (W/2)+WINDOW else (hex(0)[2:] + ' ')

		# Random
		#value = (hex(randint(0, 255))[2:] + ' ')

		out.write(value)
