
/* Change the location co-ordinates to those of your harvesters and strategist in Lines 24 and 129  */

/*
MCP Button

Obj_OgreMCP:PasteButton[RelayRunScript,GH Dailies,All,GH_Daily]

*/


variable bool Still_Zoning=FALSE

function main()
{
	Event[EQ2_FinishedZoning]:AttachAtom[Zoning]
	
	oc !ci -resume ${Me.Name}
	OgreBotAPI:LetsGo
	oc !ci -ChangeOgreBotUIOption ${Me.Name} checkbox_settings_movetoarea TRUE TRUE
	oc !ci -campspot ${Me.Name}

; Move to  guild harvesters
	oc !ci -ChangeCampSpotWho ${Me.Name} 638.411987 -35.297489 1582.074829
	wait 60
	OgreBotAPI:ResetCameraAngle["${Me.Name}"]
	wait 30

;Collect from Packpony
	OgreBotAPI:CastAbility["${Me.Name}","Summon Artisan's Pack Pony"]
	wait 30
	Actor[Packpony]:DoubleClick
	wait 10
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
	wait 10
	Actor[Query, Name == "Packpony" && Guild == "${Me.Name}'s pack pony"]:DoubleClick
	wait 10
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,3]:LeftClick
	wait 10
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
	wait 10
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,3]:LeftClick
	wait 10
	OgreBotAPI:CancelMaintained["Summon Artisan's Pack Pony"]
	wait 5
	
;Collect from hirelings
	Actor[Guild Hall Gatherer Hireling]:DoubleClick
	wait 5
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
	wait 5
	Actor[Guild Hall Gatherer Hireling]:DoubleClick
	wait 5
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,3]:LeftClick
	wait 5
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,3]:LeftClick
	wait 5
	Actor[Guild Hall Hunter Hireling]:DoubleClick
	wait 5
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
	wait 5
	Actor[Guild Hall Hunter Hireling]:DoubleClick
	wait 5
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,3]:LeftClick
	wait 5
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,3]:LeftClick
	wait 5
	Actor[Guild Hall Miner Hireling]:DoubleClick
	wait 5
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
	wait 5
	Actor[Guild Hall Miner Hireling]:DoubleClick
	wait 5
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,3]:LeftClick
	wait 5
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,3]:LeftClick
	wait 5
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
	wait 20

;Collect from house garden
/*
	call house_garden
*/
	
;Repair all gear
	oc !ci -RepairGear
	wait 50

; Run Overseer and get rid of the crap

	oc !ci -Overseer_CheckQuests ${Me.Name}
	wait 20
    while ${EQ2UIPage[_HUD,minions].Child[page,_HUD.minions].GetProperty[Visible]}
    {
        waitframe
	}
	oc !ci -Unpack_Quantity ${Me.Name} "Singing Steel Heritage Crate"
	wait 20
	oc !ci -Unpack_Quantity ${Me.Name} "Blood Ember Heritage Crate"
	wait 20
	oc !ci -Unpack_Quantity ${Me.Name} "Tolan's Darkwood Heritage Crate"
	wait 20
    oc !ci -Unpack_Consume_Familiars ${Me.Name}
	wait 20
    oc !ci -Overseer_AddAgentsToCollection ${Me.Name}
	wait 20
	oc !ci -Overseer_AutoAddOverseerQuests ${Me.Name}
	wait 20
	while ${Me.Inventory["Ingot"](exists)}
    {
        Me.Inventory["Ingot"]:Examine
        wait 5
        oc !ci -select_zone_version ${Me.Name}
	}
	wait 5


;Run Ogre Inventory Manager
	ogre IM -depot -sell -destroy -tse -quiver -restock -end
    wait 20 
	while ${Script[Buffer:OgreInventoryManager](exists)}
	{
    	waitframe
	}
	wait 5

;Move to strategist and get a flag
	oc !ci -ChangeCampSpotWho ${Me.Name} 668.651489 -35.897495 1487.825439
	while ${Actor[exactname,"Strategist"].Distance} > 5
	{
		waitframe
	}
    face "Strategist"
    wait 1
	Actor[Strategist]:DoubleClick
	wait 5
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,3]:LeftClick
	wait 5
}

;***************************************************************************************************

atom Zoning(string TimeInSeconds)
{
    Still_Zoning:Set[FALSE]
}

atom atexit()
{
	oc !ci -ChangeOgreBotUIOption ${Me.Name}+fighter checkbox_settings_movetoarea FALSE TRUE
    oc ${Me.Name}: Ending inventory script.
	OgreBotAPI:LetsGo
}
function house_garden()
{
;Collect from garden
	OgreBotAPI:LetsGo
	oc !ci -ChangeOgreBotUIOption ${Me.Name} checkbox_settings_movetoarea TRUE TRUE
	oc !ci -campspot ${Me.Name}
	oc !ci -ChangeCampSpotWho ${Me.Name} 668.737427 -35.897495 1487.287964
	wait 50
	Actor[Portal to Housing]:DoubleClick
	wait 5
	EQ2UIPage[PlayerHousing,OmniHouse].Child[button,EnterButton]:LeftClick
	wait 5
	Still_Zoning:Set[TRUE]
	while ${Still_Zoning}
	{
		do
		{
			waitframe
		}
		while ${Still_Zoning}
	}
	wait 20
	Actor[An Obulus Frontier Garden]:DoubleClick
	wait 10
	OgreBotAPI:Unpack["${Me.Name}","A bushel of harvests.","A bushel of harvests: Luclin"]
	wait 20
	Actor[Magic Door to the Guild Hall]:DoubleClick
	wait 20
	Still_Zoning:Set[TRUE]
	while ${Still_Zoning}
	{
		do
		{
			waitframe
		}
		while ${Still_Zoning}
	}
	wait 20
	
	wait 5
	oc !ci -campspot ${Me.Name}
}