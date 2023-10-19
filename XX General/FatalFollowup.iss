function atexit()
{
	if ${Me.SubClass.Equal[assassin]}==TRUE
	{
		eq2ex gsay FFU CHAIN BUFF NOW
	}
}
function main()
{
	echo (${Time}) Assassin Companion Script 69420
	call variables
	call StealthOff
	Event[EQ2_onIncomingText]:AttachAtom[Ravaging]
	while 1
	{
		while ${Me.InCombat}==TRUE
		{
			if ${NewFight}==TRUE
			{
				NewFight:Set[FALSE]
				CombatStart:Set[${Time.Timestamp}]
			}
			if (${Me.Ability[id,1755027907].TimeUntilReady}<=12 || ${Math.Calc[${Time.Timestamp}-${CombatStart}]}<=5) && ${Me.Ability[id,4143464439].TimeUntilReady}==0 && ${Me.Ability[id,2305497779].TimeUntilReady}<11
			{
				OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Stealth Assault" FALSE TRUE
			}
			call refresh
			if ${Math.Calc[${Time.Timestamp}-${EtherealEnd}]}>7
			{
				EtherealTrigger:Set[FALSE]
			}
			if (${EtherealTrigger}==TRUE || ((${Me.Maintained["Impale VI"](exists)} || ${Me.Maintained["Impale VI"](exists)} || ${Me.Ability[Impale].IsReady}==FALSE) || (${Me.Ability["Gushing Wound"].TimeUntilReady}>0 || ${Me.Maintained["Gushing Wound VII"](exists)} || ${Me.Maintained["Gushing Wound IX"](exists)} || ${Me.Maintained["Bleedout"](exists)}))) || (((${Target.Type.Equal["NamedNPC"]} || ${Target.Type.Equal["NPC"]}) && ${Target.Health}<=97) || ((${Target.Target.Type.Equal["NamedNPC"]} || ${Target.Target.Type.Equal["NPC"]}) && ${Target.Target.Health}<=97))
			{
				if (${Me.Ability[id,2305497779].TimeUntilReady}<=4 || ${Me.Ability[id,2305497779].TimeUntilReady}==0) && ${Me.Ability[id,1641636028].TimeUntilReady}<=7 && (${Me.Ability[id,4143464439].TimeUntilReady} <=7) && (${Me.Ability[id,3932720659].TimeUntilReady} <=4) && (((${Target.Type.Equal["NamedNPC"]} || ${Target.Type.Equal["NPC"]}) && ${TargetDist}<=5.5) || ((${Target.Target.Type.Equal["NamedNPC"]} || ${Target.Target.Type.Equal["NPC"]}) && ${TargetTargetDist}<=5))
				{
					if ${Math.Calc[${Time.SecondsSinceMidnight}-${MimicryTime}]}>=85
					{
						OgreBotAtom aExecuteAtom all a_QueueCommand ChangeCastStackListBoxItem "Temporal Mimicry" TRUE TRUE
						MimicryTime:Set[${Time.SecondsSinceMidnight}]
						irc !c all -CastAbilityOnPlayer All "Combat Mastery" ${Me.Name}
						echo (${Time})#Mimicry!
					}
					call StealthOn
					while ${Me.Ability[id,1755027907].TimeUntilReady}<=8 && ${Me.InCombat}==TRUE && (((${Target.Type.Equal["NamedNPC"]} || ${Target.Type.Equal["NPC"]}) && ${TargetDist}<=15) || ((${Target.Target.Type.Equal["NamedNPC"]} || ${Target.Target.Type.Equal["NPC"]}) && ${TargetTargetDist}<=15))
					{
						wait 10
					}
					call StealthOff
				}
				wait 10
			}
			else
			{
				wait 10
			}
		}
		if ${Me.InCombat}==FALSE && ${NewFight}==FALSE
		{
			NewFight:Set[TRUE]
			Me.Inventory[${TempPrimary}]:Equip
		}
		wait 10
	}
}
function StealthOn()
{
	OgreBotAtom aExecuteAtom ${Me.Name} a_UplinkControllerFunctionAutoType checkbox_settings_autoattacktiming FALSE TRUE
	relay all OgreBotAtom aExecuteAtom all a_QueueCommand ChangeCastStackListBoxItem "Temporal Mimicry" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Shadow" TRUE TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Dragon Claws" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Predator's Final Trick" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Assassinate" TRUE TRUE

	if ${Me.Ability[id,960318171].TimeUntilReady}==0
	{
		wait 10
	}
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "In Plain Sight" TRUE TRUE
	if ${Me.Ability["Bloodflurry"](exists)}==TRUE || ${Me.Maintained["Carnage"](exists)}==TRUE
	{
		OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Concealment" TRUE TRUE
	}
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Jugular Slice" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Bloodflurry" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Eviscerate" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Mortal Blade" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Massacre" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Stealth Assault" TRUE TRUE
	relay all OgreBotAtom aExecuteAtom all a_QueueCommand ChangeCastStackListBoxItem "Item:Darkened Core" TRUE TRUE
	wait 35
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Fatal Followup" TRUE TRUE
}
function StealthOff()
{
	OgreBotAtom aExecuteAtom ${Me.Name} a_UplinkControllerFunctionAutoType checkbox_settings_autoattacktiming TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "In Plain Sight" FALSE TRUE

	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Concealment" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Bloodflurry" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Jugular Slice" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Eviscerate" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Mortal Blade" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Assassinate" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Massacre" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Fatal Followup" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Predator's Final Trick" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Dragon Claws" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Item:Scale of Sontalak" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Item:Abyssral's Focused Eye" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Item:Fabled Vyemm's Mutagenic Heart" FALSE TRUE
	relay all OgreBotAtom aExecuteAtom all a_QueueCommand ChangeCastStackListBoxItem "Item:Darkened Core" FALSE TRUE
	relay all OgreBotAtom aExecuteAtom all a_QueueCommand ChangeCastStackListBoxItem "Temporal Mimicry" FALSE TRUE
	wait 50
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Item:Reliquary of Dark Rites" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Uzulu Stone" TRUE TRUE
}
function variables()
{
	declare TargetTargetDist float script
	declare TargetDist float script
	declare MimicryTime int script 0
	declare PFTtimer int script 0
	declare ItemTimer int script 0
	declare EtherealTrigger Bool global
	declare EtherealEnd uint global
	declare AbilityReset uint global
	declare TempMainWeap string global
	declare CombatStart uint script
	declare NewFight bool script TRUE
	declare SHTime uint global
	declare SwapTime uint global
	;Concealment	3008295138
	;In Plain Sight	3633058267
	;FFU 			1755027907
	;Gushing Wound VII	1150688724
	;Carnage		4179643856
	;Bloodflurry 		3085956600
	;Stealth Assaul		430606614
	;Eviscerate VI		3932720659
	;Assassinate III 	960318171
	;PFT         	2305497779
	declare TempPrimary string Script
	declare PrimaryEth bool script FALSE
}
function refresh()
{
	TargetDist:Set[${Math.Calc[${Target.Distance}-(${Actor[${Target.ID}].CollisionRadius}*${Actor[${Target.ID}].CollisionScale}+${Me.CollisionRadius}*${Me.CollisionScale})]}]
	TargetTargetDist:Set[${Math.Calc[${Target.Target.Distance}-(${Actor[${Target.Target.ID}].CollisionRadius}*${Actor[${Target.Target.ID}].CollisionScale}+${Me.CollisionRadius}*${Me.CollisionScale})]}]
}
atom Ravaging(string Text)
{
	if ${Text.Find["Ravaging imbues your actions"](exists)}==TRUE && ${EtherealTrigger}==FALSE
	{
		EtherealTrigger:Set[TRUE]
		EtherealEnd:Set[${Time.Timestamp}]
	}
	if ${Text.Find["You begin an onslaught!"](exists)}==TRUE
	{
		AbilityReset:Set[${Time.Timestamp}]
		eq2ex gsay Reset!
	}
}
	
	