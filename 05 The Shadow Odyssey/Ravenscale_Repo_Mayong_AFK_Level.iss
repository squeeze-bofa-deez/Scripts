;; In the announce tab in Ogre, add a command for /target_nearest_npc and another for /hail on one of your fast reuse temp buffs. 
;; This will make you hail Mayong Mistmoore and spawn two mobs if you are on the quest "Grand Theft Artifact"

#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"

function main(int _StartingPoint=0)
{
	call function_Handle_Startup_Process "-NoAutoLoadMapOnZone"
}

atom atexit()
{
	echo ${Time}: ${Script.Filename} done
}

objectdef Object_Instance
{
	function:bool RunInstance(int _StartingPoint=0)
	{
        if ${_StartingPoint} == 0
		{
			call This.Named1 "a repository guardian"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#1: a repository guardian"]
				return FALSE
			}
			_StartingPoint:Inc
		}

        return TRUE
    }
    function:bool Named1(string _NamedNPC="Doesnotexist")
	{
		Obj_OgreIH:SetCampSpot
		OgreBotAPI:Special[igw:${Me.Name}]
		wait 20
		call Obj_OgreUtilities.PreCombatBuff 5
		wait 100
		call Obj_OgreUtilities.HandleWaitForCombat

		if !${Actor[exactname,"${_NamedNpc}"].ID(exists)}
		{
			Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNpc}"]
			return TRUE
		}
		
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		call Obj_OgreUtilities.PreCombatBuff 5
		wait 100
		call Obj_OgreUtilities.HandleWaitForCombat

		if !${Actor[exactname,"${_NamedNpc}"].ID(exists)}
		{
			Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNpc}"]
			return TRUE
		}
		
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		call Obj_OgreUtilities.PreCombatBuff 5
		wait 100
		call Obj_OgreUtilities.HandleWaitForCombat

		if !${Actor[exactname,"${_NamedNpc}"].ID(exists)}
		{
			Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNpc}"]
			return TRUE
		}
		
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		call Obj_OgreUtilities.PreCombatBuff 5
		wait 100
		call Obj_OgreUtilities.HandleWaitForCombat

		if !${Actor[exactname,"${_NamedNpc}"].ID(exists)}
		{
			Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNpc}"]
			return TRUE
		}
		
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		call Obj_OgreUtilities.PreCombatBuff 5
		wait 100
		call Obj_OgreUtilities.HandleWaitForCombat

		if !${Actor[exactname,"${_NamedNpc}"].ID(exists)}
		{
			Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNpc}"]
			return TRUE
		}
		
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

        return TRUE
    }
}