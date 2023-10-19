function main()
{
    echo listening for DG  -- also , if you're reading this, there's probably a better way to do this.
    {
	while ${Me.InCombat} 
        {
			if ${Me.Ability[id,3407524969].TimeUntilReady} <= 1
				{
                    wait 1
				 eq2ex gsay DG IS BACK UP
                 wait 930
				}
        }
                        wait 930

    }
}