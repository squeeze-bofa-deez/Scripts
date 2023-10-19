function main()
{
	echo Successfully loaded script
	while 1
	{
		if ${Me.InCombat} == True
			{
				if ${Me.Maintained["Construct's Sacrifice"]} == False && ${Me.Pet[0].Health} >= 80
				oc !ci -CastAbility ${Me.Name} "Construct's Sacrifice"
			}
		}
	{
		while ${Me.Ability[id,3832719436].IsReady}==True
		{
			oc !ci -CastAbility ${Me.Name} "Construct's Regeneration"
			wait 2000
		}
		while ${Me.InCombat}==True && ${Me.Pet[0].Health} <=60
		{
        	oc !ci -CastAbility ${Me.Name} "Essence Weave"
			wait 50
		}
	}
}