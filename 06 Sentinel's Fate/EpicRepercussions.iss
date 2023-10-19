#include "VikingQuest_Modified.iss"

variable bool ignoreMobs = TRUE
variable bool ignoreDistance = TRUE
variable bool ignoreHealth = TRUE
variable bool wGroup = FALSE
variable int minLevel = 1
variable int maxLevel = 200
variable int minMobs = 0

;progress vars
variable bool needPondweed = TRUE
variable bool needSnakes= TRUE
variable bool needScintillas = TRUE
variable bool needMercury = TRUE
variable bool needPowder = TRUE
variable bool needBlood = TRUE
variable bool needBook = TRUE
variable bool lastMirrorSuccess = TRUE
variable bool stickToPool = FALSE
variable bool tagAlong = FALSE
variable bool queenUp = TRUE
variable bool queenAggro = FALSE
variable string mythRG = mythRG
variable string newMythRG = mythRG
variable string tagRG = tagalongRG
variable string newTagRG = tagalongRG
variable string mirrorManager = None
variable string usingElevator = None
	
function main(int stepNumber = 0, bool tagAlongInput = FALSE)
{
	if ${stepNumber} < 0
	{
		echo Step GetQuest 0 ${stepNumber}
		echo Step GoToQuelUle 1 ${stepNumber}
		echo Step GetPondweedWrapper 2 ${stepNumber}
		echo Step GetSnakes 3 ${stepNumber}
		echo Step GetScintillasWrapper 4 ${stepNumber}
		;echo Step GetPondweedWrapper 4 ${stepNumber}
		echo Step LamaAfterPondweed 5 ${stepNumber}
		echo Step Library 6 ${stepNumber}
		echo Step NPCAfterLibrary 7 ${stepNumber}
		echo Step Cella 8 ${stepNumber}
		echo Step Research 9 ${stepNumber}
		echo Step Mercury 10 ${stepNumber}
		echo Step Mindflow 12 ${stepNumber}
		echo Step CloseOutPotentItems 13 ${stepNumber}
		echo Step CloseItOut 14 ${stepNumber}
		return
	}
	uplink relaygroup -join ${Me.Name}
	oc !ci -ZoneResetAll ${Me.Name}
	tagAlong:Set[${tagAlongInput}]
	call updateRG
	
	call SettingsUpdate

	Event[EQ2_onIncomingText]:AttachAtom[EQ2_onIncomingText]
	;;;;AddTriger questinfo QUESTDATA::@qinfo@
	
	relay ${Me.Name} runscript "${Script.CurrentDirectory}/QuestStatusHelper"
	
	call Step GetQuest 0 ${stepNumber}
	call Step GoToQuelUle 1 ${stepNumber}
	call Step GetPondweedWrapper 2 ${stepNumber}
	call Step GetSnakes 3 ${stepNumber}
	call Step GetScintillasWrapper 4 ${stepNumber}
	call Step LamaAfterPondweed 5 ${stepNumber}
	call Step Library 6 ${stepNumber}
	call Step NPCAfterLibrary 7 ${stepNumber}
	call Step Cella 8 ${stepNumber}
	call Step Research 9 ${stepNumber}
	call Step Mercury 10 ${stepNumber}
	call Step Mindflow 12 ${stepNumber}
	call Step CloseOutPotentItems 13 ${stepNumber}
	call Step CloseItOut 14 ${stepNumber}
}
function Step(string stepName, int max = 0, int actual = 0)
{
	if ${max} >= ${actual}
	{
		echo Calling ${stepName} because ${max} >= ${actual}
		call ${stepName}
		return
	}
	echo Skipped ${stepName} because ${max} < ${actual}
}

function SettingsUpdate()
{
	oc !ci -UplinkOptionChange ${Me.Name} checkbox_settings_movemelee FALSE
	oc !ci -UplinkOptionChange ${Me.Name} checkbox_settings_movebehind FALSE
	oc !ci -UplinkOptionChange ${Me.Name} checkbox_settings_moveinfront FALSE
	oc !ci -UplinkOptionChange ${Me.Name} checkbox_settings_movetoarea TRUE
	oc !ci -UplinkOptionChange ${Me.Name} checkbox_settings_loot TRUE
	oc !ci -UplinkOptionChange ${Me.Name} checkbox_settings_ignoretargettoattackhealthcheck TRUE
	call AutoTargetOnOff TRUE ${Me.Name}
	;oc !ci -Assist ${Me.Name}
	call GetPerspective
}

function GetPerspective()
{
	eq2press -hold numpad-
	wait 70
	eq2press -release numpad-
	wait 20
	EQ2Press -hold numpad3
	wait 20
	EQ2Press -release numpad3
}

function CloseItOut()
{
	if ${Zone.Name.Equals["The Stonebrunt Highlands"]}
	{
		call MovementManager -490.66 370.17 1509.48 "The Stonebrunt Highlands" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		while !${Zone.Name.Equals[The Sundered Frontier]}
		{
			relay ${Me.Name} MessageBox "Attempting To Zone To Sundered Frontier (may need you to do it for me!)"
			echo Take me to Sundered Frontier!
			call FlyToSundered
		}
		call KillMessageBox
	}
	while !${Zone.Name.Equals["The Sundered Frontier"]}
	{
		relay ${Me.Name} runscript custom/GlobeTrotter "The Sundered Frontier"
		wait 3
		while ${Script[GlobeTrotter](exists)}
		{
			wait 50
		}
		;relay ${Me.Name} MessageBox "Please Take Me To Sundered Frontier"
		;echo Take me to Sundered
		wait 300
	}
	call KillMessageBox
	call FlyDown
	call MovementManager 1996.11 -298.99 3339.34 "The Sundered Frontier" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	wait 20
	call GetPerspective
	target Waseem
	face Waseem
	wait 10
	eq2execute h
	Actor[Waseem]:DoubleClick
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	call FlyUp
	call MovementManager 1245.75 -110.28 3358.29 "The Sundered Frontier" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} 1
	call MovementManager 619.45 112.73 2974.58 "The Sundered Frontier" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} 1
	
	call GetPerspective
	target Waseem
	face Waseem
	wait 10
	eq2execute h
	Actor[Waseem]:DoubleClick
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 50
	oc !ci -AcceptReward ${Me.Name}
}

function CloseOutPotentItems()
{
	
	if ${Zone.Name.Equals["The Sundered Frontier"]}
	{
		call FlyUp
		call MovementManager 366.23 137.08 2516.53 "The Sundered Frontier" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} 1
		while ${Zone.Name.Equals[The Sundered Frontier]}
		{
			relay ${Me.Name} MessageBox "Attempting To Zone To Stonebrunt (may need you to do it for me!)"
			echo Take me to Stonebrunt!
			call FlyToStonebrunt
		}
		call KillMessageBox
	}
	while !${Zone.Name.Equals["The Stonebrunt Highlands"]}
	{
		relay ${Me.Name} runscript custom/GlobeTrotter "The Stonebrunt Highlands"
		wait 3
		while ${Script[GlobeTrotter](exists)}
		{
			wait 50
		}
		;relay ${Me.Name} MessageBox "Please Take Me To Stonebrunt"
		;echo Take me to Stonebrunt
		;wait 300
	}
	call KillMessageBox
	call MovementManager -438.14 379.70 654.47 "The Stonebrunt Highlands" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} 1
	
	call GetPerspective
	target Lama
	face Lama
	wait 10
	eq2execute h
	Actor[Lama]:DoubleClick
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
}

