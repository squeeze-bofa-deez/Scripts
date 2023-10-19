function atexit()
{
	if ${Me.SubClass.Equal[ranger]}==TRUE
	{
		eq2ex gsay PFT
	}
}
function main()
{
	echo (${Time}) Ranger Companion Script 69420
	call variables
	call StealthOff
	while 1
	{
		while ${Me.InCombat}==TRUE
		{
			if ${NewFight}==TRUE
			{
				NewFight:Set[FALSE]
				CombatStart:Set[${Time.Timestamp}]
			}
			call refresh
			if ${Math.Calc[${Time.Timestamp}-${EtherealEnd}]}>7
			{
				EtherealTrigger:Set[FALSE]
				if (${Me.Ability[id,2305497779].TimeUntilReady}<=4 || ${Me.Ability[id,2305497779].TimeUntilReady}==0) && ${Me.Ability[id,3636374120].TimeUntilReady}<=7 && (${Me.Ability[id,4188481735].TimeUntilReady} <=7) && (${Me.Ability[id,379082219].TimeUntilReady} <=4) && (((${Target.Type.Equal["NamedNPC"]} || ${Target.Type.Equal["NPC"]}) && ${TargetDist}<=5.5) || ((${Target.Target.Type.Equal["NamedNPC"]} || ${Target.Target.Type.Equal["NPC"]}) && ${TargetTargetDist}<=5))
				{
					if ${Math.Calc[${Time.SecondsSinceMidnight}-${MimicryTime}]}>=85
					{
						OgreBotAtom aExecuteAtom all a_QueueCommand ChangeCastStackListBoxItem "Temporal Mimicry" TRUE TRUE
						MimicryTime:Set[${Time.SecondsSinceMidnight}]
						irc !c all -CastAbilityOnPlayer All "Unshakable Grip" ${Me.Name}
                        irc !c all -CastAbilityOnPlayer All "Combat Mastery" ${Me.Name}
                        irc !c all -CastAbilityOnPlayer All "Time Warp" ${Me.Name}
                    	echo (${Time})Buffing Now!
					}
					call StealthOn
					while ${Me.Ability[id,4188481735].TimeUntilReady}<=8 && ${Me.InCombat}==TRUE && (((${Target.Type.Equal["NamedNPC"]} || ${Target.Type.Equal["NPC"]}) && ${TargetDist}<=15) || ((${Target.Target.Type.Equal["NamedNPC"]} || ${Target.Target.Type.Equal["NPC"]}) && ${TargetTargetDist}<=15))
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
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Sniper Squad" TRUE TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Predator's Final Trick" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Sniper Shot" TRUE TRUE

	if ${Me.Ability[id,3636374120].TimeUntilReady}==0
	{
		wait 10
	}
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Wreak Havoc" TRUE TRUE
	if ${Me.Ability["Blazing Shot"](exists)}==TRUE || ${Me.Maintained["Blazing Weapons"](exists)}==TRUE
	{
		OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Coverage" TRUE TRUE
	}
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Sniper Shot" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Ranger's Blade" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Rear Shot" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Hidden Shot" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Natural Selection" TRUE TRUE
    OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Emberstrike" TRUE TRUE

	wait 15
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Smoke Bomb" TRUE TRUE
}
function StealthOff()
{
	OgreBotAtom aExecuteAtom ${Me.Name} a_UplinkControllerFunctionAutoType checkbox_settings_autoattacktiming TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Wreak Havoc" FALSE TRUE

	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Coverage" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Sniper Shot" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Ranger's Blade" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Rear Shot" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Hidden Shot" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Emberstrike" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Natrual Selection" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Predator's Final Trick" FALSE TRUE
	relay all OgreBotAtom aExecuteAtom all a_QueueCommand ChangeCastStackListBoxItem "Temporal Mimicry" FALSE TRUE
	wait 30
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
	;Coverage           3446147495
	;Natural Selection  4188481735
	;Emberstrike VIII		379082219
	;Sniper Shot 	3636374120
	;PFT         	2305497779
	declare TempPrimary string Script
	declare PrimaryEth bool script FALSE
}
function refresh()
{
	TargetDist:Set[${Math.Calc[${Target.Distance}-(${Actor[${Target.ID}].CollisionRadius}*${Actor[${Target.ID}].CollisionScale}+${Me.CollisionRadius}*${Me.CollisionScale})]}]
	TargetTargetDist:Set[${Math.Calc[${Target.Target.Distance}-(${Actor[${Target.Target.ID}].CollisionRadius}*${Actor[${Target.Target.ID}].CollisionScale}+${Me.CollisionRadius}*${Me.CollisionScale})]}]
}

	
	