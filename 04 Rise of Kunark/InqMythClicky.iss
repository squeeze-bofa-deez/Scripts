;run InquisitorMythClicky

function main(int _numberOfTargets)
{
	variable int groupCounter
	variable int afflictedGroupMemberCounter
	variable int antiSpamTimer=0
	
	if ${_numberOfTargets} == 0
		_numberOfTargets:Set[2]
		
	echo ${Time}: Starting Inquisitor Myth Clicky Version 3...	
			
	while 1
	{
		groupCounter:Set[0]
		afflictedGroupMemberCounter:Set[0]	
			
		if !${Me.SubClass.Equals[inquisitor]} && ${EQ2.Zoning} == 0
			Script:End
		
		if ${Me.Grouped}
		{
			do
			{
				if ${Me.Group[${groupCounter}].Noxious} > 0 || ${Me.Group[${groupCounter}].Trauma} > 0 || ${Me.Group[${groupCounter}].Elemental} > 0 || ${Me.Group[${groupCounter}].Arcane} > 0
					afflictedGroupMemberCounter:Inc		

				waitframe		
			}
			while ${groupCounter:Inc} <= ${Me.GroupCount}
			
			if !${Me.IsDead} && ${afflictedGroupMemberCounter} >= ${_numberOfTargets} && ${Time.Timestamp} >= ${antiSpamTimer} && ${Me.Inventory[query, Name = "Penitent's Absolution" && IsReady = TRUE](exists)}
			{
				echo ${Time}: Mythical Group Cure INC! You're welcome!
				;EQ2EXECUTE gsay Mythical Group Cure INC! You're welcome!
				OgreBotAPI:UseItem[all,"Penitent's Absolution"]
				
				antiSpamTimer:Set[${Math.Calc[${Time.Timestamp}+4].Int}]
			}			
		}
		
		waitframe
	}
}

function atexit()
{
	echo ${Time}: Exiting Inquisitor Myth Clicky...
}