function main()
{
	;v03112015
	echo (${Time}) COOLSASSIN START
	call variables
	call StealthOff
	while 1
	{
		while ${Me.InCombat}==TRUE
		{
			if (${Me.Ability[id,3008295138].TimeUntilReady}<=14 || ${Me.Ability[id,3633058267].TimeUntilReady}<=14) && ${Me.Ability[id,910889379].IsReady}
			{
				OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Stealth Assault" FALSE TRUE
			}
			call refresh
			if ((${Me.Maintained["Impale VII"].Name.Equal["Impale VII"]} || ${Me.Maintained["Impale VIII"].Name.Equal["Impale VIII"]} || ${Me.Ability[Impale].IsReady}==FALSE) || (${Me.Ability["Gushing Wound"].TimeUntilReady}>0 || ${Me.Maintained["Gushing Wound VIII"].Name.Equal["Gushing Wound VIII"]} || ${Me.Maintained["Gushing Wound IX"].Name.Equal["Gushing Wound IX"]} || ${Me.Maintained["Bleedout"].Name.Equal["Bleedout"]})) || (((${Target.Type.Equal["NamedNPC"]} || ${Target.Type.Equal["NPC"]}) && ${Target.Health}<=95) || ((${Target.Target.Type.Equal["NamedNPC"]} || ${Target.Target.Type.Equal["NPC"]}) && ${Target.Target.Health}<=95))
			{
				if ${Me.Ability[id,3633058267].TimeUntilReady}<=4 && ${Me.Ability[id,1641636028].TimeUntilReady}<=7 && (${Me.Ability[id,910889379].TimeUntilReady} <=7) && (${Me.Ability[id,4173392847].TimeUntilReady} <=4) && (((${Target.Type.Equal["NamedNPC"]} || ${Target.Type.Equal["NPC"]}) && ${CluelessArmadillo}<=5) || ((${Target.Target.Type.Equal["NamedNPC"]} || ${Target.Target.Type.Equal["NPC"]}) && ${RunawayLamb}<=5))
				{
					if ${Math.Calc[${Time.SecondsSinceMidnight}-${MimicryTime}]}>=85
					{
						while ${Math.Calc[${Time.SecondsSinceMidnight}-${MimicryTime}]}<=90
						{
							wait 5
						}
						MimicryTime:Set[${Time.SecondsSinceMidnight}]
						irc !c all -CastOn all "Temporal Mimicry" ${Me.Name}
						relay all OgreBotAtom a_CastFromUplink All "Combat Mastery"
						;relay all OgreBotAtom a_CastFromUplink All "Requiem"
						relay all OgreBotAtom a_CastFromUplinkOnPlayer All "Temporal Mimicry" ${Me.Name}
						echo (${Time})#Mimicry!
					}
					call StealthOn
					while ${Me.Ability[id,1641636028].TimeUntilReady}<=8 && ${Me.InCombat}==TRUE && (((${Target.Type.Equal["NamedNPC"]} || ${Target.Type.Equal["NPC"]}) && ${CluelessArmadillo}<=10) || ((${Target.Target.Type.Equal["NamedNPC"]} || ${Target.Target.Type.Equal["NPC"]}) && ${RunawayLamb}<=10))
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
		wait 10
	}
}
function StealthOn()
{
	;echo (${Time})  Wax on
	;OgreBotAtom aExecuteAtom ${Me.Name} a_UplinkControllerFunctionAutoType checkbox_settings_autoattacktiming FALSE
	;Testing Auto Timing
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Shadow" TRUE TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Item:Spiteful Archaic Idol" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Dragon Claws" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Predator's Final Trick" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Assassinate" TRUE TRUE
	relay all OgreBotAtom aExecuteAtom all a_QueueCommand ChangeCastStackListBoxItem "Item:Hempen Halter" TRUE TRUE
	relay all OgreBotAtom aExecuteAtom all a_QueueCommand ChangeCastStackListBoxItem "Item:Potent Core" TRUE TRUE
	if ${Me.Ability[Assassinate].IsReady}==TRUE
	{
		wait 20
	}
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "In Plain Sight" TRUE TRUE
	if ${Me.Ability["Bloodflurry"].Name.Equal["Bloodflurry"]}==TRUE || ${Me.Maintained["Carnage"].Name.Equal["Carnage"]}==TRUE
	{
		OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Concealment" TRUE TRUE
	}
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Jugular Slice" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Eviscerate" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Mortal Blade" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Massacre" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Stealth Assault" TRUE TRUE
	wait 35
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Fatal Followup" TRUE TRUE
}
function StealthOff()
{
	;echo (${Time})  Wax off
	;OgreBotAtom aExecuteAtom ${Me.Name} a_UplinkControllerFunctionAutoType checkbox_settings_autoattacktiming TRUE
	;Testing Auto Timing
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "In Plain Sight" FALSE TRUE
	if ${Me.Ability["Bleedout"].Name.Equal["Bleedout"]}==TRUE
	{
		OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Concealment" FALSE TRUE
	}
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Concealment" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Jugular Slice" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Eviscerate" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Mortal Blade" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Assassinate" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Massacre" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Fatal Followup" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Predator's Final Trick" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Shadow" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Dragon Claws" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Item:Spiteful Archaic Idol" FALSE TRUE
	relay all OgreBotAtom aExecuteAtom all a_QueueCommand ChangeCastStackListBoxItem "Item:Hempen Halter" FALSE TRUE
	relay all OgreBotAtom aExecuteAtom all a_QueueCommand ChangeCastStackListBoxItem "Item:Potent Core" FALSE TRUE
}
function variables()
{
	declare RunawayLamb float script
	declare CluelessArmadillo float script
	declare MimicryTime int script 0
	declare PFTtimer int script 0
	declare ItemTimer int script 0
	;Concealment	3008295138
	;In Plain Sight	3633058267
	;FFU III		1641636028
	;Bleedout		872584025
	;Carnage		4179643856
	;Stealth Assaul	910889379
	;Eviscerate III	4173392847
}
function refresh()
{
	CluelessArmadillo:Set[${Math.Calc[${Target.Distance}-(${Actor[${Target.ID}].CollisionRadius}*${Actor[${Target.ID}].CollisionScale}+${Me.ToActor.CollisionRadius}*${Me.ToActor.CollisionScale})]}]
	RunawayLamb:Set[${Math.Calc[${Target.Target.Distance}-(${Actor[${Target.Target.ID}].CollisionRadius}*${Actor[${Target.Target.ID}].CollisionScale}+${Me.ToActor.CollisionRadius}*${Me.ToActor.CollisionScale})]}]
}

	
	
	