function Mindflow()
{
	if ${Zone.Name.Equals[The Stonebrunt Highlands]}
	{
		call MovementManager -492.67 370.17 1511.43 "The Stonebrunt Highlands" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		while !${Zone.Name.Equals[The Sundered Frontier]} && !${Zone.Name.Equals["Demitrik's Bastion"]}
		{
			relay ${Me.Name} MessageBox "Attempting To Zone To Sundered Frontier (may need you to do it for me!)"
			echo Take me to Sundered Frontier!
			call FlyToSundered
		}
		call KillMessageBox
	}
	while !${Zone.Name.Equals[The Sundered Frontier]} && !${Zone.Name.Equals["Demitrik's Bastion"]}
	{
		
		relay ${Me.Name} runscript custom/GlobeTrotter "The Sundered Frontier"
		wait 3
		while ${Script[GlobeTrotter](exists)}
		{
			wait 50
		}
		;relay ${Me.Name} MessageBox "Please Take Me To Sundered Frontier"
		;echo Take me to Sundered Frontier!
		wait 300
	}
	call KillMessageBox
	while !${Zone.Name.Equals["Demitrik's Bastion"]}
	{
		if ${Zone.Name.Equals[The Sundered Frontier]}
		{	
			call DownToTheHoleLobby
			call MovementManager 1849.31 -371.33 3450.46 "The Sundered Frontier" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
			while ${botUtil.FurthestGroupmemberDistance} > 5
			{
				relay ${Me.Name} MessageBox "Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away. (this message will self-destruct)"
				echo Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away.
				wait 2
			}
			wait 40
			call KillMessageBox
			oc !ci -Zone ${Me.Name}
			wait 50
			oc !ci -ZoneDoor 1
			wait 300
		}
		else
		{
			
			relay ${Me.Name} runscript custom/GlobeTrotter "The Sundered Frontier"
			wait 3
			while ${Script[GlobeTrotter](exists)}
			{
				wait 50
			}
			;relay ${Me.Name} MessageBox "Please Take Me To Sundered Frontier (or Demitrik's Bastion)"
			;echo Send me to SF or Demitriks
			wait 300
		}
		call KillMessageBox
	}
	;Kill named to open portal
	call MovementManager 0.58 101.43 -43.37 "Demitrik's Bastion" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	eq2execute /g incoming
	call CampSpotAt ${Me.Name} -0.31 29.23 -31.95
	while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-0.31,29.23,-31.95]} > 5
	{
		wait 20
	}
	wait 50
	
	
	while ${Actor[Protector Ghondu](exists)} || ${Actor[Shirinu](exists)} || ${Actor[Tiriini](exists)}
	{
		wait 50
	}
	call MovementManager 52.05 38.80 1.23 "Demitrik's Bastion" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	call CampSpotAt ${Me.Name} 37.51 79.37 -0.21
	while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},37.51,79.37,-0.21]} > 3
	{
		wait 10
	}
	wait 20
	Actor[Teleporter]:DoubleClick
	wait 100
	call MovementManager -500.29 14.51 -54.58 "Demitrik's Bastion" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} 1
	call CampSpotAt ${Me.Name} -473.85 -12.05 -54.91
	wait 30
	call MovementManager -229.95 -2.89 142.28 "Demitrik's Bastion" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} 1
	call CampSpotAt ${Me.Name} -207.63 -38.00 140.89
	while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-207.63,-38.00,140.89]} > 3
	{
		wait 1
	}
	call CampSpotAt ${Me.Name} -212.98 -37.81 141.68
	wait 40
	Actor[pack_rat_treasure]:DoubleClick
	wait 50
	Actor[pack_rat_treasure]:DoubleClick
	wait 50
	call CampSpotAt ${Me.Name} -180 -37.85 141.68
	wait 100
	oc !ci -Revive ${Me.Name}
	wait 200
	while ${Zone.Name.Equals["Demitrik's Bastion"]}
	{
		call MovementManager -37.52 107.98 -169.39 "Demitrik's Bastion" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} 1
		wait 20
		oc !ci -Zone ${Me.Name}
		wait 300
	}
}

function MindflowOld()
{
	if ${Zone.Name.Equals[The Stonebrunt Highlands]}
	{
		call MovementManager -492.67 370.17 1511.43 "The Stonebrunt Highlands" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		while !${Zone.Name.Equals[The Sundered Frontier]} && !${Zone.Name.Equals["Demitrik's Bastion"]}
		{
			relay ${Me.Name} MessageBox "Attempting To Zone To Sundered Frontier (may need you to do it for me!)"
			echo Take me to Sundered Frontier!
			call FlyToSundered
		}
		call KillMessageBox
	}
	while !${Zone.Name.Equals[The Sundered Frontier]} && !${Zone.Name.Equals["Demitrik's Bastion"]}
	{
		
		relay ${Me.Name} runscript custom/GlobeTrotter "The Sundered Frontier"
		wait 3
		while ${Script[GlobeTrotter](exists)}
		{
			wait 50
		}
		;relay ${Me.Name} MessageBox "Please Take Me To Sundered Frontier"
		;echo Take me to Sundered Frontier!
		wait 300
	}
	call KillMessageBox
	while !${Zone.Name.Equals["Demitrik's Bastion"]}
	{
		if ${Zone.Name.Equals[The Sundered Frontier]}
		{	
			call DownToTheHoleLobby
			call MovementManager 1849.31 -371.33 3450.46 "The Sundered Frontier" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
			while ${botUtil.FurthestGroupmemberDistance} > 5
			{
				relay ${Me.Name} MessageBox "Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away. (this message will self-destruct)"
				echo Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away.
				wait 2
			}
			wait 40
			call KillMessageBox
			oc !ci -Zone ${Me.Name}
			wait 50
			oc !ci -ZoneDoor 1
			wait 300
		}
		else
		{
			
			relay ${Me.Name} runscript custom/GlobeTrotter "The Sundered Frontier"
			wait 3
			while ${Script[GlobeTrotter](exists)}
			{
				wait 50
			}
			;relay ${Me.Name} MessageBox "Please Take Me To Sundered Frontier (or Demitrik's Bastion)"
			;echo Send me to SF or Demitriks
			wait 300
		}
		call KillMessageBox
	}
	;Kill named to open portal
	call MovementManager 0.58 101.43 -43.37 "Demitrik's Bastion" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	eq2execute /g incoming
	call CampSpotAt ${Me.Name} -0.31 29.23 -31.95
	while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-0.31,29.23,-31.95]} > 5
	{
		wait 20
	}
	wait 50
	
	call CampSpotAt ${Me.Name} 1.55 22.31 53.85
	wait 80
	call CampSpotAt ${Me.Name} -0.68 22.54 33.10
	wait 80
	target Protector
	while ${Actor[Protector Ghondu](exists)} || ${Actor[Shirinu](exists)} || ${Actor[Tiriini](exists)}
	{
		eq2execute /target_none
		wait 20
		target Ghondu
		wait 20
		if ${Me.ToActor.IsDead}
		{
			wait 150
			if ${Me.ToActor.IsDead}
			{
				oc !ci -Revive
				wait 300
				call Mindflow
				return
			}
		}
	}
	call MovementManager 52.05 38.80 1.23 "Demitrik's Bastion" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	call CampSpotAt ${Me.Name} 37.51 79.37 -0.21
	while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},37.51,79.37,-0.21]} > 3
	{
		wait 10
	}
	wait 20
	Actor[Teleporter]:DoubleClick
	wait 100
	call MovementManager -500.29 14.51 -54.58 "Demitrik's Bastion" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} 1
	call CampSpotAt ${Me.Name} -473.85 -12.05 -54.91
	wait 30
	call MovementManager -229.95 -2.89 142.28 "Demitrik's Bastion" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} 1
	call CampSpotAt ${Me.Name} -207.63 -38.00 140.89
	while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-207.63,-38.00,140.89]} > 3
	{
		wait 1
	}
	call CampSpotAt ${Me.Name} -212.98 -37.81 141.68
	wait 40
	Actor[pack_rat_treasure]:DoubleClick
	wait 50
	Actor[pack_rat_treasure]:DoubleClick
	wait 50
	call CampSpotAt ${Me.Name} -180 -37.85 141.68
	wait 100
	oc !ci -Revive ${Me.Name}
	wait 200
	while ${Zone.Name.Equals["Demitrik's Bastion"]}
	{
		call MovementManager -37.52 107.98 -169.39 "Demitrik's Bastion" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} 1
		wait 20
		oc !ci -Zone ${Me.Name}
		wait 300
	}
}


function Mercury()
{
	if ${Zone.Name.Equals[The Stonebrunt Highlands]}
	{
		call MovementManager -492.67 370.17 1511.43 "The Stonebrunt Highlands" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		while !${Zone.Name.Equals[The Sundered Frontier]} && !${Zone.Name.Equals[The Hole]}
		{
			relay ${Me.Name} MessageBox "Attempting To Zone To Sundered Frontier (may need you to do it for me!)"
			echo Take me to Sundered Frontier!
			call FlyToSundered
		}
		call KillMessageBox
	}
	while !${Zone.Name.Equals[The Sundered Frontier]} && !${Zone.Name.Equals[The Hole]}
	{
		
		relay ${Me.Name} runscript custom/GlobeTrotter "The Sundered Frontier"
		wait 3
		while ${Script[GlobeTrotter](exists)}
		{
			wait 50
		}
		;relay ${Me.Name} MessageBox "Please Take Me To Sundered Frontier"
		;echo Take me to Sundered Frontier!
		wait 300
	}
	call KillMessageBox
	while ${Zone.Name.Equals[The Sundered Frontier]}
	{
		call DownToTheHoleLobby
		call MovementManager 1894.53 -371.65 3495.34 "The Sundered Frontier" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		
		while ${botUtil.FurthestGroupmemberDistance} > 5
		{
			relay ${Me.Name} MessageBox "Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away. (this message will self-destruct)"
			echo Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away.
			wait 2
		}
		wait 40
		call KillMessageBox
		oc !ci -Zone ${Me.Name}
		wait 300
	}
	wait 200
	call DescendHoleElevator
	
	while ${needMercury}
	{
		call MovementManager 23.30 -102.24 -939.95 "${Zone.Name}" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		call MovementManager -58.05 -88.89 -1036.29 "${Zone.Name}" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	}
	
	call AscendHoleElevator
	
	while ${Zone.Name.Equals["The Hole"]}
	{
		call MovementManager -117.46 117.80 -398.89 "The Hole" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} 1
		oc !ci -Zone ${Me.Name}
		wait 300
	}
}

