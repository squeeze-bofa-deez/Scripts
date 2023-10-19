/*
Freeport faction for the betrayal.
By Kannkor
Version 1.01
	- Changed runscript ogre.. to ogre to use the extension
Version 1.00
	-Initial release.

*/
variable bool CorrectQuest=FALSE
variable bool WrongPendingQuest=FALSE
function main(int _Skip=0)
{

	while 1
	{
if ${_Skip} == 0
{
		;Start without having the quest
		call MoveToGol
		CorrectQuest:Set[FALSE]
		while !${CorrectQuest}
		{
			call GetQuest
			if ${EQ2.PendingQuestName.NotEqual[Alchemical Hazards]} && ${EQ2.PendingQuestName.NotEqual[None]}
			{
				call AcceptDelete
			}
			elseif ${EQ2.PendingQuestName.Equal[Alchemical Hazards]}
			{
				RewardWindow:AcceptReward
				CorrectQuest:Set[TRUE]
			}
			waitframe
		}
		
		call OgreMove zoneNQ
		Actor[Zone_to_Qey_north]:DoubleClick
		call ZoneWait "Qeynos Capitol District"

		call OgreMove zoneiron
		Actor[betrayal ironforge]:DoubleClick
		call ZoneWait "Betrayal Sabotage"
		;// Betrayal Sabotage

		}
_Skip:Set[0]
		call PickUpItems

		while ${Zone.Name.NotEqual[Qeynos Capitol District]} || ${EQ2.Zoning}
			waitframe

		call OgreMove zoneant
		Actor[zone_to_antonica]:DoubleClick
		call ZoneWait "Antonica"

		;// Finish quest
		call OgreMove npcgol
	
		Actor[gol]:DoTarget
		wait 5
		EQ2Execute /hail
		wait 5
		RewardWindow:AcceptReward
		wait 5
	}
}

function PickUpItems()
{
	if ${Zone.Name.NotEqual[Betrayal Sabotage]} 
		return
	wait 5
	target me
	wait 5
	;// ogre move recipe
	if !${Actor[alchemical recipe](exists)}
	{
		wait 20
		echo ${Time} Unable to find 'alchemical recipe'. Waiting for it to appear
		while !${Actor[alchemical recipe](exists)}
			wait 10
	}
	ogre move loc ${Actor[alchemical recipe].X} ${Actor[alchemical recipe].Y} ${Actor[alchemical recipe].Z}
		wait 10
		while ${Script[OgreMove](exists)}
			waitframe
		wait 10
	Actor[alchemical recipe]:DoubleClick
	wait 30
	ogre move loc ${Actor[used temper].X} ${Actor[used temper].Y} ${Actor[used temper].Z}
		wait 10
		while ${Script[OgreMove](exists)}
			waitframe
		wait 10
		echo ${Actor[used temper]} * ${Actor[used temper].Distance} * ${Actor[used temper].Loc}
	Actor[used temper]:DoubleClick
	wait 30
	;// ogre move supply
	ogre move loc ${Actor[alchemical supply].X} ${Actor[alchemical supply].Y} ${Actor[alchemical supply].Z}
		wait 10
		while ${Script[OgreMove](exists)}
			waitframe
		wait 10
	Actor[alchemical supply]:DoubleClick
	wait 30
	ogre move zonenq
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
function MoveToGol()
{
	if ${Zone.Name.Equal[Antonica]}
	{
		target me
		wait 5
		ogre move NPCGol
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
	Actor[gol]:DoTarget
	wait 5
	EQ2Execute /hail
	wait 5
	;// Check to see if we have the faction already
	variable string sFullConversation
	sFullConversation:Set[${EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1].Label}]
	if ${sFullConversation.Find["I'm Ready"](exists)}
	{
		echo ${Time}: You are maxed out on faction from this quest line. You can now continue.
		Script:End
	}
	elseif ${sFullConversation.Equal["Ok."]}
	{
		echo ${Time}: Suppose to get a quest... but already have one...??
		Script:End
	}
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
	;// EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,3]:LeftClick
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