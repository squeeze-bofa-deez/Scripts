;Obj_OgreMCP:PasteButton[OgreConsoleCommand,EnterHouse,-RunScriptOB_AP,auto,EnterHouse,"OWNER_NAME"]

function main(string housingQuery)
{    
    eq2execute /house
    wait 30
    EQ2UIPage[PlayerHousing,OmniHouse].Child[Page,OmniHouse].Child[3].Child[3]:LeftClick
    wait 30
    EQ2UIPage[PlayerHousing,OmniHouse].Child[Page,OmniHouse].Child[4].Child[5].Child[7]:SetProperty[Text, "${housingQuery}"]
    wait 30
    EQ2UIPage[PlayerHousing,OmniHouse].Child[Page,OmniHouse].Child[4].Child[5].Child[3]:LeftClick
    wait 30
    EQ2UIPage[PlayerHousing,OmniHouse].Child[Page,OmniHouse].Child[4].Child[5].Child[8]:LeftClick
    wait 30
    EQ2UIPage[PlayerHousing,OmniHouse].Child[Page,OmniHouse].Child[4].Child[1].Child[10]:LeftClick
}