function AscendHoleElevator()
{
	if ${Me.Y} < 50
	{
		call MovementManager -117.32 -58.82 -1033.71 "${Zone.Name}" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		call CampSpotAt ${Me.Name} -115.94 -58.78 -1021.16
		while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-115.94,-58.78,-1021.16]} > 4
		{
			wait 1
		}
		wait 5
		call CampSpotAt ${Me.Name} -122.45 -58.77 -1005.51
		while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-122.45,-58.77,-1005.51]} > 4
		{
			wait 1
		}
		wait 5
		call CampSpotAt ${Me.Name} -138.06 -58.80 -992.68
		while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-138.06,-58.80,-992.68]} > 4
		{
			wait 1
		}
		wait 5
		call CampSpotAt ${Me.Name} -150.77 -58.78 -991.52
		while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-150.77,-58.78,-991.52]} > 4
		{
			wait 1
		}
		wait 20
		if !${usingElevator.Equals[None]} && !${Me.Group[${usingElevator}](exists)}
		{
			while !${usingElevator.Equals[None]} && !${Me.Group[${usingElevator}](exists)}
			{
				wait 15
			}
			wait 100
		}
		relay all echo \${Script[EpicRepercussions].VariableScope.usingElevator:Set[${Me.Name}]} using elevator
		eq2execute "/apply_verb ${Actor[elevator_control].ID} Lower Elevator"
		wait 800
	
		call MovementManager -150.46 -58.56 -998.79 "${Zone.Name}" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		wait 20
		while ${botUtil.FurthestGroupmemberDistance} > 3
		{
			relay ${Me.Name} MessageBox "Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away. (this message will self-destruct)"
			echo Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away.
			wait 2
		}
		wait 40
		call KillMessageBox
		eq2execute "/apply_verb ${Actor[elevator_control].ID} Raise Elevator"
		while ${Me.Y} < 132
		{
			wait 10
		}
		wait 70
		call CampSpotAt ${Me.Name} -164.62 133.93 -991.84
		while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-164.62,133.93,-991.84]} > 4
		{
			wait 1
		}
		relay all echo \${Script[EpicRepercussions].VariableScope.usingElevator:Set[None]} using elevator
	}
}

function DescendHoleElevator()
{
	if ${Me.Y} > 50
	{
		;Fight to elevator
		call MovementManager -168.3 133.93 -992.69 "${Zone.Name}" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} 1
		wait 20
		while ${botUtil.FurthestGroupmemberDistance} > 5
		{
			relay ${Me.Name} MessageBox "Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away. (this message will self-destruct)"
			echo Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away.
			wait 2
		}
		if !${usingElevator.Equals[None]} && !${Me.Group[${usingElevator}](exists)}
		{
			while !${usingElevator.Equals[None]} && !${Me.Group[${usingElevator}](exists)}
			{
				wait 15
			}
			wait 100
		}
		relay all echo \${Script[EpicRepercussions].VariableScope.usingElevator:Set[${Me.Name}]} using elevator
		wait 40
		call KillMessageBox
		eq2execute "/apply_verb ${Actor[elevator_control].ID} Raise Elevator"
		wait 800
		
		;Lower Elevator
		call CampSpotAt ${Me.Name} -162.64 133.86 -1000.93
		wait 50
		while ${botUtil.FurthestGroupmemberDistance} > 3
		{
			relay ${Me.Name} MessageBox "Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away. (this message will self-destruct)"
			echo Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away.
			wait 2
		}
		wait 40
		call KillMessageBox
		echo Lowering Elevator!
		eq2execute "/apply_verb ${Actor[elevator_control].ID} Lower Elevator"
		while ${Me.Y} > -55
		{
			wait 10
		}
		wait 70
		call CampSpotAt ${Me.Name} -150.77 -58.78 -991.52
		while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-150.77,-58.78,-991.52]} > 4
		{
			wait 1
		}
		relay all echo \${Script[EpicRepercussions].VariableScope.usingElevator:Set[None]} using elevator
		wait 5
		call CampSpotAt ${Me.Name} -138.06 -58.80 -992.68
		while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-138.06,-58.80,-992.68]} > 4
		{
			wait 1
		}
		wait 5
		call CampSpotAt ${Me.Name} -122.45 -58.77 -1005.51
		while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-122.45,-58.77,-1005.51]} > 4
		{
			wait 1
		}
		wait 5
		call CampSpotAt ${Me.Name} -115.94 -58.78 -1021.16
		while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-115.94,-58.78,-1021.16]} > 4
		{
			wait 1
		}
		wait 5
		call CampSpotAt ${Me.Name} -117.32 -58.82 -1033.71
		while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-117.32,-58.82,-1033.71]} > 4
		{
			wait 1
		}
	}
}

function Cella()
{
	oc !ci -ZoneResetAll
	while !${Zone.Name.Equals["The Stonebrunt Highlands"]} && !${Zone.Name.Equals["The Vasty Deep"]} && !${Zone.Name.Equals["Vasty Deep: The Vestigial Cella"]}
	{
		
		relay ${Me.Name} runscript custom/GlobeTrotter "The Stonebrunt Highlands"
		wait 3
		while ${Script[GlobeTrotter](exists)}
		{
			wait 50
		}
		;elay ${Me.Name} MessageBox "Please Take Me To Stonebrunt"
		;echo Take me to Stonebrunt!
		wait 300
	}
	call KillMessageBox
	while ${Zone.Name.Equals["The Stonebrunt Highlands"]}
	{
		call MovementManager -159.62 174.49 -362.91 "The Stonebrunt Highlands" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		oc !ci -Special ${Me.Name}
		wait 300
	}
	while !${Zone.Name.Equals["Vasty Deep: The Vestigial Cella"]}
	{
		if ${Zone.Name.Equals["The Vasty Deep"]}
		{
			call MovementManager -0.19 -53.11 14.14 "The Vasty Deep" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		
			while ${botUtil.FurthestGroupmemberDistance} > 5
			{
				relay ${Me.Name} MessageBox "Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away. (this message will self-destruct)"
				echo Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away.
				wait 2
			}
			wait 40
			call KillMessageBox
			Actor[zone_to_vastydeep03]:DoubleClick
			;oc !ci -Zone ${Me.Name}
		}
		wait 300
	}
	
	while ${Zone.Name.Equals["Vasty Deep: The Vestigial Cella"]}
	{
		echo Waiting for you to finish and/or leave Cella
		wait 300
	}
	while ${Zone.Name.Equals["The Vasty Deep"]}
	{
		call MovementManager 6.79 -33.75 66.34 "The Vasty Deep" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		oc !ci -Zone ${Me.Name}
		wait 300a
	}
}

function CellaOld()
{
	oc !ci -ZoneResetAll
	while !${Zone.Name.Equals["The Stonebrunt Highlands"]} && !${Zone.Name.Equals["The Vasty Deep"]} && !${Zone.Name.Equals["Vasty Deep: The Vestigial Cella"]}
	{
		
		relay ${Me.Name} runscript custom/GlobeTrotter "The Stonebrunt Highlands"
		wait 3
		while ${Script[GlobeTrotter](exists)}
		{
			wait 50
		}
		;elay ${Me.Name} MessageBox "Please Take Me To Stonebrunt"
		;echo Take me to Stonebrunt!
		wait 300
	}
	call KillMessageBox
	while ${Zone.Name.Equals["The Stonebrunt Highlands"]}
	{
		call MovementManager -159.62 174.49 -362.91 "The Stonebrunt Highlands" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		oc !ci -Special ${Me.Name}
		wait 300
	}
	while !${Zone.Name.Equals["Vasty Deep: The Vestigial Cella"]}
	{
		if ${Zone.Name.Equals["The Vasty Deep"]}
		{
			call MovementManager -0.19 -53.11 14.14 "The Vasty Deep" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		
			while ${botUtil.FurthestGroupmemberDistance} > 5
			{
				relay ${Me.Name} MessageBox "Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away. (this message will self-destruct)"
				echo Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away.
				wait 2
			}
			wait 40
			call KillMessageBox
			Actor[zone_to_vastydeep03]:DoubleClick
			;oc !ci -Zone ${Me.Name}
		}
		wait 300
	}
	call MovementManager -92.76 1.63 1.64 "Vasty Deep: The Vestigial Cella" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	;-8.42 10.03 -93.91 295.93 0.00 0.00
	call MovementManager -8.42 10.03 -93.91 "Vasty Deep: The Vestigial Cella" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	call MovementManager -95.11 19.57 -125.07 "Vasty Deep: The Vestigial Cella" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	variable bool crystashaActive = TRUE
	variable bool crystashaNamedUp = TRUE
	variable int crystashaCounter = 0
	while ${crystashaActive}
	{
		crystashaActive:Set[FALSE]
		eq2execute /target_none
		wait 20
		target Crystasha
		crystashaCounter:Set[0]
		while ${crystashaCounter} < 10
		{
			wait 30
			if ${Actor[namednpc,Crystasha](exists)}
			{
				target Crystasha
				crystashaNamedUp:Set[TRUE]
				crystashaActive:Set[TRUE]
			}
			elseif ${Actor[Deep Widow](exists)}
			{
				target Deep
				crystashaActive:Set[TRUE]
			}
			elseif ${crystashaNamedUp}
			{
				crystashaCounter:Set[100]
			}
			crystashaCounter:Inc[1]
		}
		wait 60
		if ${crystashaNamedUp} && !${Actor[namednpc,Crystasha](exists)}
		{
			crystashaActive:Set[FALSE]
		}
	}
	call MovementManager -98.95 20.64 -145.12 "Vasty Deep: The Vestigial Cella" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	call CampSpotAt ${Me.Name} -98.95 20.64 -145.12
	wait 20
	call CampSpotAt ${Me.Name} -137.47 20.00 -145.54
	while ${Actor[Judith](exists)} && !${Actor[Judith].Target(exists)}
	{
		target Judith
		wait 1
	}
	call CampSpotAt ${Me.Name} -98.95 20.64 -145.12
	while ${Actor[Judith](exists)}
	{
		wait 10
	}
	
	;fight to snake nameds
	;-152.31 20.00 -146.20 93.64 0.00 0.00
	call MovementManager -152.31 20.00 -146.20 "Vasty Deep: The Vestigial Cella" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	call MovementManager -152.40 13.17 -100.79 "Vasty Deep: The Vestigial Cella" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	call MovementManager -159.47 12.21 -82.76 "Vasty Deep: The Vestigial Cella" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	call CampSpotAt ${Me.Name} -204.95 12.59 -87.35
	eq2execute /target_none
	wait 30
	while ${Actor[namednpc,Krait](exists)}
	{
		wait 5
	}
	
	;fight to tunnel before queen room
	call MovementManager -256.61 20.75 -6.77 "Vasty Deep: The Vestigial Cella" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	
	;attempt to pull mobs back into tunnel
	call CampSpotAt ${Me.Name} -257.16 13.24 18.40
	while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-257.16,13.24,18.40]} > 4 && ${botUtil.MobsAggro} == 0 && ${Me.Y} > -25
	{
		waitframe
	}
	call CampSpotAt ${Me.Name} -257.20 19.62 -16.28
	while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-257.20,19.62,-16.28]} > 4 && ${botUtil.MobsAggro} > 0 && ${Me.Y} > -25
	{
		waitframe
	}
	
	;if i havent fallen down into water, run across bridge.
	if  ${Me.Y} > -25
	{
		call MovementManager -257.36 10.00 39.59 "Vasty Deep: The Vestigial Cella" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	}
	call FightQueen
	
	;Move to Delahnus
	call CampSpotAt ${Me.Name} -233.18 18.87 85.97
	while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-233.18,18.87,85.97]} > 4
	{
		oc !ci -FlyUp ${Me.Name}
		call GetOutOfWater
		wait 5
	}
	oc !ci -FlyStop ${Me.Name}
	oc !ci -Pause ${Me.Name}
	wait 30
	call GetPerspective
	target Delahnus
	face Delahnus
	wait 20
	eq2execute h
	Actor[Delahnus]:DoubleClick
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -Resume ${Me.Name}
	
	while ${Zone.Name.Equals["Vasty Deep: The Vestigial Cella"]}
	{
		oc !ci -FlyUp ${Me.Name}
		call MovementManager 11.53 -11.87 7.50 "Vasty Deep: The Vestigial Cella" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		oc !ci -FlyStop ${Me.Name}
		while ${botUtil.FurthestGroupmemberDistance} > 5
		{
			relay ${Me.Name} MessageBox "Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away. (this message will self-destruct)"
			echo Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away.
			wait 2
		}
		wait 40
		call KillMessageBox
		oc !ci -Zone ${Me.Name}
		wait 300
	}
	while ${Zone.Name.Equals["The Vasty Deep"]}
	{
		call MovementManager 6.79 -33.75 66.34 "The Vasty Deep" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		oc !ci -Zone ${Me.Name}
		wait 300a
	}
}

