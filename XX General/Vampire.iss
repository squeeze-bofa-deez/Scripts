function main()

;Note - Run on Tank
{
	Echo Starting Vampire Setup
	if ${Me.Archetype.Equal[fighter]}
	{
	oc !c -AutoTarget_ClearActors AUTO -AutoTargetToggle AUTO FALSE
	wait 5
	;Cure Curse
	oc !c -ccstack AUTO "Cure Curse" TRUE
	;Turn Cures OFF! Including Confront Fear - Manually cure Elemental Based on ACT Triggers
	oc !c -ccstack AUTO "Cure Magic" FALSE -ccstack AUTO "Ebbing Spirit" FALSE -ccstack AUTO "Ancestral Balm" FALSE -ccstack AUTO "Confront Fear" FALSE
	wait 5
	oc !c -ccstack AUTO "Cure" FALSE -ccstack AUTO "Ancestral Balm" FALSE -ccstack AUTO "Cleansing of the Soul" FALSE -ccstack AUTO "Bagpipe Solo" FALSE
	wait 5
	oc !c -ccstack AUTO "Resolute Flagellant" FALSE -ccstack AUTO "Abolishment" FALSE -ccstack AUTO "Tunare's Grace" FALSE -ccstack AUTO "Natural Cleanse" FALSE
	wait 5
	oc !c -ccstack AUTO "Bagpipe Solo" FALSE -ccstack AUTO "Salve" FALSE
	;turn on trauma pots
	oc !c -ccstack AUTO "Item:Veilwalker's Cure Trauma" TRUE -ccstack AUTO "Item:Veilwalker's Cure Noxious" TRUE
	wait 5
	;----------------------------
	;Turn on Max Heal abilites.. for me this is mainly hibernation with ignore duration, so its always up for the 15% trigger
	oc !c -ChangeCastStackListBoxItemByTag AUTO Maxheal TRUE
	wait 5
	;ForcedNamedCA
	oc !c -UO AUTO checkbox_settings_forcenamedcatab TRUE
	wait 5
	;Turn on Chanter CC for Add
	oc !c -UO "enchanter" checkbox_settings_crowdcontrol TRUE
	
	;----------------------------
	;Assist  - Everyone auto target "a vampyric" then tank, except chanter who does vampyric then back on named to continually tap power.
	oc !c -Assist ${Me.Name}
	;Auto Target List
	oc !c -AutoTargetToggle AUTO TRUE -AutoTarget_SetScanRadius AUTO 100 -AutoTarget_SetScanHeight AUTO 50 
	wait 5
	;
	oc !c -AutoTarget_AddActor AUTO "a vampyric" FALSE FALSE FALSE -AutoTarget_AddActor AUTO ${Me.Name} FALSE FALSE FALSE
	;-AutoTarget_AddActor AUTO "a weald widow" -AutoTarget_AddActor AUTO "Mejana"
	wait 5
	oc !c -AutoTarget_ClearActors enchanter
	wait 5
	oc !c -AutoTarget_AddActor enchanter "a vampyric" FALSE FALSE FALSE -AutoTarget_AddActor enchanter "Mejana"
	wait 5
	oc !c -AutoTarget_ClearActors Fighter
	wait 5
	oc !c -AutoTarget_AddActor Fighter "a vampyric" FALSE FALSE FALSE
	;--------------------------
	;Turn on Chanter Dispell
	oc !c -ccstack Enchanter "Absorb Magic" TRUE -ccstack Bard "Jester's Cap" TRUE
	wait 5
	;--------------------------
	;Turn off Melee Attack - Turn off AE's to keep mes'd bird alive - Turn off Open Wounds
	relay all eq2ex setauto 3
	wait 5
	oc !c -UO AUTO checkbox_settings_rangedattack FALSE -UO AUTO checkbox_settings_meleeattack FALSE
	wait 5
	oc !c -UO AUTO checkbox_donotsave_dynamicignoreencounternukes TRUE -UO AUTO checkbox_donotsave_dynamicignorepbae TRUE
	wait 5
	oc !c -ccstack AUTO "Open Wounds" FALSE -UO ranger checkbox_donotsave_dynamicignorepbae FALSE
	;Cast Potion
	if !${Me.Maintained["Voidlink"](exists)}
		{
		oc !c -useitem Auto "Voidlink"
		wait 60
		}
	if ${Me.Maintained["Voidlink"].Duration} < 600
		{
		oc !c -useitem Auto "Voidlink"
		wait 60
		}
	;Cast see-invis Totem	
	if !${Me.Maintained["Totem of the Cat"](exists)}
		{
		oc !c -useitem Auto "Vision Totem of the Cat"
		wait 40
		}
	if ${Me.Maintained["Totem of the Cat"].Duration} < 600
		{
		oc !c -useitem Auto "Vision Totem of the Cat"
		wait 40
		}
	
	echo DONT FORGET TO HAREST SHINYS!
	}
	
}

