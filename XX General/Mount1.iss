;// Need this include, it handles a lot of the variable creation.
#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"

function main()
{
    eq2execute /inventory equipmount -8 1 0
    eq2execute /inventory equipmount -8 1 1
    eq2execute /summon_mount
}