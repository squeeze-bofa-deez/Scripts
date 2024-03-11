variable bool CorrectQuest=FALSE
variable bool WrongPendingQuest=FALSE
variable int i_QuestProgress=0
variable bool b_EelSpawn=FALSE
function main(string s_Option=repeat, int i_Step=1)
{
	Event[EQ2_onAnnouncement]:AttachAtom[EQ2_onAnnouncement]
	;// Start without having the quest
	do
	{
		switch ${s_Option}
		{
			case repeat
			case repeatable
				call Repeatables ${i_Step}
			break
			case start
			case starter
				call Starter ${i_Step}
			break
	
		}
		i_Step:Set[1]
	}
	while ${s_Option.Equal["repeat"]} || ${s_Option.Equal["repeatable"]}
}
function Starter(int i_Step)
{
	switch ${i_Step}
	{
		case 1
			call Starter_Step_1
		case 2
			call Starter_Step_2
		break
	}
}
function Starter_Step_2()
{
	call OgreMove NPCRui
	call GetQuest Rui
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
	wait 5
	call OgreMove NPCChitter
	Actor[Chitter]:DoTarget
	wait 5
	Actor[Chitter]:DoubleClick
	wait 5
	Vendor.Item["Rui's Bird Nets"]:Buy
	call OgreMove NPCRuiAfterPort
	call OgreMove BirdSpot
	i_QuestProgress:Set[0]

	variable int ActorCounter
	variable index:actor ActorIndex
		
	while ${i_QuestProgress} < 3
	{
		waitframe
		EQ2:QueryActors[ActorIndex, "Distance < 20 && Type = "NoKill NPC" && Name = "a migrating seagull""]
		for ( ActorCounter:Set[1] ; ${ActorCounter} <= ${ActorIndex.Used} ; ActorCounter:Inc )
		{
			Actor[a migrating seagull]:DoTarget
			wait 2
			Me.Inventory[Rui's Bird Nets]:Use
			wait 30
		}
	}
	call OgreMove NPCRuiAfterPort
	call FinishQuest Rui
}
function Starter_Step_1()
{
	call OgreMove NPCAqua
	call GetQuest Aqua
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
	wait 5
	call OgreMove NPCNipik
	call FinishQuest Nipik
	call GetQuest Nipik
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
	wait 5
	call OgreMove NPCSana
	call FinishQuest Sana
	call OgreMove NPCPriddie
	call GetQuest Priddie
	call OgreMove NPCBanik
	call FinishQuest Banik
	call OgreMove NPCNipik
	call GetQuest Nipik
	call OgreMove ShrineOfPrexus
	Actor[evermelting ice]:DoubleClick
	wait 50
	Actor[prexus shrine]:DoubleClick
	wait 50
	call OgreMove NPCNipik
	call FinishQuest Nipik
	wait 5
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
	wait 5
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
	wait 5
	call OgreMove NPCClicker
	call GetQuest Clicker
	call OgreMove AbandonedGnollCamp1
	EQ2Execute /target_none
	wait 100
	while ${Me.IsHated} || ${Me.InCombat}
		waitframe
	;// Could make sure we killed enough if I get the announce...
	;// Wait for mobs to come and wait for combat to finish
	call OgreMove AbandonedGnollCampBackSpot
	call OgreMove AbandonedGnollCamp1
	EQ2Execute /target_none
	wait 100
	while ${Me.IsHated} || ${Me.InCombat}
		waitframe
	;// Wait for mobs to come and wait for combat to finish
	call OgreMove NPCClicker
	call FinishQuest Clicker
	wait 5
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
	wait 5
	call OgreMove AbandonedCampEntrance
	wait 5
	call OgreMoveLoc ${Actor[othmir barricade invis 1].X} ${Actor[othmir barricade invis 1].Y} ${Actor[othmir barricade invis 1].Z}
	wait 5
	Actor[othmir barricade invis 1]:DoubleClick
	wait 20
	call OgreMoveLoc ${Actor[othmir barricade invis 2].X} ${Actor[othmir barricade invis 2].Y} ${Actor[othmir barricade invis 2].Z}
	wait 5
	Actor[othmir barricade invis 2]:DoubleClick
	wait 20
	call OgreMoveLoc ${Actor[othmir barricade invis 3].X} ${Actor[othmir barricade invis 3].Y} ${Actor[othmir barricade invis 3].Z}
	wait 5
	Actor[othmir barricade invis 3]:DoubleClick
	wait 20
	call OgreMove NPCAbandonCampNoise
	EQ2Execute /target_none
	wait 100
	while ${Me.IsHated} || ${Me.InCombat}
		waitframe
	call OgreMove AbandonedGnollCampBackSpot
	EQ2Execute /target_none
	wait 50
	while ${Me.IsHated} || ${Me.InCombat}
		waitframe
	call OgreMove NPCClicker
	call GetQuest Clicker
	wait 5
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
	wait 5

}
function Repeatables(int i_Step)
{
	if ${i_Step} == 1
	{
		call OgreMove NPCRunt
		call GetQuest Runt
		if ${EQ2.PendingQuestName.Equal[Slippery as an Eel]}
		{
			OgreBotAPI:AcceptQuest
			call Quest_SlipperyAsAnEel
		}
	}
	if ${i_Step} == 1 || ${i_Step} == 2
	{
		call OgreMove NPCNarp
		call GetQuest Narp
		if ${EQ2.PendingQuestName.Equal[Crustacean Critters]}
		{
			OgreBotAPI:AcceptQuest
			call Quest_CrustaceanCritters
		}
	}
}
function Quest_CrustaceanCritters()
{
	i_QuestProgress:Set[0]
	variable int ActorCounter
	variable index:actor ActorIndex

	;// IcecladArea1
	call OgreMove IcecladArea1
	while ${i_QuestProgress} < 6
	{
		waitframe
		EQ2:QueryActors[ActorIndex, "Distance < 25 && Type = "NPC" && Name = "an Iceclad crab""]
		for ( ActorCounter:Set[1] ; ${ActorCounter} <= ${ActorIndex.Used} ; ActorCounter:Inc )
		{
			Actor[npc,an Iceclad crab]:DoTarget
			wait 10
			;// Now we simply wait for our target to disappear
			;// If our target poofs unexpected and the eel is still there, the while will catch it.
			while ${Target(exists)}
			wait 10
		}
	}
	if ${i_QuestProgress} < 6
	{
		echo ${Time}: At the end of the Eel quest routine, but not showing completed.. Only ${i_QuestProgress}...
		Script:End
	}
	call OgreMove NPCNarp
	call FinishQuest Narp
	;// Should be a pop up.. accept it!
	wait 20
}
function Quest_SlipperyAsAnEel()
{
	i_QuestProgress:Set[0]
	variable collection:uint col_IceEelTunnelID
	variable int i_Counter=0
	variable uint TempActorID
	variable int ActorCounter
	variable index:actor ActorIndex

	;// Move to the EelArea
	call OgreMove EelArea
	while ${i_QuestProgress} < 4
	{
		waitframe
		b_EelSpawn:Set[FALSE]
		i_Counter:Set[0]

		EQ2:QueryActors[ActorIndex, "Distance < 100 && Type = "Special" && Name = "ice eel tunnel" "]
		for ( ActorCounter:Set[1] ; ${ActorCounter} <= ${ActorIndex.Used} ; ActorCounter:Inc )
		{
			if ${col_IceEelTunnelID.Element[${ActorIndex[${ActorCounter}].ID}](exists)}
				continue

			TempActorID:Set[${ActorIndex[${ActorCounter}].ID}]

			col_IceEelTunnelID:Set[${TempActorID},${TempActorID}]
			;// Lets move to it!
			call OgreMoveLoc ${ActorIndex[${ActorCounter}].X} ${ActorIndex[${ActorCounter}].Y} ${ActorIndex[${ActorCounter}].Z}
			;// Lets assume we moved to it. Lets check our distance
			if ${Actor[id,${TempActorID}].Distance} < 4
			{
				;// Click it!
				Actor[id,${TempActorID}]:DoubleClick
				;// Give the Eel a few seconds to spawn
				wait 50
				while ${Actor[a glacier eel](exists)} &&  ${Actor[a glacier eel].Distance} < 10
				{
					;// Lets target him
					Actor[a glacier eel]:DoTarget
					wait 10
					;// Now we simply wait for our target to disappear
					;// If our target poofs unexpected and the eel is still there, the while will catch it.
					while ${Target(exists)}
						wait 10
				}

			}
			else
			{
				echo ${Time} Moved to the Eel tunnel but still far away ( ${Actor[id,${TempActorID}].Distance} )
			}
			break
			
		}
	
		;// While not all 4 have been slain
		;// Move to a ' ice eel tunnel ' (to it's loc)
		;// Click it
		;// wait a few seconds or until some variable is flagged by the announced for spawning the eel
		;// Make sure target is either cleared or the eel
		;// Once combat is done - loop / continue
	}
	;// Double check all 4 have been completed or something - turn in quest
	if ${i_QuestProgress} < 4
	{
		echo ${Time}: At the end of the Eel quest routine, but not showing completed.. Only ${i_QuestProgress}...
		Script:End
	}
	call OgreMove NPCRunt
	call FinishQuest Runt
	;// Should be a pop up.. accept it!
	wait 20
}
function OgreMoveLoc(float _X, float _Y, float _Z)
{
	;// echo ogre move loc ${_X} ${_Y} ${_Z}
	;// Script:End
	;// target me
	;// wait 10
	ogre movent Loc ${_X} ${_Y} ${_Z}
	wait 10
	while ${Script[OgreMove](exists)} || ${Script[OgreMoveNoTarget](exists)}
		waitframe
	wait 10
}
function OgreMove(string SpotToMove)
{
	;// target me
	;// wait 10
	ogre movent ${SpotToMove}
	wait 10
	while ${Script[OgreMove](exists)} || ${Script[OgreMoveNoTarget](exists)}
		waitframe
	wait 10
}
atom EQ2_onAnnouncement(string Message, string SoundType, float Timer)
{
	;// echo ${Time}:EQ2_onAnnouncement: ${Message}
	;// echo if ${Message.Find["Quest item found!"](exists)} && ${Message.Find["Glacier Eel Carcass"](exists)}
	if ${Message.Find["Quest item found!"](exists)} && ${Message.Find["Glacier Eel Carcass"](exists)}
	{
		;// echo Progress should be # ... ${Message.Right[4].Mid[1,1]}
		;// i_QuestProgress:Set[${Message.Right[4].Mid[1,1]}]
		i_QuestProgress:Inc
	}
	if ${Message.Find["You've lured out an eel!"](exists)}
		b_EelSpawn:Set[TRUE]
	
	if ${Message.Find["Quest item found!"](exists)} && ${Message.Find["Iceclad crab"](exists)}
	{
		i_QuestProgress:Inc
	}

	if ${Message.Find[I have captured the birds flying overhead on their migration route near Rui.](exists)}
		i_QuestProgress:Inc
	if ${Message.Find[I killed the Iceclad crabs scuttling around the slippery ice.](exists)}
		i_QuestProgress:Inc
	if ${Message.Find[I have successfully coaxed several glacier eels out from their tunnels on the ice.](exists)}
		i_QuestProgress:Inc
	
	if ${Message.Find[Quest item found!](exists)} && ${Message.Find[Captured Bird](exists)}
		i_QuestProgress:Inc						
	/*

	17:23:31:EQ2_onAnnouncement: You've lured out an eel!
	17:23:46:EQ2_onAnnouncement: Quest item found!
	Glacier Eel Carcass (2/4)
	*/
}

function GetQuest(string NPCName, int iOption=1)
{
	;// echo option... ${iOption}
	
	Actor[exactname,${NPCName}]:DoTarget
	wait 5
	EQ2Execute /hail
	wait 5
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,${iOption}]:LeftClick
	wait 5
}
function FinishQuest(string NPCName)
{
	Actor[exactname,${NPCName}]:DoTarget
	wait 5
	EQ2Execute /hail
	wait 5
	RewardWindow:AcceptReward
}
function ZoneWait(string ZoneToWaitFor)
{
	while ${Zone.Name.NotEqual[${ZoneToWaitFor}]} || ${EQ2.Zoning}
		waitframe
	wait 20
}
atom atexit()
{
	echo ${Time} Faction completed.
}