;================================================================================
; Title: Drusella | Author: The Marty Party | Date: 18 Jan 2024 | Version: 2.2
;================================================================================

/*
    This script is intended to be ran as a runscript via the chat event tab. Requires Sathirian language.

    > Add this command to your IC to enable chat events.
        oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_enable_chatevents TRUE TRUE TRUE
    > Add this command to your IC file after the mob dies to disable chat events.
        oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_enable_chatevents FALSE FALSE FALSE

    > Add this command to your IC file to automatically add the chat event.
        OgreBotAPI:ChatEvent_AddEntry["igw:${Me.Name}", "begins to shield herself in a necromantic aura.", "TRUE", "TRUE", "runscript Drusella"]
    > Add this command to your IC file after the mob dies to remove the chat event.
        OgreBotAPI:ChatEvent_RemoveEntry["igw:${Me.Name}", "begins to shield herself in a necromantic aura."]
*/

#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"

function main()
{
    OgreBotAPI:Target["${Me.Name}","${Me.Name}"]
    ;Cancel Spells
    oc !c -CancelMaintainedForWho All "Band of Thugs" "Blighted Horde" "Awaken Grave"
    oc !c -CancelMaintainedForWho All "Ball Lightning" "Ring of Fire" "Undead Horde"
    oc !c -CancelMaintainedForWho All "Puppetmaster" "Dark Infestation" "Vampirism"
    oc !c -CancelMaintainedForWho All "Unswerving Hammer" "Dark Broodlings"
    ;Cancel Items
    oc !c -CancelMaintainedForWho All "Aquatic Aggression" "Clockwork Cow Catapult" "Tinkered Turkey Launcher"
    oc !c -CancelMaintainedForWho All "Summon Bone Devil" "Summon Self-Help Book" "Power of Knowledge"    
    oc !c -CancelMaintainedForWho All "Cebus Albifrons" "Furnace of Ro" "Protoflame"

    oc !c -Pet_Off igw:${Me.Name}
    wait 10
	OgreBotAPI:Pause["all"]
    wait 140
    OgreBotAPI:Resume["all"]
    wait 10
    OgreBotAPI:Target["${Me.Name}","Drusella Sathir"]
    oc !c -Pet_Attack igw:${Me.Name}

    end Drusella.iss
}
