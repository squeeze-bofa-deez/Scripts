function main()
{
	declare OMGRO bool script FALSE
	declare DontSpamMeBro bool script FALSE
	
	while 1
	{
		while ${Me.InCombat}==TRUE
		{
			if ${DontSpamMeBro}==FALSE
			{
				DontSpamMeBro:Set[TRUE]
				wait 1
			}
			if (${Me.Ability["Dagger Storm"].TimeUntilReady} <= ${Me.Ability["Rhythmic Overture"].TimeUntilReady}) && (${Me.Ability["Rhythmic Overture"].TimeUntilReady} <= 7.5) && (${Me.Ability["Victorious Concerto"].TimeUntilReady} <= (${Me.Ability["Rhythmic Overture"].TimeUntilReady}+12))
			{
				OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Dagger Storm" FALSE TRUE
				wait 1
			}
			else
			{
				OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Dagger Storm" TRUE TRUE
				wait 1
			}
			if ${Me.Ability["Victorious Concerto"].TimeUntilReady}<=60 && ${Me.Ability["Requiem"].TimeUntilReady}<=20 && (${Me.Ability["Rhythmic Overture"].TimeUntilReady}>20 && ${Me.Ability["Rhythmic Overture"].TimeUntilReady}<48)
			{
				OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Requiem" FALSE TRUE
				wait 1
			}
			else
			{
				OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Requiem" TRUE TRUE
				wait 1
			}
			if (${Me.Ability["Rhythmic Overture"].TimeUntilReady} >= 48 || ${Me.Ability["Rhythmic Overture"].IsReady}==TRUE) && ${OMGRO}==FALSE
			{
				OMGRO:Set[TRUE]
				echo omgro is true
				wait 1
			}
			if ${Me.Ability["Victorious Concerto"].TimeUntilReady}<=60 && ${OMGRO}==TRUE && (${Me.Ability["Victorious Concerto"].TimeUntilReady}>=${Me.Ability["Rhythmic Overture"].TimeUntilReady}) && ${Me.Maintained[Clara's Chaotic Cacophony VII].Name.Equal["Clara's Chaotic Cacophony VII"]}
			{
				if ${Me.Ability["Rhythmic Overture"].IsReady}==TRUE
				{
					echo Omg, starting VC record!
					echo enabling cadence
					OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Cadence of Destruction" TRUE TRUE
					OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Dragon Claws" TRUE TRUE
					OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Deadly Dance" TRUE TRUE
					OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Requiem" TRUE TRUE
					wait 5
					OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Rhythmic Overture" TRUE TRUE
					wait 5
					while ${Me.Ability["Rhythmic Overture"].TimeUntilReady}<48 && ${Me.InCombat}==TRUE
					{
						echo waiting for RO
						wait 10
					}
					if ${Me.Ability["Rhythmic Overture"].TimeUntilReady}>=48
					{
						echo enabling stuff!
						OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Dagger Storm" TRUE TRUE
						OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Cacophony of Blades" FALSE TRUE
						OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Deadly Dance" TRUE TRUE
						while ${Me.Ability["Rhythmic Overture"].TimeUntilReady}>=48 && ${Me.InCombat}==TRUE
						{
							wait 30
							echo recording, shh...
						}
						OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Rhythmic Overture" FALSE TRUE
						echo Omg, VC!
						OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Cacophony of Blades" TRUE TRUE
						OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Victorious Concerto" TRUE TRUE
						while ${Me.Ability["Victorious Concerto"].TimeUntilReady}<=60 && ${Me.InCombat}==TRUE
						{
							wait 10
						}
						echo VC off
						OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Victorious Concerto" FALSE TRUE
						OMGRO:Set[FALSE]
					}
				}
			}
			wait 5
		}
		if ${DontSpamMeBro}==TRUE && ${Me.InCombat}==FALSE
		{
			echo DontSpamMeBro!
			OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Cadence of Destruction" FALSE TRUE
			OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Dragon Claws" FALSE TRUE
			OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Deadly Dance" FALSE TRUE
			OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Requiem" FALSE TRUE
			OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Rhythmic Overture" FALSE TRUE
			OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Dagger Storm" TRUE TRUE
			OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Cacophony of Blades" TRUE TRUE
			OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Zander's Choral Rebuff" TRUE TRUE
			OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Clara's Chaotic Cacophony" TRUE TRUE
			OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Victorious Concerto" FALSE TRUE
			OMGRO:Set[FALSE]
			DontSpamMeBro:Set[FALSE]
		}
		else
		{
			wait 10
		}
	}
}

