;================================================================================
; Title: BeamHandler | Author: The Marty Party | Date: 16 Mar 2024 | Version: 1.0
;================================================================================

/*
    This script is intended to be ran as a runscript via the chat event tab.

    > Add this command to your IC to enable chat events.
        oc !ci -ChangeOgreBotUIOption ${Me.Name} checkbox_settings_enable_chatevents TRUE TRUE TRUE
    > Add this command to your IC file after the mob dies to disable chat events.
        oc !ci -ChangeOgreBotUIOption ${Me.Name} checkbox_settings_enable_chatevents FALSE FALSE FALSE

    > Add this command to your IC file to automatically add the chat event.
        OgreBotAPI:ChatEvent_AddEntry["${Me.Name}", "No! While my power still holds, I WILL NOT FALL!", "TRUE", "FALSE", "runscript BeamHandler"]
    > Add this command to your IC file after the mob dies to remove the chat event.
        OgreBotAPI:ChatEvent_RemoveEntry["${Me.Name}", "No! While my power still holds, I WILL NOT FALL!"]
*/

#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"

function main()
{
    echo ${Time}: \agBeamHandler Script Started
    if ${Target.Name.Equal[Beam Handler Val'Kinad]}
	{
		oc !c -Pause igw:${Me.Name}
		eq2execute apply_verb ${Actor[Query,Type="NoKill NPC"&& Name=""].ID} Unplug the contraption
		wait 30
		oc !c -Resume igw:${Me.Name}
		wait 1
		oc !c -ChangeCampSpotWho igw:${Me.Name} -106.540329 -15.496661 -100.470993
	}
    if ${Target.Name.Equal[Beam Handler Pin'Tannil]}
	{
		oc !c -Pause igw:${Me.Name}
		eq2execute apply_verb ${Actor[Query,Type="NoKill NPC"&& Name=""].ID} Unplug the contraption
		wait 30
		oc !c -Resume igw:${Me.Name}
		wait 1
		oc !c -ChangeCampSpotWho igw:${Me.Name} -107.845657 -15.496661 -210.313538
	}
	if ${Target.Name.Equal[Beam Handler Ran]}
	{
		oc !c -Pause igw:${Me.Name}
		eq2execute apply_verb ${Actor[Query,Type="NoKill NPC"&& Name=""].ID} Unplug the contraption
		wait 30
		oc !c -Resume igw:${Me.Name}
		wait 1
		oc !c -ChangeCampSpotWho igw:${Me.Name} 106.416344 -15.496660 -209.027817
	}
	if ${Target.Name.Equal[Beam Handler Polla]}
	{
		oc !c -Pause igw:${Me.Name}
		eq2execute apply_verb ${Actor[Query,Type="NoKill NPC"&& Name=""].ID} Unplug the contraption
		wait 30
		oc !c -Resume igw:${Me.Name}
		wait 1
		oc !c -ChangeCampSpotWho igw:${Me.Name} 108.440765 -15.496660 -101.307388
	}
    end BeamHandler
}

function atexit()
{
	echo ${Time}: \arBeamHandler Script Ended
}