function CheckQueen()
{
	if ${Actor[namednpc,Queen](exists)}
	{
		queenUp:Set[TRUE]
		if ${queenAggro} && !${Actor[namednpc,Queen].Target(exists)}
		{
			;encounter must have reset
			queenAggro:Set[FALSE]
			call FightQueen
			wait 50
		}
		elseif !${queenAggro} && ${Actor[namednpc,Queen].Target(exists)}
		{
			queenAggro:Set[TRUE]
		}
	}
	else 
	{
		wait 50
		if !${Actor[namednpc,Queen](exists)}
		{
			queenUp:Set[FALSE]
		}
	}
}

function FightQueen()
{
	;Move to pool
	eq2execute /g Guys - everyone in the pool!
	call CampSpotAt ${Me.Name} -229.06 12.24 50.41
	while ${queenUp} && ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-229.06,12.24,50.41]} > 4
	{
		call CheckQueen
		call GetOutOfWater
		wait 5
	}
	eq2execute /target_none
	
	;Aggro other mobs
	eq2execute /g Grabbing the adds
	call CampSpotAt ${Me.Name} -230.60 13.87 62.19
	while ${queenUp} && ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-230.60,13.87,62.19]} > 4
	{
		call CheckQueen
		call GetOutOfWater
		wait 5
	}
	
	;Move to pool
	eq2execute /g And back to pool!
	call CampSpotAt ${Me.Name} -229.06 12.24 50.41
	while ${queenUp} && ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-229.06,12.24,50.41]} > 4
	{
		call CheckQueen
		call GetOutOfWater
		wait 5
	}
	eq2execute /target_none
	
	;Wait to let people catch up and kill the mobs
	wait 300
	wait ${Math.Rand[100]}
	
	;Default sticktopool is false, which means first person to get here become the main actor in this encounter.
	if !${stickToPool}
	{
		;Tell everyone else to stay back.
		relay ${mythRG} echo \${Script[EpicRepercussions].VariableScope.stickToPool:Set[TRUE]}
		wait 10
		stickToPool:Set[FALSE]
	
	
		eq2execute /g Aggroing Queen
		;Aggro Queen
		;call CampSpotAt ${Me.Name} -233.18 18.87 85.97
		while ${queenUp} && ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-233.18,18.87,85.97]} > 5
		{
			oc !ci -FlyUp ${Me.Name}
			call CheckQueen
			call GetOutOfWater
			target me
			wait 5
			oc !ci -LetsGo ${Me.Name}
			relay ${Me.Name} runscript "${Script.CurrentDirectory}/OgreMove_Modified" loc -233.18 18.87 85.97
		}
		oc !ci -FlyStop ${Me.Name}
		wait 20
		
		;Move to top of stairs for easy retreat to pool
		eq2execute /g Getting read to jump in pool
		oc !ci -LetsGo ${Me.Name}
		target me
		wait 5
		while ${queenUp} && ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-232.05,18.87,69.20]} > 5
		{
			call CheckQueen
			call GetOutOfWater
			target me
			if !${Script[OgreMove_Modified](exists)}
			{
				oc !ci -LetsGo ${Me.Name}
				relay ${Me.Name} runscript "${Script.CurrentDirectory}/OgreMove_Modified" loc -232.05 18.87 69.20
			}
			wait 1
		}
		
		
		eq2execute /g Getting her to 90
		;Get Queen down to 90
		target Queen
		;call CampSpotAt ${Me.Name} -232.05 18.87 69.20
		while ${queenUp} && ${Actor[Queen].Health} >= 90
		{
			call CheckQueen
			if !${Target.Name.Find[Queen](exists)}
			{
				target Queen
			}
			call GetOutOfWater
			if ${queenUp} && ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-232.05,18.87,69.20]} > 3
			{
				target me
				oc !ci -LetsGo ${Me.Name}
				relay ${Me.Name} runscript "${Script.CurrentDirectory}/OgreMove_Modified" loc -232.05 18.87 69.20
			}
			;call CampSpotAt ${Me.Name} -232.05 18.87 69.20
			waitframe
		}
	}
	eq2execute /g Back to pool at 90
	;back to pool
	call CampSpotAt ${Me.Name} -229.06 12.24 50.41
	while ${queenUp} && ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-229.06,12.24,50.41]} > 4
	{
		call CheckQueen
		call GetOutOfWater
		wait 5
	}
	wait 150
	target Queen
	if !${stickToPool}
	{
		eq2execute /g Queen to 60!
		;call CampSpotAt ${Me.Name} -232.05 18.87 69.20
		while ${queenUp} && ${Actor[Queen].Health} >= 60
		{
			call CheckQueen
			if !${Target.Name.Find[Queen](exists)}
			{
				target Queen
			}
			call GetOutOfWater
			if ${queenUp} && ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-232.05,18.87,69.20]} > 3
			{
				target me
				oc !ci -LetsGo ${Me.Name}
				relay ${Me.Name} runscript "${Script.CurrentDirectory}/OgreMove_Modified" loc -232.05 18.87 69.20
			}
			;call CampSpotAt ${Me.Name} -232.05 18.87 69.20
			waitframe
		}
		oc !ci -FlyStop ${Me.Name}
	}
	eq2execute /g Back to pool 60
	;back to pool
	call CampSpotAt ${Me.Name} -229.06 12.24 50.41
	while ${queenUp} && ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-229.06,12.24,50.41]} > 4
	{
		call CheckQueen
		call GetOutOfWater
		wait 5
	}
	wait 150
	target Queen
	if !${stickToPool}
	{
		;call CampSpotAt ${Me.Name} -232.05 18.87 69.20
		eq2execute /g Queen to 30!
		while ${queenUp} && ${Actor[Queen].Health} >= 30
		{
			call CheckQueen
			if !${Target.Name.Find[Queen](exists)}
			{
				target Queen
			}
			call GetOutOfWater
			if ${queenUp} && ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-232.05,18.87,69.20]} > 3
			{
				target me
				oc !ci -LetsGo ${Me.Name}
				relay ${Me.Name} runscript "${Script.CurrentDirectory}/OgreMove_Modified" loc -232.05 18.87 69.20
			}
			;call CampSpotAt ${Me.Name} -232.05 18.87 69.20
			waitframe
		}
		oc !ci -FlyStop ${Me.Name}
	}
	eq2execute /g Back to pool 30
	;back to pool
	call CampSpotAt ${Me.Name} -229.06 12.24 50.41
	while ${queenUp} && ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-229.06,12.24,50.41]} > 4
	{
		call CheckQueen
		call GetOutOfWater
		wait 5
	}
	wait 150
	eq2execute /g Queen to 10, stayin pool
	target Queen
	call CampSpotAt ${Me.Name} -229.06 12.24 50.41
	while ${queenUp} && ${Actor[Queen].Health} >= 10 && !${Actor[conch](exists)}
	{
		call CheckQueen
		if !${Target.Name.Find[Queen](exists)}
		{
			target Queen
		}
		call GetOutOfWater
		waitframe
	}
	;back to pool
	eq2execute /g Back to pool 10
	call CampSpotAt ${Me.Name} -229.06 12.24 50.41
	while ${queenUp} && ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-229.06,12.24,50.41]} > 4
	{
		call CheckQueen
		call GetOutOfWater
		wait 5
	}
	
	eq2execute /g Waiting for Queen to be gone
	while ${queenUp}
	{
		wait 100
		call CheckQueen
		call GetOutOfWater
		eq2execute /g Waiting for conch or queen to be gone
		while ${Actor[conch](exists)} && ${queenUp}
		{
			call CheckQueen
			call GetOutOfWater
			target me
			oc !ci -LetsGo ${Me.Name}
			oc !ci -FlyUp ${Me.Name}
			wait 4
			oc !ci -Pause ${Me.Name}
			relay ${Me.Name} runscript "${Script.CurrentDirectory}/OgreMove_Modified" loc ${Actor[conch].X} ${Actor[conch].Y} ${Actor[conch].Z}
			wait 20
			target conch
			wait 3
			eq2execute "/apply_verb ${Actor[conch].ID} Gather"
			wait 50
			oc !ci -Resume ${Me.Name}
		}
		
		eq2execute /g Run back to the pool~!
		oc !ci -Pause ${Me.Name}
		relay ${Me.Name} runscript "${Script.CurrentDirectory}/OgreMove_Modified" loc -217.65 12.94 46.81
		while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-217.65,12.94,46.81]} > 5 && ${queenUp}
		{
			call CheckQueen
			call GetOutOfWater
			target me
			wait 20
			relay ${Me.Name} runscript "${Script.CurrentDirectory}/OgreMove_Modified" loc -217.65 12.94 46.81
		}
		oc !ci -Resume ${Me.Name}
		wait 5
		eq2execute /target_none
		call CampSpotAt ${Me.Name} -229.06 12.24 50.41
		wait 100
		
		eq2execute /g Using conch
		while ${Me.Inventory[conch](exists)} && ${queenUp}
		{
			call CheckQueen
			Me.Inventory[conch]:Use
			wait 10
		}
		wait 200
	}
}

