
variable string spellconjurorname = "Shard of Essence"
variable string spellnecromancername = "Dark Heart"

variable string spellconjuroritem = "Shard of Essence"
variable string spellnecromanceritem = "Dark Heart"

variable string spellconjurorid = "3814592930"
variable string spellnecromancerid = "1852049104"

variable string targetName = None

function main()
{
    if !${Me.Class.Equals[summoner]}
    {
        return
    }
	while 1<2
    {
        call InitializeVars
        call UpdateVars
        call PickTarget

        if ${Me.Raid[${targetName}](exists)} || ${Me.Group[${targetName}](exists)} || ${Me.Name.Equals[${targetName}]}
        {
            echo call GiveHeart ${targetName}
            call GiveHeart ${targetName}
        }
        wait 10
    }
}

function PickTarget()
{
    variable int r = 0
    variable bool up = TRUE
    if ${Me.SubClass.Equals[necromancer]}
    {
        up:Set[FALSE]
        ;eq2ex /r backwards
        r:Set[25]
    }
    variable int bestScore = -10
    variable string bestName = None
    variable int score = 0
    echo bestScore to start: ${bestScore}
    while (${up} && ${r:Inc} <= 24) || (!${up} && ${r:Dec} > 0)
    {
        if !${up}
        {
            r:Dec
        }
        echo checking ${r}
        if ${Me.Raid[${r}].ID(exists)}
        {
            score:Set[1]
            if ${OgreBotAPI.Get_Archetype["${Me.Raid[${r}].Class}"].Equals[fighter]}
            {
                score:Set[4]
            }
            if ${OgreBotAPI.Get_BaseClass["${Me.Raid[${r}].Class}"].Equals[druid]}
            {
                score:Set[5]
            }
            if ${OgreBotAPI.Get_BaseClass["${Me.Raid[${r}].Class}"].Equals[shaman]}
            {
                score:Set[6]
            }
            if ${OgreBotAPI.Get_BaseClass["${Me.Raid[${r}].Class}"].Equals[cleric]}
            {
                score:Set[5]
            }
            if ${item${Me.SubClass}${Me.Raid[${r}].Name}Tracking}
            {
                score:Dec[1000]
            }
            if ${itemnecromancer${Me.Raid[${r}].Name}Tracking}
            {
                score:Dec[4]
            }
            if ${itemconjuror${Me.Raid[${r}].Name}Tracking}
            {
                score:Dec[4]
            }
            if ${Me.Raid[${r}].Power} < 10
            {
                score:Inc[3]
            }
            if ${score} > ${bestScore}
            {
                bestScore:Set[${score}]
                bestName:Set[${Me.Raid[${r}].Name}]
            }
        }
    }
    if ${Me.Raid} <= 0
    {
        r:Set[-1]
        while ${r:Inc} < 6
        {
            score:Set[1]
            if ${OgreBotAPI.Get_Archetype["${Me.Group[${r}].Class}"].Equals[fighter]}
            {
                score:Set[4]
            }
            if ${OgreBotAPI.Get_BaseClass["${Me.Group[${r}].Class}"].Equals[druid]}
            {
                score:Set[5]
            }
            if ${OgreBotAPI.Get_BaseClass["${Me.Group[${r}].Class}"].Equals[shaman]}
            {
                score:Set[6]
            }
            if ${OgreBotAPI.Get_BaseClass["${Me.Group[${r}].Class}"].Equals[cleric]}
            {
                score:Set[5]
            }
            if ${item${Me.SubClass}${Me.Group[${r}].Name}Tracking}
            {
                score:Dec[1000]
            }
            if ${itemnecromancer${Me.Group[${r}].Name}Tracking}
            {
                score:Dec[4]
            }
            if ${itemconjuror${Me.Group[${r}].Name}Tracking}
            {
                score:Dec[4]
            }
            if ${Me.Group[${r}].Power} < 10
            {
                score:Inc[3]
            }
            echo if ${Me.Group[${r}].Name} -- ${score} > ${bestScore}
            if ${score} > ${bestScore}
            {
                bestScore:Set[${score}]
                bestName:Set[${Me.Group[${r}].Name}]
            }
        }
    }
    targetName:Set[${bestName}]
}

function UpdateVars()
{
    
    variable int r = 0
    while ${r:Inc} <= 24
    {
        relay ${Me.Raid[${r}].Name} relay ${Me.Name} itemnecromancer${Me.Raid[${r}].Name}Tracking:Set[\${Me.Inventory["Dark Heart"](exists)}]
        relay ${Me.Raid[${r}].Name} relay ${Me.Name} itemconjuror${Me.Raid[${r}].Name}Tracking:Set[\${Me.Inventory["Shard of Essence"](exists)}]
    }
    if ${Me.Raid} <= 0
    {
        r:Set[-1]
        while ${r:Inc} < 6
        {
            relay ${Me.Group[${r}].Name} relay ${Me.Name} itemnecromancer${Me.Group[${r}].Name}Tracking:Set[\${Me.Inventory["Dark Heart"](exists)}]
            relay ${Me.Group[${r}].Name} relay ${Me.Name} itemconjuror${Me.Group[${r}].Name}Tracking:Set[\${Me.Inventory["Shard of Essence"](exists)}]
        }
    }
    wait 10
}

function InitializeVars()
{
    
    variable int r = 0
    while ${r:Inc} <= 24
    {
        if !${itemnecromancer${Me.Raid[${r}].Name}Tracking(exists)}
        {
            declare itemnecromancer${Me.Raid[${r}].Name}Tracking bool globalkeep FALSE
        }
        if !${itemconjuror${Me.Raid[${r}].Name}Tracking(exists)}
        {
            declare itemconjuror${Me.Raid[${r}].Name}Tracking bool globalkeep FALSE
        }
    }
    if ${Me.Raid} <= 0
    {
        r:Set[-1]
        while ${r:Inc} < 6
        {
            if !${itemnecromancer${Me.Group[${r}].Name}Tracking(exists)}
            {
                declare itemnecromancer${Me.Group[${r}].Name}Tracking bool globalkeep FALSE
            }
            if !${itemconjuror${Me.Group[${r}].Name}Tracking(exists)}
            {
                declare itemconjuror${Me.Group[${r}].Name}Tracking bool globalkeep FALSE
            }
        }
    }
}

function GiveHeart(string memberName)
{
    echo Give to ${memberName}
    while ${Me.Ability[id,${spell${Me.SubClass}id}](exists)} && ${Me.Ability[id,${spell${Me.SubClass}id}].TimeUntilReady} > 0
    {
        echo Waiting
        wait 5
    }

    oc !ci -CastAbilityOnPlayer ${Me.Name} "${spell${Me.SubClass}name}" ${memberName}
    wait 80
    
    while ${Me.Ability[id,${spell${Me.SubClass}id}](exists)} && ${Me.Ability[id,${spell${Me.SubClass}id}].TimeUntilReady} > 0
    {
        echo Waiting
        wait 5
    }
}