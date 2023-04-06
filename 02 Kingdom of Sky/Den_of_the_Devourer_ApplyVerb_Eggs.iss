#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"

function main(int iSequence=1, string sToonName="${Me.Name}", string sNamedNPC="Queen's Guard", string sInteractableName="an egg", string sVerbAction="kick egg")
{
    variable point3f p3fInteractableLocation
    variable point3f p3fCenterPoint
    variable int iMaxRange=25
    variable string _NamedNPC="The Devourer"
    call function_Load_Ogre_Objects
    if ${iSequence} == 1
        p3fCenterPoint:Set[-292.592529,-14.385402,212.054153]
    Obj_OgreIH:SetCampSpot 2
    oc !ci -CampSpot all
    oc !ci -ChangeCampSpotWho ${sToonName} ${p3fCenterPoint.X} ${p3fCenterPoint.Y} ${p3fCenterPoint.Z}
    do
    {
        wait 5
        if ${Actor[exactname, "${sInteractableName}"](exists)}
        {
            if ${Math.Distance[${p3fCenterPoint},${Actor[exactname, "${sInteractableName}"].Loc}]} < ${iMaxRange}
            {
                p3fInteractableLocation:Set[${Actor[exactname, "${sInteractableName}"].Loc}]
                oc "[DEBUG-${sToonName}] -  running to nearest ${sInteractableName} which is ${Math.Distance[${p3fCenterPoint},${p3fInteractableLocation}]} meters from the center point."
                oc !ci -ChangeCampSpotWho ${sToonName} ${p3fInteractableLocation.X} ${p3fInteractableLocation.Y} ${p3fInteractableLocation.Z}
                call Obj_OgreUtilities.HandleWaitForCampSpot 10
                oc "[DEBUG-${Me.Name}] - applying verb: ${sVerbAction}"
                OgreBotAPI:ApplyVerbForWho["${sToonName}","${sInteractableName}", "${sVerbAction}"]
                wait 10
                oc !ci -ChangeCampSpotWho ${Me.Name} ${p3fCenterPoint.X} ${p3fCenterPoint.Y} ${p3fCenterPoint.Z}
                call Obj_OgreUtilities.HandleWaitForCampSpot 10
            }
            else
                oc "[DEBUG-${Me.Name}] - ${sInteractableName} is OUTSIDE the max Distance of ${iMaxRange}; ignoring object"
        }
    }
    while (${Actor[exactname, "${sNamedNPC}"].Health} > 0 || ${Actor[exactname, "${_NamedNPC}"].Health} > 0)
    oc "Script completed"
}