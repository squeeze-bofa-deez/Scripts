;================================================================================
; Title: Leave House | Author: The Marty Party | Date: 22 Jan 2024 | Version: 2.0
;================================================================================

/*
    Leaves player housing: 
    Obj_OgreMCP:PasteButton[OgreConsoleCommand,LeaveHouse,-RunScriptOB_AP,auto,LeaveHouse]
*/

function main()
{    
    eq2execute /house
    wait 40
    EQ2UIPage[PlayerHousing,PlayerHouse].Child[Page,PlayerHouse].Child[4].Child[2]:LeftClick
    wait 40
    EQ2UIPage[PlayerHousing,OmniHouse].Child[Page,OmniHouse].Child[4].Child[4].Child[2]:LeftClick
}