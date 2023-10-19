
function main()
{
	eq2ex /toggletradeskills
	wait 20
	eq2ex /toggletradeskills
	wait 20
    
    while 1<2
    {
        ; woodworker
        call DoProcess "Voidpiercer's Longbow of Energy" "Voidpiercer's Longbow of Energy"

        ; tailor
        call DoProcess "Voidpiercer's Pants of Rage" "Voidpiercer's Pants of Rage"

        ; add whatever additional items you want, just copy one of the lines from above and replace the recipename and itemname

        wait 10
    }
}

function DoProcess(string recipeName, string itemName)
{
    if !${Me.Recipe["${recipeName}"](exists)}
    {
        echo can't craft ${recipeName}
        return
    }
    oc !c -Pause ${Me.Name}
    wait 5

    call BreakItems "${itemName}"
    call CraftItems "${recipeName}"
    call BreakItems "${itemName}"
}

function BreakItems(string itemName)
{
    echo Breaking
    while ${Me.Inventory[Query,Name="${itemName}"&&Location="Inventory"](exists)}
    {
        echo in break loop
        ;oc !c -CastAbility ${Me.Name} "Salvage"
        Me.Ability[id,2266640201]:Use
        wait 5
        
        Me.Inventory[Query,Name="${itemName}"&&Location="Inventory"]:Transmute
        wait 10
    }
}

function CraftItems(string recipeName)
{
    variable int quantity = 100
    while ${Me.InventorySlotsFree} < ${Math.Calc[${quantity}+10]}
    {
        quantity:Dec[10]
    }
    call ResetCraft
    
    echo OgreCraft:AddRecipeName[${quantity},"${recipeName}"]
    OgreCraft:AddRecipeName[${quantity},"${recipeName}"]

    oc !c -Pause ${Me.Name}
    wait 10
    OgreCraft:Start
    wait 80

    while ${OgreCraft.Crafting}
    {
        wait 5
    }
    wait 20
    oc !c -Resume ${Me.Name}
}

function ResetCraft()
{
	ogre end craft
	wait 20
	ogre craft
	wait 50

	while !${OgreCraft.IsReady}
	{
        waitframe
    }
}
atom AtExit()
{
    ogre end craft
    oc !c -Resume ${Me.Name}
    echo CraftLunarMaterial - out
}