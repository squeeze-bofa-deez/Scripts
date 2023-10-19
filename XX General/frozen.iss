function main()
{
    do
    {
	while ${Me.InCombat} 
        {
                if ${Me.Maintained["Frozen Solid"].CurrentIncrements} < 30
                {
                    echo Frozen Rain 0
		    OgreBotAPI:ChangeCastStackListBoxItemByTag[${Me.Name},Frozen150,False]
                }
		elseif ${Me.Maintained["Frozen Solid"].CurrentIncrements} == 150
                {
                    echo Frozen Rain 150
		    OgreBotAPI:ChangeCastStackListBoxItemByTag[${Me.Name},Frozen150,True]
                }
		elseif ${Me.Maintained["Frozen Solid"].CurrentIncrements} < 60
                {
                    echo Frozen Rain 30
                }
                elseif ${Me.Maintained["Frozen Solid"].CurrentIncrements} < 90
                {
                    echo Frozen Rain 60
                }
                elseif ${Me.Maintained["Frozen Solid"].CurrentIncrements} < 120
                {
                    echo Frozen Rain 90
                }
                else
                {
                    echo Frozen Rain 120
		}
        wait 10
        }
	wait 50
    }
    while 1
}