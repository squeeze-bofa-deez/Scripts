#ifndef ArgumentProcessor_i
#define ArgumentProcessor_i

objectdef ArgumentProcessor
{
	method ProcessArg(string Option,string Value)
	{
	}

	method Process(... Args)
	{
		variable int ArgsIndex

		ArgsIndex:Set[0]

		while ${ArgsIndex:Inc} <= ${Args.Size}
		{
			variable string Argument
			variable string Option
			variable string Value
			variable int    EqualsIndex

			Argument:Set["${Args[${ArgsIndex}]}"]

			EqualsIndex:Set[${Argument.Find["="]}]

			if ${EqualsIndex} == 0
			{
				Option:Set["${Argument}"]
				Value:Set[""]
			}
			else
			{
				Option:Set["${Argument.Left[${Math.Calc64[${EqualsIndex}-1]}]}"]
				Value:Set["${Argument.Right[${Math.Calc64[-${EqualsIndex}]}]}"]

				if ${Value.Left[1].Equal["\""]}
				{
					Value:Set[${Value}]
				}
			}

			This:ProcessArg["${Option}","${Value}"]
		}
	}
}

#endif
