function main()
{
    Me.Inventory[Query, Location =- "Inventory" && Name =- "Empyral Rune: Blinding Gleam"]:Use
    wait 10
    Me.Inventory[Query, Location =- "Inventory" && Name =- "Empyral Rune: Blinding Gleam"]:EnchantItem[${Me.Equipment[19].ID}]
    wait 40
    press esc
}