;// Need this include, it handles a lot of the variable creation.
#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"


function main()
{
    while ${Me.InCombat}
        {
        if ${OgreBotAPI.DetrimentalInfo[487, 314, ${Me.ID}, "exists"]}
        {
            echo eppppp STHAP CASTING
            eq2execute cancel_spellcast
            ;Dirge Maintained
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Daro's Sorrowful Dirge"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Clara's Chaotic Cacophony"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Zander's Choral Rebuff"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Disheartening Descant"]
            ;Troub Maintianed
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Disheartening Descant"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Chaos Anthem"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Zander's Choral Rebuff"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Demoralizing Processional"]
            ;conj Maintained
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Elemental Unity"]
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Winds of Velious"]
            ;Fury Maintained
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Porcupine"]
            ;Wizard Maintained
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Storming Tempest"]
            ;Illy Maintained
            OgreBotAPI:CancelMaintainedForWho["${Me.Name}", "Savante"]
            ;Warlock Maintainted            
            

            OgreBotAPI:Pause["all"]
            eq2execute cancel_spellcast
            wait 220
            OgreBotAPI:Resume["all"]
            echo YAY start CASTING
        }
    }
}