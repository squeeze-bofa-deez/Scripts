;double up 1338614116
;dance of metal 2741887679
;change of engagement 1601808198
;will to survive 1021389054
;murderous rake IX 988676913
;debilitate 3152278489
;cornered 2613113189
;gut rip 2717097104
;backstab XI 1186263902
;band of thugs VI 1653488434
;Shank VIII 1029113160
;if above is not useable cast 
;will edit this more as i fine tune it --may add in shred?
function main()
{
	call variables
	call InitializeCaststack
	call refresh
	
	while 1
	{
		while ${Me.InCombat}==TRUE
		{
			call refresh
			while (((${Target.Type.Equal["NamedNPC"]}==TRUE || ${Target.Type.Equal["NPC"]}==TRUE) && ${TargetDist}<=5) || ((${Target.Target.Type.Equal["NamedNPC"]}==TRUE || ${Target.Target.Type.Equal["NPC"]}==TRUE) && ${TargetTargetDist}<=5)) && ${Me.InCombat}==TRUE
			{
				{
					if (${Me.Ability[id, 2741887679].IsReady}==TRUE || ${Me.Ability[id, 1338614116].IsReady}==TRUE || ${Me.Ability[id, 1601808198].IsReady}==TRUE || ${Me.Ability[id, 1021389054].IsReady}==TRUE || ${Me.Ability[id, 988676913].IsReady}==TRUE || ${Me.Ability[id, 2613113189].IsReady}==TRUE) && ${Me.InCombat}==TRUE
					{
						call PrebuffOn
						wait 15
						while ${Me.InCombat}==TRUE && (${Me.Ability[id, 2741887679].TimeUntilReady}<=5 || ${Me.Ability[id, 2613113189].TimeUntilReady}<=5 || ${Me.Ability[id, 1601808198].TimeUntilReady}<=5 || ${Me.Ability[id, 1021389054].TimeUntilReady}<=5 || ${Me.Ability[id, 988676913].TimeUntilReady}<=5 || ${Me.Ability[id, 2613113189].TimeUntilReady}${Me.Ability[id, 1653488434].TimeUntilReady}<=5)
						{
							wait 10
						}
						wait 10
						call AllOff
					}
				}


				;should work - more testing to do.
				wait 5
				call refresh
			}
			wait 7
		}
		wait 30
	}
}

function PrebuffOn()
{
	;commenting out, add what ever item you want below.
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Dance of Metal" TRUE TRUE
	if ${Math.Calc[${Time.SecondsSinceMidnight}-${MimicryTime}]}>=10
	{
		MimicryTime:Set[${Time.SecondsSinceMidnight}]
		irc !c all -CastOn all "Temporal Mimicry" ${Me.Name}
		relay all OgreBotAtom a_CastFromUplink All "Open Wounds"
		relay all OgreBotAtom a_CastFromUplinkOnPlayer All "Temporal Mimicry" ${Me.Name}
		echo (${Time})#Mimicry!
	}
}
function AllOn()
{
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Dragon Claws"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Dance of Metal"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Change of Engagment"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Will to Survive"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Murderous Rake"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Debilitate"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Cornered"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Gut Rip"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Backstab XI"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Band of Thugs VI"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Shank VIII"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Backstab XI"  TRUE TRUE
}
function AllOff()
{
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Dragon Claws"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Dance of Metal"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Change of Engagment"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Will to Survive"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Murderous Rake"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Debilitate"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Cornered"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Gut Rip"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Backstab XI"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Band of Thugs VI"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Shank VIII"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Backstab XI"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Item:Acidic Dragon Essence" FALSE TRUE
}
function variables()
{
	declare TargetTargetDist float script
	declare TargetDist float script
	declare MimicryTime int script 0
}
function refresh()
{
	TargetDist:Set[${Math.Calc[${Target.Distance}-(${Actor[${Target.ID}].CollisionRadius}*${Actor[${Target.ID}].CollisionScale}+${Me.CollisionRadius}*${Me.CollisionScale})]}]
	TargetTargetDist:Set[${Math.Calc[${Target.Target.Distance}-(${Actor[${Target.Target.ID}].CollisionRadius}*${Actor[${Target.Target.ID}].CollisionScale}+${Me.CollisionRadius}*${Me.CollisionScale})]}]
}
function InitializeCaststack()
{
	call AllOff
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Dance of Metal" FALSE TRUE
}