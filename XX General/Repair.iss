function main()
{
	if !${Actor[Query,Name=="Mechanized Platinum Repository of Reconstruction"](exists)}
	{
	    oc Using your tank's repair bot.
        oc !ci -UseItem igw:${Me.Name}+fighter "Mechanized Platinum Repository of Reconstruction"
	    wait 50
    }
	if !${Actor[Query,Name=="Mechanized Platinum Repository of Reconstruction"](exists)}
	{
		oc Tank's repair bot not available, trying your bard.
		oc !ci -UseItem igw:${Me.Name}+bard "Mechanized Platinum Repository of Reconstruction"
		wait 50
	}
	if !${Actor[Query,Name=="Mechanized Platinum Repository of Reconstruction"](exists)}
	{
		oc Bard's repair bot not available, trying your chanter.
		oc !ci -UseItem igw:${Me.Name}+enchanter "Mechanized Platinum Repository of Reconstruction"
		wait 50
	}
	if !${Actor[Query,Name=="Mechanized Platinum Repository of Reconstruction"](exists)}
	{
		oc Chanter's repair bot not available, trying your scouts.
		oc !ci -UseItem igw:${Me.Name}+scout "Mechanized Platinum Repository of Reconstruction"
		wait 50
	}
	if !${Actor[Query,Name=="Mechanized Platinum Repository of Reconstruction"](exists)}
	{
		oc Scout's repair bot not available, trying your mages.
		oc !ci -UseItem igw:${Me.Name}+mage "Mechanized Platinum Repository of Reconstruction"
		wait 50
	}
    if !${Actor[Query,Name=="Mechanized Platinum Repository of Reconstruction"](exists)}
	{
		oc Mage's repair bot not available, trying your priests.
		oc !ci -UseItem igw:${Me.Name}+priest "Mechanized Platinum Repository of Reconstruction"
		wait 50
	}
	oc !ci -repair igw:${Me.Name}
	wait 40
}

atom atexit()
{
	oc ${Me.Name}: Ending repair script.
}
