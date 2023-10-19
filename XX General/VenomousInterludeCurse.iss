;// Need this include, it handles a lot of the variable creation.
;ID: 859992   Name: Venonmous Interlude   BackDropIconID: 1097    MainIconID: 172   Duration: 4294966   MaxDuration: 20   CurrentIncrements: 0

function CurseCure()
{
    variable int GroupCounter
    GroupCounter:Set[0]
    while ${Me.Group[${GroupCounter}](exists)}
    {
        ;if ${Me.Group[${GroupCounter}].Effect[Query, MainIconID==172](exists)}
	    if ${Me.Group[${GroupCounter}].Cursed} == -1
        {
            oc ${Me.Group[${GroupCounter}].Name} needs an Intercept!
            wait 20
            oc !ci -CastAbilityOnPlayer igw:${Me.Name} "Intercept" ${Me.Group[${GroupCounter}].Name}
            wait 30
            break
        }
        wait 5
        GroupCounter:Inc    
    }
    CureInterlude:Set[FALSE]
}