
/* In guild hall, place a "Portal to Housing" in the middle of a room and position your hirelings within clicking distance.  
Stand on the portal and runscriptrelay. */

function main()
{
	;Collect from Packpony
	oc !c -campspot all
	oc !c -CS_Set_Formation_Circle all 0 ${Me.X} ${Me.Y} ${Me.Z}
	wait 50
	OgreBotAPI:CastAbility["${Me}","Summon Artisan's Pack Pony"]
	wait 30
	Actor[Packpony]:DoubleClick
	wait 10
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
	wait 10
	Actor[Packpony]:DoubleClick
	wait 10
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,3]:LeftClick
	wait 10
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
	wait 10
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,3]:LeftClick
	wait 10
	OgreBotAPI:CancelMaintained["Summon Artisan's Pack Pony"]

	;Collect from hirelings
	Actor[Gatherer Hireling]:DoubleClick
	wait 10
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
	wait 10
	Actor[Gatherer Hireling]:DoubleClick
	wait 10
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
	wait 10
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,3]:LeftClick
	wait 10
	Actor[Hunter Hireling]:DoubleClick
	wait 10
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
	wait 10
	Actor[Hunter Hireling]:DoubleClick
	wait 10
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
	wait 10
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,3]:LeftClick
	wait 10
	Actor[Miner Hireling]:DoubleClick
	wait 10
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
	wait 10
	Actor[Miner Hireling]:DoubleClick
	wait 10
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
	wait 10
	EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,3]:LeftClick
while 1>0
runscript Plant2.iss
wait 916010
}
