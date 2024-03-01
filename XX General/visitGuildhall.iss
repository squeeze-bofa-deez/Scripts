
variable bool Still_Zoning=FALSE
variable string ScriptName="Goto Guildhall"

; Obj_OgreMCP:PasteButton[OgreConsoleCommand,vGH-Me,-RunScriptOB_AP,\${Me.Name},visitGuildhall,Guild Name,CITY]
; Obj_OgreMCP:PasteButton[OgreConsoleCommand,vGH-Grp,-RunScriptOB_AP,\igw:${Me.Name},visitGuildhall,Guild Name,CITY]

function main(string guildName="", string cityZone="")
{
	Event[EQ2_FinishedZoning]:AttachAtom[Zoning]
 
	if (${Zone.Name.Equal[${guildName}'s Guild Hall]})
	{
		oc ${Me.Name} is already in ${guildName}'s Guild Hall
		return
	}
	
	if (${Me.Guild.Equal[${guildName}]})
	{
		;oc I am a member of ${guildName}
		oc !ci -GetToGH ${Me.Name}
		wait 40
		Still_Zoning:Set[TRUE]
		while ${Still_Zoning}
		{
			waitframe
		}
		wait 60

		return
	}
 
    oc ${Me.Name} heading to ${guildName}'s Guild Hall in ${cityZone}
	oc !ci -resume ${Me.Name}
	oc !ci -letsgo ${Me.Name}
	wait 10
		
	if (${cityZone.Equal[CITY]})
	{
		oc You need to edit the MCP button and change CITY to qeynos or freeport
		return
	}
	elseif (${cityZone.Equal[qeynos]} || ${cityZone.Equal[Qeynos]})
	{
		;oc I should fastravel to Antonica docks to visit Qeynos guilds
		oc !ci -FastTravel ${Me.Name} "Antonica" -mto docks
	}
	elseif (${cityZone.Equal[freeport]} || ${cityZone.Equal[Freeport]})
	{
		;oc I should fastravel to Commonlands docks to visit Freeport guilds
		oc !ci -FastTravel ${Me.Name} "Commonlands" -mto dock
	}

	Still_Zoning:Set[TRUE]
	while ${Still_Zoning}
	{
		waitframe
	}
	wait 40

	if (${Zone.Name.Equal[Antonica]})
	{
		oc !c -ChangeOgreBotUIOption ${Me.Name} checkbox_settings_movetoarea TRUE TRUE
		oc !c -campspot ${Me.Name}
		oc !c -ChangeCampSpotWho ${Me.Name} 439.082642 -37.459282 820.943054
		wait 20
	}
  
	;oc !c -ApplyVerb zone_to_guildhall_tier3 Visit
    eq2ex house
	wait 20
	EQ2UIPage[PlayerHousing,OmniHouse].Child[Page,OmniHouse].Child[3].Child[4]:LeftClick
    wait 10
	EQ2UIPage[PlayerHousing,OmniHouse].Child[Page,OmniHouse].Child[4].Child[4].Child[7]:SetProperty[Text, ""]
    wait 10
	EQ2UIPage[PlayerHousing,OmniHouse].Child[Page,OmniHouse].Child[4].Child[4].Child[3]:LeftClick
    wait 10
	EQ2UIPage[PlayerHousing,OmniHouse].Child[Page,OmniHouse].Child[4].Child[4].Child[7]:SetProperty[Text, "${guildName}"]
    wait 20
	EQ2UIPage[PlayerHousing,OmniHouse].Child[Page,OmniHouse].Child[4].Child[4].Child[3]:LeftClick
    wait 10
	EQ2UIPage[PlayerHousing,OmniHouse].Child[Page,OmniHouse].Child[4].Child[4].Child[8]:LeftClick
    wait 10
	EQ2UIPage[PlayerHousing,OmniHouse].Child[Page,OmniHouse].Child[4].Child[1].Child[10]:LeftClick

	Still_Zoning:Set[TRUE]
	while ${Still_Zoning}
	{
		waitframe
	}
	wait 40
}


atom Zoning(string TimeInSeconds)
{
	Still_Zoning:Set[FALSE]
}


atom atexit()
{

	oc !ci -ChangeOgreBotUIOption ${Me.Name}+fighter checkbox_settings_movetoarea FALSE TRUE
    oc ${Me.Name}: Script '${ScriptName}' ended ${Time}

}