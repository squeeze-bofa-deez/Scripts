function main()
{   
    variable int Counter = 1
    declare ScanComplete string script
    ScanComplete:Set[FALSE]

    Actor["Lore & Legend Depot (Large)"]:DoubleClick
    wait 5
    Me:QueryInventory
    wait 5
    while ${ScanComplete.Equals["FALSE"]}
        {
            wait 1
            if ${ContainerWindow.Item[${Counter}].IsItemInfoAvailable}==FALSE && !${ContainerWindow.Item[${Counter}].ID}==NULL
            { 
                do
                {
                    waitframe
                }
                while ${ContainerWindow.Item[${Counter}].IsItemInfoAvailable}==FALSE
            }
            wait 1
            if ${ContainerWindow.Item[${Counter}].IsItemInfoAvailable}==TRUE && ${ContainerWindow.Item[${Counter}].ToItemInfo.IsQuestItemUsable}==TRUE && !${ContainerWindow.Item[${Counter}].Name.Equals["NULL"]}
            {
                echo ${Time} - ${Counter} - ${ContainerWindow.Item[${Counter}]} is a needed lore and legend item - pulling from depot.
                ContainerWindow:RemoveItem["${ContainerWindow.Item["${ContainerWindow.Item[${Counter}]}"].ID}","${ContainerWindow.Item["${ContainerWindow.Item[${Counter}]}"].Quantity}"]
                wait 1
            }
            else 
            {
                echo ${Time} - ${Counter} - ${ContainerWindow.Item[${Counter}]} is not needed - moving to the next item.
                wait 1
                Counter:Inc

            }
            wait 5
            if ${ContainerWindow.Item[${Counter}].ID}==NULL
            {
                echo ${Time} - Scan is complete, ${Math.Calc64[ ${Counter} - 1]} items pulled, moving to the add step.
                ScanComplete:Set[TRUE]
            }
        }
    call AddCollections

}

function AddCollections()
{
    variable index:item Items
    variable iterator ItemIterator
    variable int Counter = 1
    
    Me:QueryInventory[Items, Name=- "a " Name=- "an " Tier == "Treasured" Location == "Inventory"]
    Items:GetIterator[ItemIterator]
    echo ${Time} - Going through everything we just pulled out - this will take some time.
    oc ${Me.Name} - Going through everything we just pulled out - this will take some time. 
    if ${ItemIterator:First(exists)}
    {
        do
        {
            if (!${ItemIterator.Value.IsItemInfoAvailable})
            { 
                do
                {
                    waitframe
                }
                while (!${ItemIterator.Value.IsItemInfoAvailable})
            }
            if ${ItemIterator.Value.ToItemInfo.IsQuestItemUsable}==TRUE 
            {
				Me.Inventory[${ItemIterator.Value.Name}]:Examine
				wait 10
                echo ${Time} - Added ${ItemIterator.Value.Name}.
                oc ${Me.Name} - Added ${ItemIterator.Value.ToItemInfo.Name}.
		    }
            Counter:Inc
        }
        while ${ItemIterator:Next(exists)}
    }
    wait 2
    echo ${Time} - Script complete, all needed items should be added.
    eq2execute container deposit_all ${Actor["Lore & Legend Depot (Large)"].ID} 0
}