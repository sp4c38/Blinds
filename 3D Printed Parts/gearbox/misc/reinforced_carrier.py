"""
Calculate the minimum distance from the center to the carrier base border.
For detailed information see the GoodNotes entry inside 2022 in the Blinds project.
"""

import numpy as np

from dataclasses import dataclass

# Given variables
nc = 3
l1 = 19
r = 7/2 # carrier thick bar radius

# Custom types
@dataclass
class Point:
	x: float
	y: float

# Calculation
alpha = 360/nc
alpha_rad = np.deg2rad(alpha)

p0 = Point(l1, 0)

p1 = Point(np.cos(alpha_rad)*l1, np.sin(alpha_rad)*l1)

m = (p0.y-p1.y)/(p0.x-p1.x)
a = p0.y-m*p0.x

m2 = -(1/m)
a2 = p1.y-m2*p1.x

q = np.sqrt(1+m2**2)
delta_x = r/q
delta_y = m2*delta_x
p3 = Point(p1.x+delta_x, p1.y+delta_y)
a3 = p3.y-m*p3.x

y4 = 0
x4 = (-a3)/m
p4 = Point(x4, y4)
l3 = p4.x

l2 = np.sqrt(2*l3**2-(2*l3**2*np.cos(alpha_rad)))

h = np.sqrt(l3**2-(l2/2)**2)

print(f"Height is {h}.")