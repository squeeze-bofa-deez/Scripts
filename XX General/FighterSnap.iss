#include CastSnaps.iss

function main(string Assist)
{
	variable int   MyTargetId = 0
	variable string MyTargetType

	if ${Assist.Equal[NULL]}
	{
		echo Executing FighterSnap for ${Me.Name}

		if ${Target(exists)}
		{
			MyTargetId:Set[${Target.ID}]
			MyTargetType:Set[${Target.Type}]
		}
	}
	else
	{
		echo Executing FighterSnap for ${Me.Name} on Assist ${Assist}

		if ${Actor[${Assist}](exists)}
		{
			MyTargetId:Set[${Actor[${Assist}].Target.ID}]
			MyTargetType:Set[${Actor[${Assist}].Target.Type}]
		}
	}

	if ${MyTargetId} != 0
	{
		if ${MyTargetType.Equal[NPC]} || ${MyTargetType.Equal[NamedNPC]}
		{
			call CastSnaps ${MyTargetId}
		}
	}
}

atom atExit()
{
	echo Leaving FighterSnap
}