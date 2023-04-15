#ifndef MonkSnaps_i
#define MonkSnaps_i

#include GetNextAbility.iss

variable(global) string g_monkSnaps[9]
variable(global) string g_monkLevels[9]
variable(global) uint   g_monkAbilityIDs[9]
variable(global) int    g_monkSnapCount=0

function InitializeMonkSnaps()
{
	if ${g_monkSnapCount} == 0
	{
		call GetNextAbility monk Peel II

		call GetNextAbility monk "Mantis Leap"

		call GetNextAbility monk Rescue

		call GetNextAbility monk "Sneering Assault"

		call GetNextAbility monk "Hidden Openings"

		call GetNextAbility monk "Provoking Stance"

		call GetNextAbility monk Reprimand

		call GetNextAbility monk "Silent Threat" IX

		call GetNextAbility monk Challenge VII
	}
}

#endif