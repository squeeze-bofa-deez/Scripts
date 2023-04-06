#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"

function main(string sToonName="doesnotexist")
{
    variable index:actor stewardActors
    variable iterator stActorIterator
    variable int iStewardCount
    call function_Load_Ogre_Objects
    oc !ci -ChangeOgreBotUIOption auto crowd_control TRUE
    oc "Movement enabled for ${sToonName}"
    oc !c -CampSpot all
    while 1
    {
        oc !ci -PetOff
        ; South Location
        oc !ci -ChangeCampSpotWho ${sToonName} 166.346680 -19.531328 17.620016
        call Obj_OgreUtilities.HandleWaitForCampSpot 10
        ; East Location
        oc !ci -ChangeCampSpotWho ${sToonName} 149.270081 -22.365698 -3.579871
        call Obj_OgreUtilities.HandleWaitForCampSpot 10
        ; North Location
        oc !ci -ChangeCampSpotWho ${sToonName} 165.904510 -21.518728 -21.935558
        call Obj_OgreUtilities.HandleWaitForCampSpot 10
        ; West Location
        oc !ci -ChangeCampSpotWho ${sToonName} 181.699112 -21.997570 -5.553888
        call Obj_OgreUtilities.HandleWaitForCampSpot 10
        ; South Location
        oc !ci -ChangeCampSpotWho ${sToonName} 166.346680 -19.531328 17.620016
        call Obj_OgreUtilities.HandleWaitForCampSpot 10
        EQ2:QueryActors[stewardActors, Type  =- "NPC" && Distance <= 25]  
    	stewardActors:GetIterator[stActorIterator]
        iStewardCount:Set[0]
        if ${stActorIterator:First(exists)}
	    {
            do
            {
                If ${Actor[Query, Name == "a Steward of the Seal"]}
                    iStewardCount:Inc
            }
            while ${stActorIterator:Next(exists)}
        }
        if ${iStewardCount == 4}
        {
            oc !ci -ChangeCampSpotWho ${sToonName} 165.630417 -19.662066 29.942497
            break
        }
        wait 100
    }
    oc "a Steward of the Seal - 4 Stewards detected, exising"
}

atom atexit()
{
    oc !ci -PetAttack
    oc !ci -ChangeOgreBotUIOption auto crowd_control FALSE
}