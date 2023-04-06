function main()
{
	variable index:actor Index
	variable iterator Iter
	
	EQ2:GetActors[Index,range,10]
	Index:GetIterator[Iter]
	
	echo ${Time}: Starting Venril Statue...
	
	while 1
	{	
		;;Check if Venril Sathir's health is less than or equal to 92% before clicking the statue. You can adjust this number based on raid wide dps.
		if ${Actor["Venril Sathir"].Health} <= 92
		{
			if ${Iter:First(exists)}
			{
				do
				{
					;;Find the statue. You should be closer than 10m to it.
					if ${Iter.Value.Name.Equals["a miniature statue"]}
					{
						;;Check if the statue is green.
						if ${Iter.Value.Aura.Equals["result_fire_green"]}
						{
							echo ${Time}: \agThe statue is green! Clicking statue that is [${Iter.Value.Distance}m] away!
							
							oc !c -ApplyVerb "a miniature statue" "Open soulbox briefly"
							
							wait 50
						}	

						break
					}
				}
				while ${Iter:Next(exists)}
			}
		}	
	}	
}

function atexit()
{
	echo ${Time}: Ending Venril Statue...
}