


function main()
{
    relay ${OgreRelayGroup} uplink relaygroup -join \${Me.Name}
    variable int e = -1
    variable int j = -1
    while ${e:Inc} < 6
    {
        if !${g${e}(exists)}
        {
            declare g${e} int globalkeep -1
        }
        g${e}:Set[-1]
    }
    Event[EQ2_onIncomingText]:AttachAtom[EQ2_onIncomingText]
	oc !ci -UplinkOptionChange priest checkbox_settings_disablecaststack_curecurse TRUE
    oc !ci -UplinkOptionChange priest checkbox_settings_disablecaststack_cure FALSE
    ;${OgreBotAPI.DetrimentalInfo[452,-1,${Me.ID},CurrentIncrements]}
    variable int toMatch = -1
    while 1<2
    {
        ;Wrath of the Math: MainIconID:270, BackDropIconID:65535, Increments:85
        if ${OgreBotAPI.DetrimentalInfo[270,65535,${Actor[namednpc,Labomination].ID},CurrentIncrements]} > 0
        {
            toMatch:Set[${OgreBotAPI.DetrimentalInfo[270,65535,${Actor[namednpc,Labomination].ID},CurrentIncrements]}]
            echo Checking! (needs to match: ${toMatch})
            wait 30
            e:Set[-1]
            while ${e:Inc} < 6
            {
                echo relay ${Me.Group[${e}].Name} relay ${Me.Name} g${e}:Set[\${OgreBotAPI.DetrimentalInfo[270,-1,\${Me.ID},CurrentIncrements]}]
                relay ${Me.Group[${e}].Name} relay ${Me.Name} g${e}:Set[\${OgreBotAPI.DetrimentalInfo[270,-1,\${Me.ID},CurrentIncrements]}]
            }
            wait 20
            e:Set[-1]
            while ${e:Inc} < 6
            {
                echo g${e}: ${g${e}}
                j:Set[-1]
                while ${j:Inc} < 6
                {
                    echo ${j} != ${e} && \${Math.Calc[${g${e}}+${g${j}}]}(${Math.Calc[${g${e}}+${g${j}}]}) == ${toMatch}
                    if ${j} != ${e} && ${Math.Calc[${g${e}}+${g${j}}]} == ${toMatch}
                    {
                        echo Found match! ${g${e}}+${g${j}}== ${toMatch}  -- ${Me.Group[${e}]} / ${Me.Group[${j}]}
                        while ${OgreBotAPI.DetrimentalInfo[270,65535,${Actor[namednpc,Labomination].ID},CurrentIncrements]} == ${toMatch}
                        {
                            oc !c -CastAbilityOnPlayer irw:${Me.Name}+druid "Cure Curse" ${Me.Group[${e}].Name}
                            oc !c -CastAbilityOnPlayer irw:${Me.Name}+cleric "Cure Curse" ${Me.Group[${e}].Name}
                            oc !c -CastAbilityOnPlayer irw:${Me.Name}+shaman "Cure Curse" ${Me.Group[${j}].Name}
                            oc !c -CastAbilityOnPlayer irw:${Me.Name}+channeler "Cure Curse" ${Me.Group[${j}].Name}
                            wait 100
                        }
                        e:Set[1000]
                        j:Set[1000]
                    }
                }
            }
        }
        wait 10
    }

}

atom AtExit()
{
    oc !ci -UplinkOptionChange priest checkbox_settings_disablecaststack_curecurse FALSE
    oc !ci -UplinkOptionChange priest checkbox_settings_disablecaststack_cure FALSE
}