

variable string abilityId = 211463007
variable string targetName = None

function main()
{
    if !${Me.Class.Equals[enchanter]}
    {
        return
    }
	Event[EQ2_onIncomingText]:AttachAtom[EQ2_onIncomingText]
    oc !ci -ChangeCastStackListBoxItem ${Me.Name} "Mana Flow" FALSE
    variable int i = 0
	while 1<2
    {
        while ${Me.IsDead}
        {
            wait 30
        }
        if ${i:Inc} > 300
        {
            i:Set[0]
            oc !ci -ChangeCastStackListBoxItem ${Me.Name} "Mana Flow" FALSE
        }
        call WaitCooldown
        call PickTarget

        if ${Me.Raid[${targetName}](exists)} || ${Me.Group[${targetName}](exists)} || ${Me.Name.Equals[${targetName}]}
        {
            echo call GiveFlow ${targetName}
            call GiveFlow ${targetName}
        }
        wait 10
    }
}
atom AtExit()
{
    ;oc !ci -ChangeCastStackListBoxItem ${Me.Name} "Mana Flow" TRUE
}

function PickTarget()
{
    targetName:Set[None]
    variable int c1 = ${Me.RaidGroupNum}
    variable int c2 = 2
    variable int c3 = 3
    variable int c4 = 4

    if ${c1} == 1
    {
        c2:Set[3]
        c3:Set[2]
        c4:Set[4]
    }    
    if ${c1} == 2
    {
        c2:Set[4]
        c3:Set[1]
        c4:Set[3]
    }    
    if ${c1} == 3
    {
        c2:Set[1]
        c3:Set[4]
        c4:Set[2]
    }    
    if ${c1} == 4
    {
        c2:Set[2]
        c3:Set[3]
        c4:Set[1]
    }   

    call GetTarget ${c1} shaman 5
    call GetTarget ${c1} druid 5 
    call GetTarget ${c1} cleric 5
    call GetTarget ${c1} fighter 5

    call GetTarget ${c1} shaman 15
    call GetTarget ${c1} druid 15 
    call GetTarget ${c1} cleric 15
    call GetTarget ${c1} fighter 15

    variable int ri = 0
    ri:Set[1]
    while ${ri:Inc} <= 4
    {

        call GetTarget ${c${ri}} shaman 5
        call GetTarget ${c${ri}} druid 5 
        call GetTarget ${c${ri}} cleric 5
        call GetTarget ${c${ri}} fighter 5

    }

    call GetTarget ${c1} shaman 35
    call GetTarget ${c1} druid 35 
    call GetTarget ${c1} cleric 35
    call GetTarget ${c1} fighter 35

    ri:Set[1]
    while ${ri:Inc} <= 4
    {

        call GetTarget ${c${ri}} shaman 15
        call GetTarget ${c${ri}} druid 15 
        call GetTarget ${c${ri}} cleric 15
        call GetTarget ${c${ri}} fighter 15

    }

    call GetTarget ${c1} shaman 55
    call GetTarget ${c1} druid 55 
    call GetTarget ${c1} cleric 55
    call GetTarget ${c1} fighter 55

    call GetTarget ${c1} any 15

    ri:Set[1]
    while ${ri:Inc} <= 4
    {

        call GetTarget ${c${ri}} shaman 35
        call GetTarget ${c${ri}} druid 35 
        call GetTarget ${c${ri}} cleric 35
        call GetTarget ${c${ri}} fighter 35

    }
    ri:Set[1]
    while ${ri:Inc} <= 4
    {

        call GetTarget ${c${ri}} any 5

    }

    call GetTarget ${c1} any 35
    
    ri:Set[1]
    while ${ri:Inc} <= 4
    {
        call GetTarget ${c${ri}} any 5
    }
    
    ri:Set[1]
    while ${ri:Inc} <= 4
    {

        call GetTarget ${c${ri}} shaman 55
        call GetTarget ${c${ri}} druid 55
        call GetTarget ${c${ri}} cleric 55
        call GetTarget ${c${ri}} fighter 55

    }
    
    ri:Set[1]
    while ${ri:Inc} <= 4
    {

        call GetTarget ${c${ri}} shaman 75
        call GetTarget ${c${ri}} druid 75
        call GetTarget ${c${ri}} cleric 75
        call GetTarget ${c${ri}} fighter 75

    }
    
    ri:Set[1]
    while ${ri:Inc} <= 4
    {
        call GetTarget ${c${ri}} any 35
    }

    call GetTarget ${c1} any 55

    call GetTarget ${c1} any 75

    call GetTarget ${c1} any 85

    call GetTarget ${c1} any 95
}

