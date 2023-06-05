; MCP Button     Obj_OgreMCP:PasteButton[RunScript,IC AutoStart,IC_AutoStart,FALSE,TRUE]


function main(bool PatchFile, bool AutoStart)
{
        relay ogre_everquest2 ogre end qh
        wait 5
        ogre IC


        Ogre_Instance_Controller:Set_BaseDirectory["${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Instance_Files"]
        Ogre_Instance_Controller:Set_CurrentDirectory["EoF"]

        wait 30
        
 ;      UI Checkboxes               
        Ogre_Instance_Controller:ChangeUIOptionViaCode["ogreim_checkbox", FALSE]
        Ogre_Instance_Controller:ChangeUIOptionViaCode["low_gear_mode_checkbox", FALSE]
        Ogre_Instance_Controller:ChangeUIOptionViaCode["pause_at_end_of_zone_checkbox", TRUE]
        Ogre_Instance_Controller:ChangeUIOptionViaCode["stay_in_instance_until_any_zone_available_checkbox", FALSE]
        Ogre_Instance_Controller:ChangeUIOptionViaCode["call_to_gh_after_each_zone_checkbox", FALSE]
        Ogre_Instance_Controller:ChangeUIOptionViaCode["loop_list_checkbox", FALSE]
        Ogre_Instance_Controller:ChangeUIOptionViaCode["skip_shinies_checkbox", FALSE]
        Ogre_Instance_Controller:ChangeUIOptionViaCode["pause_notradeshinies_checkbox", FALSE]
        Ogre_Instance_Controller:ChangeUIOptionViaCode["call_to_gh_when_finished", FALSE]
        Ogre_Instance_Controller:ChangeUIOptionViaCode["camp_when_finished", FALSE]

;       HO Settings
;        oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_ho_start FALSE TRUE
;        oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_ho_starter TRUE TRUE
;    	 oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_ho_wheel TRUE TRUE

;       Preferred Ogre settings for reliability
;        oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_crowdcontrol FALSE
;        oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_packpony_enable FALSE
;	 oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_facenpc TRUE
;        oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_autotarget_outofcombatscanning FALSE
        oc !ci -OgreFollow igw:${Me.Name} ${Me.Name} 1
        oc !ci -Resume igw:${Me.Name}
        wait 10
;        relay all eq2execute merc ranged
;	relay all eq2execute merc backoff
	relay all eq2execute pet autoassist

;       Hardmode settings
;        oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_ho_start FALSE TRUE
;       oc !ci -ChangeOgreBotUIOption igw:${Me.Name}+shaman checkbox_settings_disablecaststack_ca TRUE
;       oc !ci -ChangeOgreBotUIOption igw:${Me.Name}+notscout checkbox_settings_disablecaststack_items TRUE

;       Auto start current zone
        if ${PatchFile}
        {
           Ogre_Instance_Controller:Set_BaseDirectory["${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Instance_Files"]
           Ogre_Instance_Controller:Set_CurrentDirectory["Default"]
           Ogre_Instance_Controller:AddInstance_ViaCode_ViaName["${Ogre_Instance_Controller.CleanZoneName}.iss"]
        }
        if ${AutoStart}
        {
        Ogre_Instance_Controller:Clear_ZonesToRun
        Ogre_Instance_Controller:AddInstance_ViaCode_ViaName["${Ogre_Instance_Controller.CleanZoneName}.iss"]
        Ogre_Instance_Controller:ChangeUIOptionViaCode["run_instances_checkbox", TRUE]
        }
}
	
atom atexit()
{
	oc ${Me.Name}: IC ready.
}	