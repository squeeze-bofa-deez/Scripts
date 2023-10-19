;v1 By thg
; Idea is to build a list of spells by character class / ascension class and combine them together to pre-buff

variable index:string Abilities
variable index:string AbilityIDs
variable index:string AbilityTargets
variable int cnt=0
variable int breakcnt=0
function main()
{
	ConsoleClear
	echo PrePull
	;eq2ex r PrePull - 10 count
	;eq2ex g PrePull - 10 count	
	
	if ${Me.GetGameData[Self.AscensionLevelClass].Label.Find[Thaumaturgist](exists)}
	{
		Abilities:Insert["Toxic Life"]
		AbilityIDs:Insert[2396735437]
		AbilityTargets:Insert[0]
		Abilities:Insert["Necrotic Caress"]
		AbilityIDs:Insert[3976950519]
		AbilityTargets:Insert[0]
		;Abilities:Insert[""]
		;AbilityIDs:Insert[]
		;AbilityTargets:Insert[]
	}
	if ${Me.GetGameData[Self.AscensionLevelClass].Label.Find[Elementalist](exists)}
	{
		Abilities:Insert["Elemental Channeling"]
		AbilityIDs:Insert[3464191604]
		AbilityTargets:Insert[0]
		Abilities:Insert["Frost Pyre"]
		AbilityIDs:Insert[544554840]
		AbilityTargets:Insert[0]
		Abilities:Insert["Thermal Depletion"]
		AbilityIDs:Insert[557315505]
		AbilityTargets:Insert[0]
	}
	if ${Me.GetGameData[Self.AscensionLevelClass].Label.Find[Etherealist](exists)}
	{
		Abilities:Insert["Ethereal Conduit"]
		AbilityIDs:Insert[2593491273]
		AbilityTargets:Insert[0]
		Abilities:Insert["Touch of Magic"]
		AbilityIDs:Insert[2909136256]
		AbilityTargets:Insert[0]
		;Abilities:Insert[""]
		;AbilityIDs:Insert[]
		;AbilityTargets:Insert[]
	}
	if ${Me.GetGameData[Self.AscensionLevelClass].Label.Find[Geomancer](exists)}
	{
		Abilities:Insert["Bastion of Iron"]
		AbilityIDs:Insert[3846323401]
		AbilityTargets:Insert[0]
		Abilities:Insert["Earthen Phalanx"]
		AbilityIDs:Insert[2453998687]
		AbilityTargets:Insert[0]
		Abilities:Insert["Stone Soul"]
		AbilityIDs:Insert[2085318003]
		AbilityTargets:Insert[0]
	}
	for(cnt:Set[1];${cnt}<=${Abilities.Used};cnt:Inc)
	{
		while ( ${Me.Ability[id,${AbilityIDs.Get[${cnt}]}].IsReady} || ${Me.Ability[id,${AbilityIDs.Get[${cnt}]}].TimeUntilReady}<1 ) && ${breakcnt:Inc}<10
		{
			call CastCall ${AbilityIDs.Get[${cnt}]} "${Abilities.Get[${cnt}]}" ${AbilityTargets.Get[${cnt}]}
			wait 600 !${Me.CastingSpell}
			wait 2
		}
	}
}



function CastCall(string CastID, string CastName, string CastTarget=0)
{
	variable int GiveUpCnt=0
	do
	{
		if !${Me.CastingSpell}
		{
			if ${CastTarget.NotEqual[0]}
				eq2execute useabilityonplayer ${Actor[id,${CastTarget}].Name} ${CastID}
			else
				Me.Ability[id,${CastID}]:Use
			eq2execute clearabilityqueue
		}
		wait 2 ${Me.CastingSpell} || !${Me.Ability[id,${CastID}].IsReady} || ( ${Me.CastingSpell} && ${Me.GetGameData[Spells.Casting].Label.Equal[${CastName}]} )

		if ${Me.CastingSpell} && ${Me.GetGameData[Spells.Casting].Label.Equal["${CastName}"]}
			break
		waitframe
	}
	while ${Me.Ability[id,${CastID}].TimeUntilReady}<1 && ${GiveUpCnt:Inc}<=50
}

