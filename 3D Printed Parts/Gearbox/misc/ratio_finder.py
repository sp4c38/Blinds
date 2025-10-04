""" Find all possible gear ratios.

Because gears can only have an integral number of teeth, the amount of possible gear ratios is limited.
Thus, a desired ratio may not be possible and a ratio which comes close needs to be selected. This program helps
finding this approximated ratio.

To find all possible ratios enter a fixed number of sun gear teeth and enter a range of ring gear teeth.
The program tests all numbers in the range for the ring gear tooth amount. For each test it outputs the
overall ratio and the related planet teeth number.

Eventually, you can select the ratio which fits best to your desired ratio and use the corresponding tooth amounts.

If you are using more than one planet gear following applies: Even if all gears have an integral number of teeth only certain gear constellations of these will work in practice. This is because it may not necessarily be possible to place the planet gears relative to each other at the positions they should be placed because at these positions they may not mesh with the sun gear and the ring gear. To consider these constraints enable 'strict_validation' and you'll only get the ratios which are truly possible. See GoodNotes entry for more information.

"""

import sys

from decimal import *

strict_validation = True
planet_amount = 3 # Only used if strict validation is enabled.

sun_teeth = Decimal("9")
ring_teeth_possibilities = [Decimal(x) for x in range(1, 100+1)]

if strict_validation and (sun_teeth % planet_amount) != 0:
	print(f"Sun gear teeth (currently {sun_teeth}) must be a multiple of the planet amount ({planet_amount}).")
	sys.exit(1)

for ring_teeth in ring_teeth_possibilities:
	planet_teeth = ring_teeth/2-sun_teeth/2

	if planet_teeth == 0 or (planet_teeth % 1) != 0:
		continue
	
	if strict_validation and (ring_teeth % sun_teeth) != 0:
		continue
	
	ratio = 1+ring_teeth/sun_teeth
	print(f"Ratio: {ratio}: Sun: {sun_teeth}, Ring: {ring_teeth}, Planet: {planet_teeth}")
