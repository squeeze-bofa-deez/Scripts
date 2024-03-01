/*
    This will swap out your add gloves if Drago is detected, and then re-equip them once he's gone.
    Requires you have an attuned pair of "Gloves of Knowledge" in your inventory (the non-add version).
*/

function main()
{
    while 1<2
    {
        if ${Actor[namednpc,Drago](exists)} && ${Me.Equipment[hands].Name.Find["of knowledge"](exists)} && !${Me.Equipment[hands].Name.Equal["Gloves of Knowledge"]}
        {
            call EquipGlovesOfKnowledge
            while (${Actor[namednpc,Drago](exists)} || !${Zone.Name(exists)} || !${Me.Name(exists)}) && ${Me.Equipment[hands].Name.Equal["Gloves of Knowledge"]}
            {
                echo waiting to re-equip
                wait 30
            }
            if ${Me.Equipment[hands].Name.Equal["Gloves of Knowledge"]}
            {
                call ReEquipAddGloves
            }
        }
        wait 10
    }
}

function EquipGlovesOfKnowledge()
{
    variable index:item Items
	variable iterator ItemIterator
	    
	Me:QueryInventory[Items,Location="Inventory"&& Name="Gloves of Knowledge"]
	Items:GetIterator[ItemIterator]
    if ${ItemIterator:First(exists)}
	{
		;oc Banking first exists
	    do
	    {
	    	if ${ItemIterator.Value.LinkID(exists)}
	    	{
                if !${Me.Inventory[Query,SerialNumber=${ItemIterator.Value.SerialNumber}].IsItemInfoAvailable}
                {
                    wait 2
                }
	    		if !${Me.Inventory[Query,SerialNumber=${ItemIterator.Value.SerialNumber}].ToItemInfo.Attuned}
                {
                    echo Not attuned ${ItemIterator.Value.Name} ${ItemIterator.Value.SerialNumber}
                    wait 2
                }
                else
                {
                    ItemIterator.Value:Equip
                    wait 20
                }
	    	}
	    }
	    while ${ItemIterator:Next(exists)}
	}
    else
    {
        echo Gloves of Knowledge not found in inventory
    }
}
function ReEquipAddGloves()
{
    variable index:item Items
	variable iterator ItemIterator
	    
	Me:QueryInventory[Items,Location="Inventory"&&Name=" of Knowledge"]
	Items:GetIterator[ItemIterator]
    if ${ItemIterator:First(exists)}
	{
		;oc Banking first exists
	    do
	    {
	    	if ${ItemIterator.Value.LinkID(exists)}
	    	{
                if !${Me.Inventory[Query,SerialNumber=${ItemIterator.Value.SerialNumber}].IsItemInfoAvailable}
                {
                    wait 2
                }
	    		if !${Me.Inventory[Query,SerialNumber=${ItemIterator.Value.SerialNumber}].ToItemInfo.Attuned}
                {
                    echo Not attuned ${ItemIterator.Value.Name} ${ItemIterator.Value.SerialNumber}
                    wait 2
                }
                else
                {
                    ItemIterator.Value:Equip
                    wait 20
                }
	    	}
	    }
	    while ${ItemIterator:Next(exists)}
	}
    else
    {
        echo Gloves of Knowledge not found in inventory
    }
}