function GetOutOfWater()
{
	echo GetOutOfWater Dead:${Me.ToActor.IsDead} InWater:${Me.Y}<-10
	if ${Me.ToActor.IsDead}
	{
		echo In ifDead
		wait 100
		if ${Me.ToActor.IsDead}
		{
			In secondIfDead
			oc !ci -Revive ${Me.Name}
			wait 200
			
			;Crystasha
			call MovementManager -95.11 19.57 -125.07 "Vasty Deep: The Vestigial Cella" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
			;Snakes
			call MovementManager -201.27 12.17 -86.18 "Vasty Deep: The Vestigial Cella" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
			;Queen Room
			call MovementManager -257.36 10.00 39.59 "Vasty Deep: The Vestigial Cella" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
			
			call FightQueen
		}
	}
	elseif ${Me.Y} < -10
	{
		oc !ci -Resume ${Me.Name}
		echo In IfInWater
		if ${Me.Z} < 50
		{
			target me
			if ${Me.X} > -230
			{
				call CampSpotAt ${Me.Name} -184.61 -74.16 37.29
				while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-184.61,-74.16,37.29]} > 4 && !${Me.ToActor.IsDead}
				{
					wait 5
				}
			}
			call CampSpotAt ${Me.Name} -231.06 -74.99 25.71
			while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-231.06,-74.99,25.71]} > 4 && !${Me.ToActor.IsDead}
			{
				wait 5
			}
			call CampSpotAt ${Me.Name} -257.63 -74.98 67.69
			while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-257.63,-74.98,67.69]} > 4 && !${Me.ToActor.IsDead}
			{
				wait 5
			}
		}
		else
		{
			target me
			call CampSpotAt ${Me.Name} -234.28 -74.84 125.40
			while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-234.28,-74.84,125.40]} > 4 && !${Me.ToActor.IsDead}
			{
				wait 5
			}
		}
		while ${Me.Y} < -10 && !${Me.ToActor.IsDead}
		{
			call CampSpotAt ${Me.Name} -225.38 -73.02 71.36
			while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-225.38,-73.02,71.36]} > 4 && !${Me.ToActor.IsDead} && ${Me.Y} < -50
			{
				wait 5
			}
			
			target me
			wait 3
			eq2execute /target_none
			call CampSpotAt ${Me.Name} -229.06 12.24 50.41
			variable int startTime = 0
			startTime:Set[${Time.Timestamp}]
			while ${Math.Calc[${Time.Timestamp} - ${startTime}]} < 10
			{
				if ${Me.Y} >= -10
				{
					eq2execute /target_none
					return
				}
				waitframe
			}
		}
		if ${queenUp} && !${Actor[namednpc,Queen].Target(exists)} && !${Me.ToActor.IsDead}
		{
			;encounter has been reset...
			call FightQueen
		}
		eq2execute /target_none
	}
}

function Research()
{
	while !${Zone.Name.Equals["The Stonebrunt Highlands"]} && !${Zone.Name.Equals["Erudin Research Halls"]}
	{
		
		relay ${Me.Name} runscript custom/GlobeTrotter "The Stonebrunt Highlands"
		wait 3
		while ${Script[GlobeTrotter](exists)}
		{
			wait 50
		}
		;relay ${Me.Name} MessageBox "Please Take Me To Stonebrunt"
		;echo Send me to Stonebrunt
		wait 300
	}
	call KillMessageBox
	while !${Zone.Name.Equals["Erudin Research Halls"]}
	{
		if ${Zone.Name.Equals["The Stonebrunt Highlands"]}
		{
			call MovementManager -557.33 530.53 -149.20 "The Stonebrunt Highlands" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
			wait 20
			while ${botUtil.FurthestGroupmemberDistance} > 5
			{
				relay ${Me.Name} MessageBox "Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away. (this message will self-destruct)"
				echo Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away.
				wait 2
			}
			wait 40
			call KillMessageBox
			Actor[research]:DoubleClick
		}
		wait 300
	}
	;Move to mirrors
	call MovementManager -219.25 -11.45 -113.87 "Erudin Research Halls" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	call PlaceMirrors
	call JumpTheShark
	
	;Wait for groupmembers
	while ${botUtil.FurthestGroupmemberDistance} > 5
	{
		relay ${Me.Name} MessageBox "Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away. (this message will self-destruct)"
		echo Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away.
		wait 2
	}
	wait 40
	call KillMessageBox
	
	;Kill Olkeen
	while ${Actor[V'lad Olkeen](exists)}
	{
		target Olkeen
		wait 150
	}
	
	;Return To Entrance
	oc !ci -LetsGo ${Me.Name}
	oc !ci -Evac ${Me.Name}
	wait 150
	if ${Math.Distance[${Me.X},${Me.Y},${Me.Z},22.51,-16.36,-301.41]} < 20
	{
		face 18.91 -16.36 -311.77
		oc !ci -AutoRun ${Me.Name}
		wait 50
		oc !ci -AutoRun ${Me.Name}
		wait 100
		oc !ci -Revive ${Me.Name}
		wait 400
	}
	
	;Zone out
	call MovementManager 0.05 0.00 38.53 "Erudin Research Halls" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	while ${Zone.Name.Equals["Erudin Research Halls"]}
	{
		oc !ci -Zone ${Me.Name}
		wait 300
	}
}
function JumpTheShark()
{
	call MovementManager -90.42 -17.13 -288.08 "Erudin Research Halls" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	call CampSpotAt ${Me.Name} -83.85 -15.74 -287.63
	wait 20
	oc !ci -Jump ${Me.name}
	wait 30
	call CampSpotAt ${Me.Name} -72.29 -16.00 -296.36
	wait 40
	call CampSpotAt ${Me.Name} -73.91 -16.00 -306.56
	wait 40
	variable bool restarted = FALSE
	call CampSpotAt ${Me.Name} -6.40 -15.79 -290.27
	while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-6.40,-15.79,-290.27]} > 4 && !${restarted}
	{
		wait 5
		if ${Me.ToActor.IsDead}
		{
			restarted:Set[TRUE]
			oc !ci -Revive ${Me.Name}
			wait 400
			call JumpTheShark
		}
	}
	;Wait for groupmembers
	while ${botUtil.FurthestGroupmemberDistance} > 5
	{
		relay ${Me.Name} MessageBox "Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away. (this message will self-destruct)"
		echo Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away.
		wait 2
	}
	wait 40
	call CampSpotAt ${Me.Name} 22.51 -16.36 -301.41
	wait 70
}
function PlaceMirrors()
{
	if ${mirrorManager.Equals[None]}
	{
		relay ${mythRG} echo \${Script[EpicRepercussions].VariableScope.mirrorManager:Set[${Me.Name}]}
	}
	if ${Me.In1stPersonView}
	{
		relay ${Me.Name} MessageBox "Heads Up - being in 1st person view may prevent this portion of the script from succeeding"
	}
	EQ2Press -hold numpad3
	wait 20
	EQ2Press -release numpad3
	wait ${Math.Rand[100]}
	call PlaceMirror -212.08 -11.50 -136.69 65138
	call PlaceMirror -219.69 -11.50 -139.21 65139
	call PlaceMirror -212.43 -11.45 -148.24 65140
	call PlaceMirror -219.06 -11.50 -150.26 65141
	call PlaceMirror -213.80 -11.50 -158.49 65142
	call PlaceMirror -219.15 -11.45 -161.40 65143
	call PlaceMirror -213.67 -11.50 -168.58 65144
	call PlaceMirror -219.96 -11.50 -173.10 65145
	while !${mirrorManager.Equals[${Me.Name}]} && ${Actor[laser mirror,radius,12](exists)}
	{
		echo Waiting for lasers to finish
		wait 100
	}
	call KillMessageBox
}

