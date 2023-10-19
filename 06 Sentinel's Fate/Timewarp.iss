function main()
{
	while 1
	{
		while ${Me.InCombat}==TRUE
		{
			if ${Me.Ability[id,3020295062].TimeUntilReady} >=20 && ${Me.Ability[id,1087469630].IsReady}==TRUE 
			{
				OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Peace of Mind" TRUE TRUE
				wait 20
			}
			elseif ${Me.Ability[id,3020295062].IsReady}==TRUE
			{
				OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Peace of Mind" FALSE TRUE
				wait 20
			}
			else
			{
				wait 5
			}
		}
	}
}