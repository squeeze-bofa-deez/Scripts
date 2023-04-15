#ifndef GetNextAbility_i
#define GetNextAbility_i

#include GetAbility.iss

function GetNextAbility(string SubClass,string Snap,string Level="")
{
	variable string Snaps
	variable string Levels
	variable string AbilityIDs

	Snaps:Set[g_${SubClass}Snaps]
	Levels:Set[g_${SubClass}Levels]
	AbilityIDs:Set[g_${SubClass}AbilityIDs]

	g_${SubClass}SnapCount:Inc

	variable int SnapCount

	SnapCount:Set[${g_${SubClass}SnapCount}]

	${Snaps}[${SnapCount}]:Set[${Snap}]
	${Levels}[${SnapCount}]:Set[${Level}]

	call GetAbility "${${Snaps}[${SnapCount}]} ${${Levels}[${SnapCount}]}"

	${AbilityIDs}[${SnapCount}]:Set[${Return}]
}

#endif