function PlaceMirror(int x, int y, int z, int id)
{
	if ${mirrorManager.Equals[${Me.Name}]}
	{
		if ${lastMirrorSuccess}
		{
			call MovementManager -221.93 -11.45 -115.08 "Erudin Research Halls" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
			call SelectMirror
			wait 30
		}
		if ${mirrorManager.Equals[${Me.Name}]}
		{
			Mouse:SetPosition[${Math.Calc[${Display.Width}*.5]},${Math.Calc[${Display.Height}*.95]}]
			wait 2
			call MovementManager ${x} ${y} ${z} "Erudin Research Halls" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
			wait 20
			if ${Math.Distance[${Actor[laser mirror].X},${Actor[laser mirror].Y},${Actor[laser mirror].Z},${Actor[laser_blocker].X},${Actor[laser_blocker].Y},${Actor[laser_blocker].Z}]} > 1 || ${Actor[laser mirror,radius,5].Z} > ${Me.Z}
			{
				while ${Math.Distance[${Actor[laser mirror].X},${Actor[laser mirror].Y},${Actor[laser mirror].Z},${Actor[laser_blocker].X},${Actor[laser_blocker].Y},${Actor[laser_blocker].Z}]} > .02
				{
					face laser_blocker
					Mouse:SetPosition[${Math.Calc[${Display.Width}*.5]},${Math.Calc[${Display.Height}*${Math.Calc[${Math.Calc[25 + ${Math.Rand[20]}]}/100]}]}]
					wait 2
					Mouse:LeftClick
					wait 20
				}
				lastMirrorSuccess:Set[TRUE]
			}
			else
			{
				lastMirrorSuccess:Set[FALSE]
				
			}
		}
	}
}
function SelectMirror()
{
	if ${Actor[laser mirror,radius,15](exists)}
	{
		call CampSpotAt ${Me.Name} -220.01 -11.45 -117.03
		while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-220.01,-11.45,-117.03]} > 3
		{
			waitframe
		}
		wait 2
		if ${Actor[laser mirror,radius,6](exists)}
		{
			Actor[laser mirror]:DoubleClick
			wait 20
		}
		else
		{
			call CampSpotAt ${Me.Name} -219.44 -11.45 -111.05
			while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-219.44,-11.45,-111.05]} > 3
			{
				waitframe
			}
			wait 2
			Actor[laser mirror]:DoubleClick
			wait 20
		}
	}
	else
	{
		echo No Mirror to SelectMirror
	}
}

function Library()
{
	while !${Zone.Name.Equals[The Stonebrunt Highlands]} && !${Zone.Name.Equals["Library of Erudin"]}
	{
		
		relay ${Me.Name} runscript custom/GlobeTrotter "The Stonebrunt Highlands"
		wait 3
		while ${Script[GlobeTrotter](exists)}
		{
			wait 50
		}
		;relay ${Me.Name} MessageBox "Please Take Me To Stonebrunt"
		;echo Bruh, take me to Stonebrunt
		wait 300
	}
	oc !ci -ZoneResetAll ${Me.Name}
	call KillMessageBox
	while !${Zone.Name.Equals["Library of Erudin"]}
	{
		if ${Zone.Name.Equals[The Stonebrunt Highlands]}
		{
			call MovementManager -555.55 530.53 -138.05 "The Stonebrunt Highlands" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
			if ${botUtil.FurthestGroupmemberDistance} > 5
			{
				relay ${Me.Name} MessageBox "Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away. (this message will self-destruct)"
			}
			while ${botUtil.FurthestGroupmemberDistance} > 5
			{
				echo Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away.
				wait 2
			}
			call KillMessageBox
			wait 40
			;zone_erudin_library
			Actor[zone_erudin_library]:DoubleClick
			;oc !ci -Zone ${Me.Name}
			wait 300
		}
	}
	;Move to named room
	call MovementManager -162.48 -28.50 -42.85 "Library of Erudin" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	
	;CS on top block, pull named
	call CampSpotAt ${Me.Name} -183.17 -23.31 -46.80
	while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-183.17,-23.31,-46.80]} > 3
	{
		wait 1
	}
	while ${botUtil.FurthestGroupmemberDistance} > 5 && !${Actor[Archivist].Target(exists)}
	{
		relay ${Me.Name} MessageBox "Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away. (this message will self-destruct)"
		echo Waiting for groupmember that is ${botUtil.FurthestGroupmemberDistance}m away.
		wait 2
	}
	call KillMessageBox
	wait 40
	while ${Actor[Archivist Fahim](exists)} && ${Me.Y} < -2.3
	{
		target Archivist
		wait 50
		if ${Me.Y} > -4
		{
			oc !ci -Jump ${Me.Name}
		}
	}
	oc !ci -Jump ${Me.Name}
	wait 100
	oc !ci -Jump ${Me.Name}
	wait 30
	while ${Me.Y} < -2.3 && ${needBook}
	{
		relay ${Me.Name} MessageBox "Need help getting up top"
		oc !ci -Jump ${Me.Name}
		wait 50
	}
	call KillMessageBox
	while ${needBook}
	{
		call CheckTable -150.48 -2.37 -93.37
		
		;this one is the issue
		call CheckTable -259.95 -2.37 -90.72
		
		;unless its this one
		call CheckTable -250.92 -2.37 -66.99
		call CheckTable -250.97 -2.37 -12.44
		call CheckTable -260.17 -2.37 10.76
		call CheckTable -153.58 -2.37 11.93
		call CheckTable -145.94 -2.37 9.62
	}
	
	;Go back to first level
	call MovementManager -183.12 -2.37 -41.70 "Library of Erudin" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	call CampSpotAt ${Me.Name} -181.25 -28.50 -72.20
	while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-181.25,-28.50,-72.20]} > 3
	{
		wait 1
	}
	
	;Zone out
	while ${Zone.Name.Equals["Library of Erudin"]}
	{
		;Return to Entrance
		call MovementManager 1.06 0.00 1.63 "Library of Erudin" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	 ;erudin_exit_clicky
		Actor[erudin_exit_clicky]:DoubleClick
		;oc !ci -Zone ${Me.Name}
		wait 300
	}
	
}
function NPCAfterLibrary()
{
	while !${Zone.Name.Equals["The Stonebrunt Highlands"]}
	{
		
		relay ${Me.Name} runscript custom/GlobeTrotter "The Stonebrunt Highlands"
		wait 3
		while ${Script[GlobeTrotter](exists)}
		{
			wait 50
		}
		;Return to Entrance
		;relay ${Me.Name} MessageBox "Please take me to Stonebrunt Highlands"
		wait 300
	}
	
	;Return to QuelUle
	call MovementManager -437.89 379.70 654.58 "The Stonebrunt Highlands" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	
	call GetPerspective
	target Mukhlisah
	face Mukhlisah
	wait 10
	eq2execute h
	Actor[Mukhlisah]:DoubleClick
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
}
function CheckTable(int x, int y, int z)
{
	if ${needBook}
	{
		call MovementManager ${x} ${y} ${z} "Library of Erudin" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} 1
		wait 20
		oc !ci -Special ${Me.Name}
		wait 40
	}
}

function GetSnakesScintillasPondweed()
{
	while !${Zone.Name.Equals[The Stonebrunt Highlands]}
	{
		
		relay ${Me.Name} runscript custom/GlobeTrotter "The Stonebrunt Highlands"
		wait 3
		while ${Script[GlobeTrotter](exists)}
		{
			wait 50
		}
		;relay ${Me.Name} MessageBox "Please Take Me To Stonebrunt"
		;echo Bruh, take me to Stonebrunt
		wait 300
	}
	call KillMessageBox
	call GetSnakes
}
function GetScintillasWrapper()
{
	while !${Zone.Name.Equals[The Stonebrunt Highlands]}
	{
		
		relay ${Me.Name} runscript custom/GlobeTrotter "The Stonebrunt Highlands"
		wait 3
		while ${Script[GlobeTrotter](exists)}
		{
			wait 50
		}
		;relay ${Me.Name} MessageBox "Please Take Me To Stonebrunt"
		;echo Bruh, take me to Stonebrunt
		wait 300
	}
	call KillMessageBox
	call GetScintillas
}
function GetPondweedWrapper()
{
	while !${Zone.Name.Equals[The Stonebrunt Highlands]}
	{
		
		relay ${Me.Name} runscript custom/GlobeTrotter "The Stonebrunt Highlands"
		wait 3
		while ${Script[GlobeTrotter](exists)}
		{
			wait 50
		}
		;relay ${Me.Name} MessageBox "Please Take Me To Stonebrunt"
		;echo Bruh, take me to Stonebrunt
		wait 300
	}
	call KillMessageBox
	call GetPondweed
}
function LamaAfterPondweed()
{
	while !${Zone.Name.Equals[The Stonebrunt Highlands]}
	{
		
		relay ${Me.Name} runscript custom/GlobeTrotter "The Stonebrunt Highlands"
		wait 3
		while ${Script[GlobeTrotter](exists)}
		{
			wait 50
		}
		;relay ${Me.Name} MessageBox "Please Take Me To Stonebrunt"
		;echo Bruh, take me to Stonebrunt
		wait 300
	}
	call KillMessageBox
	call MovementManager 547.04 209.02 2.95 "The Stonebrunt Highlands" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	call CampSpotAt ${Me.Name} 559.47 206.99 -3.53
	while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},559.47,206.99,-3.53]} > 4
	{
		wait 2
	}
	call MovementManager 550.43 233.07 -96.17 "The Stonebrunt Highlands" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	
	call GetPerspective
	target Lama
	face Lama
	wait 10
	eq2execute h
	Actor[Lama]:DoubleClick
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	target Lama
	face Lama
	wait 10
	eq2execute h
	Actor[Lama]:DoubleClick
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	target Lama
	face Lama
	wait 10
	eq2execute h
	Actor[Lama]:DoubleClick
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
}

