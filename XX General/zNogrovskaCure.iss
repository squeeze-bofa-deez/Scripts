


function main()
{
    relay ${OgreRelayGroup} uplink relaygroup -join \${Me.Name}
    variable int e = -1
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
    oc !ci -UplinkOptionChange priest checkbox_settings_disablecaststack_cure TRUE
    ;${OgreBotAPI.DetrimentalInfo[452,-1,${Me.ID},CurrentIncrements]}
    while 1<2
    {
        if ${OgreBotAPI.DetrimentalInfo[452,-1,${Me.ID},CurrentIncrements]} > 0
        {
            echo Checking!
            eq2ex /r ok i have the det!
            wait 30
            e:Set[-1]
            while ${e:Inc} < 6
            {
                echo relay ${Me.Group[${e}].Name} relay ${Me.Name} g${e}:Set[\${OgreBotAPI.DetrimentalInfo[452,-1,\${Me.ID},CurrentIncrements]}]
                relay ${Me.Group[${e}].Name} relay ${Me.Name} g${e}:Set[\${OgreBotAPI.DetrimentalInfo[452,-1,\${Me.ID},CurrentIncrements]}]
            }
            wait 20
            e:Set[-1]
            while ${e:Inc} < 6
            {
                echo g${e}: ${g${e}}
            }
        }
        wait 10
    }

}
atom EQ2_onIncomingText(string Text)
{
    variable int targetNum = -1
    variable int e = -1
	if ${Text.Find["to nurse with your Cure Curse"]}
	{
		if ${Text.Find[first](exists)}
        {
            targetNum:Set[1]
        }
        elseif ${Text.Find[second](exists)}
        {
            targetNum:Set[2]
        }
        elseif ${Text.Find[third](exists)}
        {
            targetNum:Set[3]
        }
        elseif ${Text.Find[fourth](exists)}
        {
            targetNum:Set[4]
        }
        elseif ${Text.Find[fifth](exists)}
        {
            targetNum:Set[5]
        }
        elseif ${Text.Find[sixth](exists)}
        {
            targetNum:Set[6]
        }

        if ${targetNum} > 0
        {
            e:Set[-1]
            while ${e:Inc} < 6
            {
                if ${g${e}} == ${targetNum}
                {
                    oc ok cure ${Me.Group[${e}]}!
                    oc !c -CastAbilityOnPlayer irw:${Me.Name} "Cure Curse" ${Me.Group[${e}].Name}
                }
            }
        }
        else
        {
            oc uhhh, wtf is she talking about?
        }
	}
}

atom AtExit()
{
    oc !ci -UplinkOptionChange priest checkbox_settings_disablecaststack_curecurse FALSE
    oc !ci -UplinkOptionChange priest checkbox_settings_disablecaststack_cure FALSE
}