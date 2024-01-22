;================================================================================
; Title: Enter House | Author: The Marty Party | Date: 22 Jan 2024 | Version: 2.0
;================================================================================

/*
    Visits a players house: 
    Obj_OgreMCP:PasteButton[OgreConsoleCommand,EnterHouse,-RunScriptOB_AP,auto,EnterHouse,\"HouseOwnerName\"]
*/

function main(string housingQuery)
{    
    eq2execute /house
    wait 30
    EQ2UIPage[PlayerHousing,OmniHouse].Child[Page,OmniHouse].Child[3].Child[3]:LeftClick
    wait 30
    EQ2UIPage[PlayerHousing,OmniHouse].Child[Page,OmniHouse].Child[4].Child[4].Child[7]:SetProperty[LocalText, "${housingQuery}"]
    wait 30
    EQ2UIPage[PlayerHousing,OmniHouse].Child[Page,OmniHouse].Child[4].Child[4].Child[3]:LeftClick
    wait 30
    EQ2UIPage[PlayerHousing,OmniHouse].Child[Page,OmniHouse].Child[4].Child[4].Child[8]:LeftClick
    wait 30
    EQ2UIPage[PlayerHousing,OmniHouse].Child[Page,OmniHouse].Child[4].Child[1].Child[10]:LeftClick
}