;================================================================================
; Title: Venril | Author: The Marty Party | Date: 23 Jan 2024 | Version: 1.3
;================================================================================

;//Obj_OgreMCP:PasteButton[RunScriptRequiresOgreBot,VS,Auto,Venril]

/*
    This script must be run while in combat with Venril. It will not work if done before. It will need to be run every encounter i.e. will not persist if you wipe and have to pull it again.
*/

;// Need this include, it handles a lot of the variable creation.
#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"

function main()
{
    echo ${Time}: Venril Script Started...
    while ${Me.InCombat}
        {
        if ${OgreBotAPI.DetrimentalInfo[487, 314, ${Me.ID}, "exists"]}
        {
            relay all echo ${Time}: >> ${Me.Name} << STOP CASTING
            eq2execute cancel_spellcast
            eq2execute cl
            
            ;Dirge Maintained
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Clara's Chaotic Cacophony"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Zander's Choral Rebuff"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Daro's Sorrowful Dirge"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Disheartening Descant"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Gravitas"]
            ;Troub Maintianed
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Demoralizing Processional"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Zander's Choral Rebuff"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Disheartening Descant"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Sonic Interference"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Chaos Anthem"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Jester's Cap"]
            ;Conj Maintained
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Winds of Velious"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Elemental Unity"]
            ;Wizard Maintained
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Storming Tempest"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Manashield"]
            ;Warlock Maintained
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Netherealm"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Manashield"]
            ;Illy Maintained
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Spellshield"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Savante"]
            ;Coercer Maintained
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Destructive Mind"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Manaward"]
            ;Defiler Maintained
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Spiritual Circle"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Maelstrom"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Hexation"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Defile"]
            ;Mystic Maintained
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Ancestral Sentry"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Bolster"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Torpor"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Oberon"]
            ;Inq Maintained
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Inquisition"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Exorcise"]
            ;Templar Maintained
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Focused Intervention"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Exorcise"]
            ;Fury Maintained
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Porcupine"]
            ;Warden Maintained
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Hierophantic Genesis"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Healing Grove"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Tranquility"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Sandstorm"]
            ;Paladin Maintained
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Consecrate"]

            OgreBotAPI:Pause["all"]
            eq2execute cl
            eq2execute cancel_spellcast
            wait 220
            OgreBotAPI:Resume["all"]
            relay all echo ${Time}: >> ${Me.Name} << RESUME CASTING
        }
    }
}

function atexit()
{
	echo ${Time}: Venril Script Ended...
}