function GetSnakes()
{
	while !${Zone.Name.Equals[The Stonebrunt Highlands]}
	{
		
		relay ${Me.Name} runscript custom/GlobeTrotter "The Stonebrunt Highlands"
		wait 3
		while ${Script[GlobeTrotter](exists)}
		{
			wait 50
		}
		;relay ${Me.Name} MessageBox "Please Take Me To Stonebrunt"
		;echo Bruh, take me to Stonebrunt
		wait 300
	}
	call KillMessageBox
	while ${needSnakes}
	{
		;-101.97 383.84 1088.78 154.78 0.00 0.00
		call HuntSnake 119.58 365.90 902.48
		call HuntSnake 126.60 364.96 966.44
		call HuntSnake 165.57 367.17 1011.09
		call HuntSnake 191.47 366.85 1015.49
		call HuntSnake 241.69 368.55 1014.66
		call HuntSnake -58.57 368.76 1004.45
		call HuntSnake -82.21 378.03 1059.07
		;call HuntSnake -93.49 382.91 1064.06
		call HuntSnake -140.34 365.92 1240.15
		call HuntSnake 52.62 373.41 1120.37
		call HuntSnake 61.09 374.99 1113.91
		call HuntSnake 49.18 370.84 1095.24
		call HuntSnake 79.94 373.57 1084.76
	}
}

function HuntSnake(int x, int y, int z)
{
	if ${needSnakes}
	{
		call MovementManager ${x} ${y} ${z} "The Stonebrunt Highlands" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} 1
		if !${tagAlong}
		{
			target Slitherstrike
		}
		wait 40
	}
}

function GetScintillas()
{
	while !${Zone.Name.Equals[The Stonebrunt Highlands]}
	{
		
		relay ${Me.Name} runscript custom/GlobeTrotter "The Stonebrunt Highlands"
		wait 3
		while ${Script[GlobeTrotter](exists)}
		{
			wait 50
		}
		;relay ${Me.Name} MessageBox "Please Take Me To Stonebrunt"
		;echo Bruh, take me to Stonebrunt
		wait 300
	}
	call KillMessageBox
	while ${needScintillas}
	{
		call HuntScintilla 75.88 364.00 927.79
		call HuntScintilla 140.74 364.95 941.05
		call HuntScintilla 213.00 368.32 831.28
		call HuntScintilla 244.83 372.42 835.77
		call HuntScintilla 251.78 361.88 962.08
		call HuntScintilla 217.74 365.99 999.88
		call HuntScintilla 245.52 367.49 1007.66
	}
}

function HuntScintilla(int x, int y, int z)
{
	if ${needScintillas}
	{
		call MovementManager ${x} ${y} ${z} "The Stonebrunt Highlands" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} 1
		if !${tagAlong}
		{
			target Scintilla
		}
		wait 40
	}
}

function GetPondweed()
{
	while !${Zone.Name.Equals[The Stonebrunt Highlands]}
	{
		
		relay ${Me.Name} runscript custom/GlobeTrotter "The Stonebrunt Highlands"
		wait 3
		while ${Script[GlobeTrotter](exists)}
		{
			wait 50
		}
		;relay ${Me.Name} MessageBox "Please Take Me To Stonebrunt"
		;echo Bruh, take me to Stonebrunt
		wait 300
	}
	call KillMessageBox
	;AddTriger questinfo QUESTDATA::@qinfo@
	;move to map
	call MovementManager 84.30 366.03 834.31 "The Stonebrunt Highlands" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	wait 300
	Me.Inventory[Totem of the Otter]:Use
	wait 100
	while ${needPondweed}
	{
		call HarvestPondweed 54.19 344.57 865.16
		call HarvestPondweed 61.17 343.27 898.69
		call HarvestPondweed 77.40 345.64 897.88
		call HarvestPondweed 38.95 346.24 940.35
		call HarvestPondweed 0.61 347.38 895.12
		call HarvestPondweed 26.93 345.23 880.23
		call HarvestPondweed 41.84 343.32 917.76
		call HarvestPondweed 21.69 346.79 959.23
		call HarvestPondweed 0.22 343.39 960.14
		call HarvestPondweed -28.95 354.56 986.13
		call HarvestPondweed -39.48 353.57 975.34
		call HarvestPondweed -29.21 345.88 960.80
		call HarvestPondweed 0.19 343.60 960.65
		call HarvestPondweed 21.64 346.72 959.15
		call HarvestPondweed -29.21 345.72 960.39
		call HarvestPondweed 0.69 347.36 894.44
		call HarvestPondweed 0.16 349.74 884.17
		call HarvestPondweed -36.01 348.86 934.03
		call HarvestPondweed -29.17 345.75 960.49
		call HarvestPondweed 22.21 347.00 959.19
		call HarvestPondweed 0.28 347.46 894.70
		call HarvestPondweed 27.28 345.18 880.20
		wait 300
		Me.Inventory[Totem of the Otter]:Use
		wait 100
	}
	oc !ci -FlyDown ${Me.Name}
	call CampSpotAt ${Me.Name} 38.07 342.01 897.50
	while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},38.07,342.01,897.50]} > 3
	{
		wait 3
	}
	call CampSpotAt ${Me.Name} 77.93 343.93 881.70
	while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},77.93,343.93,881.70]} > 3
	{
		wait 3
	}
	call CampSpotAt ${Me.Name} 109.32 366.05 872.60
	while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},109.32,366.05,872.60]} > 3
	{
		wait 3
	}
	oc !ci -FlyStop ${Me.Name}
}

function HarvestPondweed(int x, int y, int z)
{
	if ${needPondweed}
	{
		;AddTriger questinfo QUESTDATA::@qinfo@
		oc !ci -FlyDown ${Me.Name}
		call CampSpotAt ${Me.Name} ${x} ${y} ${z}
		while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},${x},${y},${z}]} > 3
		{
			wait 5
		}
		variable int iz = 0
		iz:Set[0]
		eq2execute /target_none
		wait 50
		while ${botUtil.MobsAggroMe} > 0 && ${iz:Inc} <= 7
		{
			eq2execute /target_none
			wait 100
		}
		if ${Actor[pondweed,radius,5](exists)} && !${tagAlong}
		{
			target pondweed
			wait 20
			eq2execute "/apply_verb ${Actor[pondweed].ID} Collect"
			wait 60
		}
		eq2execute /target_none
		oc !ci -FlyStop ${Me.Name}
	}
}

function GoToQuelUle()
{
	if ${Zone.Name.Equals["The Sundered Frontier"]}
	{
		wait 50
		while ${Zone.Name.Equals[The Sundered Frontier]}
		{
			call FlyUp
			call MovementManager 366.23 137.08 2516.53 "The Sundered Frontier" ${wGroup} FALSE ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} 1
			relay ${Me.Name} MessageBox "Attempting To Zone To Stonebrunt (may need you to do it for me!)"
			echo Take me to Stonebrunt!
			call FlyToStonebrunt
		}
		call KillMessageBox
	}
	while !${Zone.Name.Equals[The Stonebrunt Highlands]}
	{
		
		relay ${Me.Name} runscript custom/GlobeTrotter "The Stonebrunt Highlands"
		wait 3
		while ${Script[GlobeTrotter](exists)}
		{
			wait 50
		}
		;relay ${Me.Name} MessageBox "Please Take Me To Stonebrunt"
		;echo Bruh, take me to Stonebrunt
		wait 300
	}
	call KillMessageBox
	;Lama In QuelUle
	call MovementManager -437.89 379.70 654.58 "The Stonebrunt Highlands" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	
	call GetPerspective
	target Mukhlisah
	face Mukhlisah
	wait 10
	eq2execute h
	Actor[Mukhlisah]:DoubleClick
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
}

function GetQuest()
{
	while !${Zone.Name.Equals[The Sundered Frontier]}
	{
		
		relay ${Me.Name} runscript custom/GlobeTrotter "The Sundered Frontier"
		wait 3
		while ${Script[GlobeTrotter](exists)}
		{
			wait 50
		}
		;relay ${Me.Name} MessageBox "Please Take Me To Sundered"
		;echo Bruh, take me to Sundered
		wait 300
	}
	call KillMessageBox
	call FlyDown
	call MovementManager 1996.10 -298.99 3339.73 "The Sundered Frontier" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
	
	call GetPerspective
	target Waseem
	face Waseem
	wait 10
	eq2execute h
	Actor[Waseem]:DoubleClick
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
	oc !ci -OptNum 1
	wait 20
}

