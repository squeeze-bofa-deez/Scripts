variable bool CorrectQuest=FALSE
variable bool WrongPendingQuest=FALSE
function main()
{
	while 1
	{
		;Start without having the quest
		call MoveToGil
		CorrectQuest:Set[FALSE]
		while !${CorrectQuest}
		{
			call GetQuest
			if ${EQ2.PendingQuestName.NotEqual[Party Crasher]} && ${EQ2.PendingQuestName.NotEqual[None]}
			{

				call AcceptDelete
			}
			elseif ${EQ2.PendingQuestName.Equal[Party Crasher]}
			{
				RewardWindow:AcceptReward
				CorrectQuest:Set[TRUE]
			}
			waitframe
		}
		call OgreMove ThievesWay
		Actor[fprt_gate_to_sewer01]:DoubleClick
		call ZoneWait "The Thieves' Way"
		
		call OgreMove zoneNFP
		Actor[zone_to_fprt_north]:DoubleClick
		call ZoneWait "The City of Freeport"

		call OgreMove ZoneDismalDen
		Actor[to_dismal_den]:DoubleClick
		call ZoneWait "The Dismal Den"
		
		globalatom_SetOgreBotPauseStatus FALSE
		execute run eq2ogrebot/Extras/AHMovement
		while ${Actor[a qeynosian scout].Distance} > 5
			waitframe
		Actor[a qeynosian scout]:DoTarget
		EQ2Execute /hail
		while ${Script[AHMovement](exists)}
			waitframe
		wait 20
		if ${Actor[foot_locker].Distance} < 4.5
			EQ2Execute "/apply_verb ${Actor[foot_locker].ID} Search Box"
		else
		{
			echo WAiting to be in range of the box..
			while ${Actor[foot_locker].Distance} > 4.5
				waitframe
			EQ2Execute "/apply_verb ${Actor[foot_locker].ID} Search Box"
		}
		wait 50
		call OgreMove Door
		EQ2Execute "/apply_verb ${Actor[02_door_2].ID} Use Shiny Key"
		wait 20
		call OgreMove Room
		wait 100 ${Me.InCombat}
		while ${Me.InCombat}
			waitframe
		globalatom_SetOgreBotPauseStatus TRUE
		call OgreMove ZoneNFP
		Actor[exit_door]:DoubleClick
		
		;// End of killing shit
		call ZoneWait "The City of Freeport"

		call OgreMove Zonefptthievesway
		Actor[fprt_manhole_hood_to_sewer01]:DoubleClick
		call ZoneWait "The Thieves' Way"

		call OgreMove zonecommonlands
		Actor[fprt_sewer01_to_gate]:DoubleClick
		call ZoneWait "The commonlands"

		call OgreMove Gil

		wait 10
		Actor[gil]:DoTarget
		wait 5
		EQ2Execute /hail
		wait 5
		RewardWindow:AcceptReward
		wait 5

	}
}
function MoveToIron()
{
	wait 5
	target me
	wait 5
	runscript ogre move zoneiron
		wait 10
		while ${Script[OgreMove](exists)}
			waitframe
		wait 10
	Actor[betrayal ironforge]:DoubleClick
}
function PickUpItems()
{
	if ${Zone.Name.NotEqual[Betrayal Sabotage]} 
		return
	wait 5
	target me
	wait 5
	runscript ogre move recipe
		wait 10
		while ${Script[OgreMove](exists)}
			waitframe
		wait 10
	Actor[special]:DoubleClick
	wait 30
	runscript eq2ogrecommon/ogremove loc ${Actor[used temper].X} ${Actor[used temper].Y} ${Actor[used temper].Z}
		wait 10
		while ${Script[OgreMove](exists)}
			waitframe
		wait 10
	Actor[special]:DoubleClick
	wait 30
	runscript ogre move supply
		wait 10
		while ${Script[OgreMove](exists)}
			waitframe
		wait 10
	Actor[special]:DoubleClick
	wait 30
	runscript ogre move zonenq
		wait 10
		while ${Script[OgreMove](exists)}
			waitframe
		wait 10

	Actor[to North Qeynos]:DoubleClick
}
function AcceptDelete()
{
	wait 5
	RewardWindow:AcceptReward
	wait 15
	EQ2UIPage[Journals,JournalsQuest].Child[button,TabPages.Active.After.DeleteButton]:LeftClick
	wait 5
	ChoiceWindow:DoChoice1
}
function MoveToGil()
{
	if ${Zone.Name.Equal[The Commonlands]}
	{
		target me
		wait 5
		ogre move Gil
		wait 10
		while ${Script[OgreMove](exists)}
			waitframe
		wait 10
	}
	else
	{
		echo ${Time}: Wrong zone... 
		Script:End
	}
}
function GetQuest()
{
	Actor[gil]:DoTarget
	wait 5
	EQ2Execute /hail
	wait 5
	variable string sFullConversation
	sFullConversation:Set[${EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1].Label}]
	if ${sFullConversation.Equal["I am ready to take my place in Qeynos."]}
	{
		echo ${Time}: Max faction completed.
		Script:End
	}
	elseif ${sFullConversation.Equal["Ok."]}
	{
		echo ${Time}: Suppose to get a quest... but already have one...??
		Script:End
	}
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
	wait 5
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
	wait 5
}
function OgreMove(string SpotToMove)
{
	target me
	wait 10
	ogre move ${SpotToMove}
	wait 10
	while ${Script[OgreMove](exists)}
		waitframe
	wait 10
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