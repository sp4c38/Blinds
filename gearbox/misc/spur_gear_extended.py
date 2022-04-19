"""

Calculate the x, y position of parallel shifted points for the front surface area of a spur gear tooth.

See GoodNotes entry in 2022 folder for the Blinds project.

"""

import numpy as np

def ev(rb, rho):
	return [
		rb/np.cos(np.deg2rad(rho)),
		np.rad2deg(np.tan(np.deg2rad(rho)) - np.deg2rad(rho))
	]

def pol_zu_kart(polvect):
	return [
		polvect[0] * np.cos(np.deg2rad(polvect[1])),
		polvect[0] * np.sin(np.deg2rad(polvect[1]))
	]


# PRECALCULATIONS
# Following calculations are considered as inputs to the actual algorithm covered here. To allow higher testability, these values are calculated dynamically.
# Calculate coordinates of p1 and p2
rho_ra = 40.3209
step = 2.52
rb = 3.93923

zahnzahl = 8
spiel = 0.05
phi_r = 0.102792
zahnbreite = (180*(1+spiel))/zahnzahl+2*phi_r;

p1 = pol_zu_kart(ev(rb, np.floor(rho_ra/step)*step))
p2 = pol_zu_kart([ev(rb,rho_ra)[0], zahnbreite-ev(rb,rho_ra)[1]])

# MAIN CALCULATION
l1 = 0.5 # randbreite

m = (p2[1]-p1[1]) / (p2[0]-p1[0])
m2 = -(m**-1)

g1 = lambda x: m2 * x + (p2[1] - m2 * p2[0])
g2 = lambda x: m2 * x + (p1[1] - m2 * p1[0])

v = np.sqrt(m2 ** 2 + 1)

xl1 = l1 / v

x3 = p2[0] + xl1
y3 = g1(x3)
p3 = (x3, y3)

x4 = p1[0] + xl1
y4 = g2(x4)
p4 = (x4, y4)

print(f"P3({p3[0]} | {p3[1]})")
print(f"P4({p4[0]} | {p4[1]})")

print("\n" + str([[p4[0], p4[1]], [p3[0], p3[1]]]) + ",")