function questinfo(string Ling, string qinfo)
{
	if ${qinfo.Find[I have an unscathed slitherstrike mamba venom sac](exists)}
	{
		echo Do not need snakes
		needSnakes:Set[FALSE]
	}
	if ${qinfo.Find[I harvested enough Aglthin](exists)}
	{
		echo Do not need pondweed
		needPondweed:Set[FALSE]
	}
	if ${qinfo.Find[I have enough ensorcelled mercury](exists)}
	{
		needMercury:Set[FALSE]
	}
	if ${qinfo.Find[had the Erud Binding Powder!](exists)}
	{
		needPowder:Set[FALSE]
	}
	if ${qinfo.Find[Delahnus the Dauntless presented me with some of her own blood](exists)}
	{
		needBlood:Set[FALSE]
	}
	if ${qinfo.Find[A study in Spell Transference Lacking Degradation](exists)}
	{
		needBook:Set[FALSE]
	}
	if ${qinfo.Find[I presented Lama Mukhlisah with the book](exists)}
	{
		needBook:Set[FALSE]
	}
	if ${qinfo.Find[I have successfully obtained all of the rare and potent items required](exists)}
	{
		needBlood:Set[FALSE]
		needPowder:Set[FALSE]
		needMercury:Set[FALSE]
	}
	if ${qinfo.Find[I have all of the items Lama Mukhlisah required in order to hold the conversation](exists)}
	{
		needSnakes:Set[FALSE]
		needPondweed:Set[FALSE]
		needScintillas:Set[FALSE]
	}
	return
}


function FlyToStonebrunt()
{
	if ${Zone.Name.Equals[The Sundered Frontier]} &&${Math.Distance[${Me.X},${Me.Y},${Me.Z},363.63,137.08,2518.78]} <= 10
	{
		call GetPerspective
		Actor[a Temporal pathfinder]:DoubleClick
		face Temporal
		wait 30
		oc !ci -OptNum 1
		wait 30
		oc !ci -Travel ${Me.Name} "Stonebrunt Highlands"
		;relay ${Me.Name} runscript "${Script.CurrentDirectory}/MapNav" Fly "The Stonebrunt Highlands"
		wait 400
	}
}
;if ${dest.Find[Stonebrunt](exists)}
;	{
;		oc !ci -Travel ${Me.Name} "Stonebrunt Highlands"
;	}
;	elseif ${dest.Find[Sundered](exists)}
;	{
;		oc !ci -Travel ${Me.Name} "Sundered Frontier"
;	}
function FlyToSundered()
{
	if ${Zone.Name.Equals[The Stonebrunt Highlands]} && ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-491.42,370.17,1509.08]} <= 10
	{
		call GetPerspective
		Actor[a Temporal pathfinder]:DoubleClick
		face Temporal
		wait 30
		oc !ci -OptNum 1
		wait 30
		oc !ci -Travel ${Me.Name} "Sundered Frontier"
		;relay ${Me.Name} runscript "${Script.CurrentDirectory}/MapNav" Fly "The Sundered Frontier"
		wait 400
	}
}

function FlyUp()
{
	if ${Math.Distance[${Me.X},${Me.Y},${Me.Z},2218.51,-210.25,2472.46]} < 200
	{
		;Spire Island
		call MovementManager 2061.06 -239.47 2713.02 "The Sundered Frontier" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		oc !ci -Special ${Me.Name}
	}
	elseif ${Me.Y} < -320
	{
		call UpFromTheHoleLobby
	}
	
	if ${Me.Y} < -250
	{
		call MovementManager 1816.83 -299.67 3369.09 "The Sundered Frontier" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		oc !ci -FlyUp ${Me.Name}
		while ${Me.Y} < -67
		{
			wait 10
			oc !ci -FlyUp ${Me.Name}
		}
		oc !ci -FlyStop ${Me.Name}
		face 1818.99 -68.35 3415.35
		wait 5
		oc !ci -AutoRun ${Me.Name}
		while ${Me.Z} < 3430
		{
			wait 1
		}
		oc !ci -AutoRun ${Me.Name}
		oc !ci -FlyDown ${Me.Name}
		wait 70
		oc !ci -FlyStop ${Me.Name}
	}
}

function FlyDown()
{
	if ${Math.Distance[${Me.X},${Me.Y},${Me.Z},2218.51,-210.25,2472.46]} < 200
	{
		while ${Math.Distance[${Me.X},${Me.Y},${Me.Z},2218.51,-210.25,2472.46]} < 200
		{
			;Spire Island
			call MovementManager 2061.06 -239.47 2713.02 "The Sundered Frontier" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
			wait 20
			oc !ci -Special ${Me.Name}
			wait 70
		}
	}
	elseif ${Me.Y} < -320
	{
		call UpFromTheHoleLobby
	}
	elseif ${Me.Y} > -250
	{
		call MovementManager 1819.53 -110.55 3431.26 "The Sundered Frontier" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		call CampSpotAt ${Me.Name} 1816.83 -299.67 3369.09
		wait 100
		face 1818.99 -68.35 3415.35
		wait 5
		oc !ci -AutoRun ${Me.Name}
		while ${Me.Z} < 3382
		{
			wait 1
		}
		oc !ci -AutoRun ${Me.Name}
		oc !ci -FlyDown ${Me.Name}
		while ${Me.Y} > -298
		{
			wait 10
			oc !ci -FlyDown ${Me.Name}
		}
		wait 20
		oc !ci -FlyStop ${Me.Name}
	}
}

function UpFromTheHoleLobby()
{
	while ${Me.Y} < -320
	{
		call MovementManager 1894.14 -374.90 3377.11 "The Sundered Frontier" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		oc !ci -Special ${Me.Name}
		wait 80
	}
}

function DownToTheHoleLobby()
{
	if ${Me.Y} > -320
	{
		call FlyDown
		
		call MovementManager 1892.87 -298.99 3386.76 "The Sundered Frontier" ${wGroup} ${ignoreMobs} ${ignoreDistance} ${ignoreHealth} ${minLevel} ${maxLevel} ${minMobs}
		call CampSpotAt ${Me.Name} 1893.78 -314.80 3345.15
	
		wait 100
		face 1892.73 -298.74 3402.91
		wait 5
	
		oc !ci -FlyDown ${Me.Name}
		while ${Me.Y} > -347
		{
			oc !ci -FlyDown ${Me.Name}
			wait 5
		}
		oc !ci -FlyStop ${Me.Name}
		
		oc !ci -AutoRun ${Me.Name}
		while ${Me.Z} < 3379
		{
			wait 1
		}
		oc !ci -AutoRun ${Me.Name}
		
		call CampSpotAt ${Me.Name} 1894.30 -375.13 3384.00
		oc !ci -FlyDown ${Me.Name}
		while ${Me.Y} > -372
		{
			wait 10
			oc !ci -FlyDown ${Me.Name}
		}
		wait 20
		oc !ci -FlyStop ${Me.Name}
	}
}

function setRelayGroup()
{
	;Auto
	newTagRG:Set[tagalongRG_]
	newMythRG:Set[mythRG_]
	variable index:string names
	variable int i = 0
	while ${i} < ${Me.GroupCount}
	{
		names:Insert[${Me.Group[${i}]}]
		i:Inc[1]
	}
	i:Set[0]
	variable int j = 1
	variable bool sorted = FALSE
	while !${sorted}
	{
		sorted:Set[TRUE]
		i:Set[1]
		j:Set[2]
		while ${j} <= ${Me.GroupCount}
		{
			if ${names[${i}].Compare[${names[${j}]}]} > 0
			{
				sorted:Set[FALSE]
				names:Swap[${i},${j}]
			}
			i:Inc[1]
			j:Inc[1]
		}
	}
	i:Set[1]
	while ${i} <= ${Me.GroupCount}
	{
		;call VikingIRCMessage "(${i}) ${names[${i}]}" FALSE
		newTagRG:Set[${newTagRG}${names[${i}]}]
		newMythRG:Set[${newMythRG}${names[${i}]}]
		i:Inc[1]
	}
	;call VikingIRCMessage "ORG: ${relayGroup}" FALSE
	echo ORG: ${newTagRG}
}

function updateRG()
{
	call setRelayGroup
	if ${tagAlong}
	{
		uplink relaygroup -leave ${tagRG}
		uplink relaygroup -join ${newTagRG}
		echo uplink relaygroup -leave ${tagRG}
		echo uplink relaygroup -join ${newTagRG}
	}
	
	uplink relaygroup -leave ${mythRG}
	uplink relaygroup -join ${newMythRG}
	echo uplink relaygroup -leave ${mythRG}
	echo uplink relaygroup -join ${newMythRG}
	mythRG:Set[${newMythRG}]
	tagRG:Set[${newTagRG}]
}

atom EQ2_onIncomingText(string Text)
{
	;echo EQ2_onIncomingText - ${Text}
	
	if ${Text.Find[ joined the group](exists)} || ${Text.Find[ left the group](exists)} || ${Text.Find[The group has disbanded](exists)} || ${Text.Find[You form a group with](exists)}
	{
		call updateRG
	}
	if ${Text.Find[ joined the raid](exists)} || ${Text.Find[ left the raid](exists)}
	{
		call updateRG
	}
}

atom AtExit()
{
	echo *************************
	echo *********ER in AtExit
	echo *************************
	uplink relaygroup -leave ${tagRG}
	relay ${Me.Name} endscript QuestStatusHelper
	relay ${Me.Name} endscript VikingMove_Modified
}