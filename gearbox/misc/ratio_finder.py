""" Find all possible gear ratios.

Because gears can only have an even number of teeth, the amount of possible gear ratios is limited.
Thus, a desired ratio may not be possible and a ratio which comes close needs to be selected. This program helps
finding this approximated ratio.

To find all possible ratios enter a fixed number of sun gear teeth and enter a range of ring gear teeth.
The program tests all numbers in the range for the ring gear tooth amount. For each test it outputs the
overall ratio and the related planet teeth number.

Eventually, you can select the ratio which fits best to your desired ratio and use the corresponding tooth amounts.

"""

from decimal import *

sun_teeth = Decimal("9")
ring_teeth_possibilities = [Decimal(x) for x in range(1, 100+1)]

for ring_teeth in ring_teeth_possibilities:
	planet_teeth = ring_teeth/2-sun_teeth/2

	if (planet_teeth % 1) != 0:
			continue
			
	ratio = 1+ring_teeth/sun_teeth
	print(f"Ratio: {ratio}: Sun: {sun_teeth}, Ring: {ring_teeth}, Planet: {planet_teeth}")
