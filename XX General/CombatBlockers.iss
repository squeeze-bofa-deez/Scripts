



variable collection:collection:int timers


variable bool found = FALSE
variable bool enabled = FALSE
function main()
{
    
    oc !ci -ChangeCastStackListBoxItemByTag ${Me.Name} COMBAT_BLOCKER FALSE
    Event[OgreEvent_OnAbilityReadyTimersUpdate]:AttachAtom[OgreEvent_OnAbilityReadyTimersUpdate]
    wait 20
    while 1<2
    {
        found:Set[FALSE]
        call DoCheck "Tortoise Shell"
        call DoCheck "Advance Warning"
        call DoCheck "Bladedance"
        call DoCheck "Tunare's Watch"
        call DoCheck "Sentry Watch"
        call DoCheck "Guardian Sphere"
        wait 30
    }
}

function DoCheck(string abilityName)
{

    if ${found} 
    {
        echo already found, skipping ${abilityName}
        return
    }

    variable int g = -1
    while ${g:Inc} < 6
    {
        if ${timers.Element["${abilityName}"].Element[${Me.Group[${g}].Name}](exists)} && ${timers.Element["${abilityName}"].Element[${Me.Group[${g}].Name}]} <= 0
        {
            found:Set[TRUE]
            if ${Me.Group[${g}].Name.Equal[${Me.Name}]}
            {
                if !${enabled}
                {
                    oc ${Me.Name} CombatBlocker enabling for ${abilityName}
                    oc !ci -ChangeCastStackListBoxItemByTag ${Me.Name} COMBAT_BLOCKER TRUE
                    enabled:Set[TRUE]
                }
            }
            else
            {
                if ${enabled}
                {
                    oc ${Me.Name} CombatBlocker disabling for ${Me.Group[${g}].Name}'s ${abilityName}
                    oc !ci -ChangeCastStackListBoxItemByTag ${Me.Name} COMBAT_BLOCKER FALSE
                    enabled:Set[FALSE]
                }
            }
        }
    }
    ;echo ${Me.Name} nothing up for [${abilityName}]
    ;oc ${Me.Name} nothing up for [${abilityName}]
}

function DoCastMTSingle(string abilityName)
{
    if ${Math.Calc[${Time.Timestamp}-${lastBlock}]} < 25
    {
        echo already cast recently: ${Math.Calc[${Time.Timestamp}-${lastBlock}]} < 10
        return
    }

    variable int g = 0
    while ${g:Inc} < 24
    {
        if ${timers.Element["${abilityName}"].Element[${Me.Raid[${g}].Name}](exists)} && ${timers.Element["${abilityName}"].Element[${Me.Raid[${g}].Name}]} <= 0
        {
            ;lastBlock:Set[${Time.Timestamp}]
            oc ${Me.Name} USING >>>> [${abilityName}] (from: ${Me.Raid[${g}].Name})
            relay ${Me.Raid[${g}].Name} OgreBotAPI:Pause
            relay ${Me.Raid[${g}].Name} eq2ex /cancel_spellcast
            oc !c -CastAbility ${Me.Raid[${g}].Name} "${abilityName}" ${Me.Name}
            timedcommand 3 relay ${Me.Raid[${g}].Name} OgreBotAPI:Resume
            
            return
        }
    }
    echo ${Me.Name} nothing up for [${abilityName}]
    oc ${Me.Name} nothing up for [${abilityName}]
}

atom OgreEvent_OnAbilityReadyTimersUpdate(string _Toon, int64 _AbilityID=0, string _AbilityName="", float _TimeUntilReady=0)
{
    ;echo ${Time}: OgreEvent_OnAbilityReadyTimersUpdate: ${_Toon} ability ${_AbilityName} with ID ${_AbilityID} is ready in: ${_TimeUntilReady}

    if !${timers.Element["${_AbilityName}"](exists)}
    {
        variable collection:int toPass
        variable weakref toPassRef = toPass
        timers:Set["${_AbilityName}", ${toPassRef}]
    }
    timers.Element["${_AbilityName}"]:Set[${_Toon},${_TimeUntilReady}]
    
    ;echo ${Time}: OgreEvent_OnAbilityReadyTimersUpdate: ${_Toon} ability ${_AbilityName} with ID ${_AbilityID} is ready in: ${_TimeUntilReady} (${timers.Element["${_AbilityName}"].Element["${_Toon}"]})
}

atom AtExit()
{
    oc !ci -ChangeCastStackListBoxItemByTag ${Me.Name} COMBAT_BLOCKER FALSE
}