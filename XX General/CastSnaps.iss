#ifndef CastSnaps_i
#define CastSnaps_i

#include SpellCasting.iss
#include TargetActor.iss
#include BruiserSnaps.iss
#include MonkSnaps.iss
#include PaladinSnaps.iss

variable string SubClass1=${Me.SubClass.Mid[1,1].Upper}
variable string SubClass2=${Me.SubClass.Right[-1].Lower}
variable string SubClass=${SubClass1:Concat[${SubClass2}]}

function CastSnaps(int TargetIdToSnap)
{
	variable string Snaps
	variable string Levels
	variable string AbilityIDs
	variable int    SnapCount
	variable int    SnapNumber
	variable string Snap
	variable string Level
	variable uint   AbilityID
	variable string AbilityName
	variable int    MyTargetId
	variable string MyTargetName

	call Initialize${SubClass}Snaps

	Snaps:Set[g_${Me.SubClass}Snaps]
	Levels:Set[g_${Me.SubClass}Levels]
	AbilityIDs:Set[g_${Me.SubClass}AbilityIDs]
	SnapCount:Set[${g_${Me.SubClass}SnapCount}]
	MyTargetId:Set[${TargetIdToSnap}]
	MyTargetName:Set[${Actor[${TargetIdToSnap}].Name}]

	call TargetActor ${MyTargetId} TRUE TRUE

	echo Snapping  \"${MyTargetName}\"

	SnapNumber:Set[0]

	while !${Me.ToActor.IsDead} && ${Actor[${MyTargetId}](exists)} && !${Actor[${MyTargetId}].IsDead} && ${Actor[${MyTargetId}].Target.ID} != ${Me.ID} && ${SnapNumber:Inc} <= ${SnapCount}
	{
		AbilityID:Set[${${AbilityIDs}[${SnapNumber}]}]

		if ${AbilityID} != 0
		{
			Snap:Set[${${Snaps}[${SnapNumber}]}]
			Level:Set[${${Levels}[${SnapNumber}]}]
			AbilityName:Set[${Snap} ${Level}]

			echo Checking if Snap \"${AbilityName}\" can be cast

			waitframe

			if ${Me.Ability[${AbilityName}].IsReady} && !${Me.ToActor.IsDead} && ${Actor[${MyTargetId}](exists)} && !${Actor[${MyTargetId}].IsDead}
			{
				echo Casting \"${AbilityName}\"

				call CastSpellNow ${Me.Name} "${Snap}"

				wait 20 ${Actor[${MyTargetId}].Target.ID} == ${Me.ID}
			}
		}
	}
}

#endif