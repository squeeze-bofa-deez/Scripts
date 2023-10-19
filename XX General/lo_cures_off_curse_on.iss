/*
    Author:     LostOne
    Script:     Loops the cast stack and will disable anything with: Type = Cure & Confront Fear
                It will then enable only Cure Curse.
    Who:        Typically run on everyone in the group/raid.
                oc !ci -RunScriptOB igw:${Me.Name} lo_cures_off_curse_on
*/
function main()
{
    variable persistentref CastStack
    variable int idx1
    variable int idx2
    variable string ablity_name
    variable bool blast_romans

    CastStack:SetReference["UIElement[uiXML].FindChild[frame_TabColumn2Button14].FindChild[listbox_caststack_order]"]

    ;disable all items with the type = cure
    for (idx1:Set[0] ; ${idx1}<=${CastStack.Items} ; idx1:Inc)
    {
        if ${CastStack.Item[${idx1}].Text.Find["Type = Cure"]}
        {
            ;set ablity name
            ablity_name:Set[${CastStack.Item[${idx1}].Text.Left[${Math.Calc[${CastStack.Item[${idx1}].Text.Find[ | ]}-2]}]}]
            
            ;blast roman numerals, ChangeCastStackListBoxItem does not seem to like them
            blast_romans:Set[FALSE]
            for (idx2:Set[${ablity_name.Length}] ; ${idx2} > 0 ; idx2:Dec)
            {
                if ${ablity_name.Mid[${idx2},1].EqualCS["I"]} || ${ablity_name.Mid[${idx2},1].EqualCS["V"]} ||${ablity_name.Mid[${idx2},1].EqualCS["X"]}
                {
                    blast_romans:Set[TRUE]
                }
                elseif ${ablity_name.Mid[${idx2},1].Equal[" "]}
                {
                    if ${blast_romans}
                    {
                        ablity_name:Set[${ablity_name.Left[${idx2}]}]
                        break
                    }
                }
                else
                {
                    break
                }
            }
            OgreBotAPI:ChangeCastStackListBoxItem[${Me.Name},"${ablity_name}",FALSE]
        } 
    }

    oc !ci -ccstack ${Me.Name} "Confront Fear" FALSE

    ;enable just cure curse
    OgreBotAPI:ChangeCastStackListBoxItem[${Me.Name},"Cure Curse",TRUE]
}