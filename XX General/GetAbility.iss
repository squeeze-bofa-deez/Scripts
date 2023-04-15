#ifndef GetAbility_i
#define GetAbility_i

function GetAbility(string AbilityName)
{
	variable int TimeoutCount

	TimeoutCount:Set[0]

	;echo "GetAbility Name \=\"${AbilityName}\""

	while ${Me.Ability[${AbilityName}].ID} == 0 && ${TimeoutCount:Inc} <= 4
	{
		wait 5
	}

	if ${Me.Ability[${AbilityName}].ID} == 0
	{
		echo "Timed out trying to get Ability ID for \"${AbilityName}\""

		return 0
	}

	;echo "GetAbility ID=${Me.Ability[${AbilityName}].ID}"

	return ${Me.Ability[${AbilityName}].ID}
}

#endif