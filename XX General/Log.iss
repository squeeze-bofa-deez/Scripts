#ifndef Log_i
#define Log_i

function Log(string text)
{
	variable time Stamp

	Stamp:Set[${Time.Timestamp}]

	echo ${Stamp.Time24}: ${text}
}

#endif