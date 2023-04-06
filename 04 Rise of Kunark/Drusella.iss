;// Need this include, it handles a lot of the variable creation.
#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"


function main()
{
    OgreBotAPI:Target["${Me.Name}","${Me.Name}"]
    OgreBotAPI:CancelMaintainedForWho["all", "Ball Lightning", "Ring of Fire", "Undead Horde"]
    OgreBotAPI:CancelMaintainedForWho["all", "Band of Thugs",  "Blighted Horde", "Awaken Grave"]
    OgreBotAPI:CancelMaintainedForWho["all", "Puppetmaster", "Furnace of Ro", "Protoflame"]
    oc !c -Pet_Off igw:${Me.Name}
    wait 10
	OgreBotAPI:Pause["all"]
    wait 150
    OgreBotAPI:Resume["all"]
    wait 10
    OgreBotAPI:Target["${Me.Name}","Drusella Sathir"]
    oc !c -Pet_Attack igw:${Me.Name}
}