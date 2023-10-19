function main()
{
    Me.Inventory[Query, Location =- "Inventory" && Name =- "Noxious Aura: Ears"]:Use
    wait 10
    Me.Inventory[Query, Location =- "Inventory" && Name =- "Noxious Aura: Ears"]:EnchantItem[${Me.Equipment[13].ID}]
    wait 40
    Me.Inventory[Query, Location =- "Inventory" && Name =- "Noxious Aura: Fingers"]:Use
    wait 10
    Me.Inventory[Query, Location =- "Inventory" && Name =- "Noxious Aura: Fingers"]:EnchantItem[${Me.Equipment[11].ID}]
    wait 40
    press esc
    Me.Inventory[Query, Location =- "Inventory" && Name =- "Noxious Aura: Wrist"]:Use
    wait 10
    Me.Inventory[Query, Location =- "Inventory" && Name =- "Noxious Aura: Wrist"]:EnchantItem[${Me.Equipment[16].ID}]
    wait 40
    press esc
}