function GetTarget(int gNum, string subClass, int percentage)
{
    if ${Me.Raid[${targetName}](exists)} || ${Me.Group[${targetName}](exists)} || ${Me.Name.Equals[${targetName}]} || ${Me.IsDead} || ${Me.Raid[${targetName}].IsDead} || ${Me.Group[${targetName}].IsDead}
    {
        return
    }
    ;echo checking ${gNum}/${subClass}/${percentage}
    variable int r = 0

    while ${r:Inc} <= 6
    {
        if ${Me.Raid} > 0 && ${Me.Raid[${gNum},${r}].ID} > 0 && ${Me.Raid[${gNum},${r}].Distance} < 28000 && !${Me.Raid[${gNum},${r}].Name.Equals[${Me.Name}]} && !${OgreBotAPI.Get_BaseClass["${Me.Raid[${gNum},${r}].Class}"].Equals[enchanter]}
        {
            if ${subClass.Equals[any]} || ${OgreBotAPI.Get_BaseClass["${Me.Raid[${gNum},${r}].Class}"].Equals[${subClass}]} || ${OgreBotAPI.Get_Archetype["${Me.Raid[${gNum},${r}].Class}"].Equals[${subClass}]}
            {
                ;echo checking ${gNum} ${Me.Raid[${gNum},${r}].Name}(${Me.Raid[${gNum},${r}].Power}%)
                if ${Me.Raid[${gNum},${r}].Power} < ${percentage}
                {
                    if ${Math.Calc[${Time.Timestamp}-${last${Me.Raid[${gNum},${r}].Name}flow}]} < 33
                    {
                        ;echo not eligible, too recent: ${Math.Calc[${Time.Timestamp}-${last${Me.Raid[${gNum},${r}].Name}flow}]} < 33
                        return
                    }
                    targetName:Set[${Me.Raid[${gNum},${r}].Name}]
                    ;echo found new target: ${gNum}/${subClass}/${percentage}: ${targetName}(${Me.Raid[${gNum},${r}].Power}%)
                }
            }
        }
    }
}

function WaitCooldown()
{
    while ${Me.Ability[id,${abilityId}](exists)} && ${Me.Ability[id,${abilityId}].TimeUntilReady} > 0
    {
        echo Waiting on cooldown
        wait 5
    }
}
variable bool alreadyActive = FALSE
atom EQ2_onIncomingText(string aText)
{
	;echo EQ2_onIncomingText - ${Text}
	if ${aText.Find["cannot be cast if it is already active on an ally"](exists)}
	{
        alreadyActive:Set[TRUE]
	}
}

function GiveFlow(string memberName)
{
    echo Give to ${memberName}
    while ${Me.Ability[id,${abilityId}](exists)} && ${Me.Ability[id,${abilityId}].TimeUntilReady} > 0
    {
        echo Waiting
        wait 5
    }

    relay enchanter declare last${memberName}flow int globalkeep ${Time.Timestamp}
    relay enchanter last${memberName}flow:Set[${Time.Timestamp}]

    variable int i = 0
    alreadyActive:Set[FALSE]
    i:Set[0]
    while ${i:Inc} < 15 && !${alreadyActive} && ${Me.Ability[id,${abilityId}].TimeUntilReady} <= 0
    {
        oc !ci -CastAbilityOnPlayer ${Me.Name} "Mana Flow" ${memberName}
        wait 10
    }
    
    if ${Me.Ability[id,${abilityId}](exists)} && ${Me.Ability[id,${abilityId}].TimeUntilReady} > 0
    {
        echo successful cast
        relay enchanter declare last${memberName}flow int globalkeep ${Time.Timestamp}
        relay enchanter last${memberName}flow:Set[${Time.Timestamp}]
    }
    else
    {
        echo failed cast
        relay enchanter declare last${memberName}flow int globalkeep 0
        relay enchanter last${memberName}flow:Set[0]
    }
}