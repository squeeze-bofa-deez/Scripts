#ifndef LogText_i
#define LogText_i

function LogText(string logFile,string text,bool tee=TRUE)
{
	if !${${logFile}.Open}
	{
		${logFile}:Open
		${logFile}:Truncate
	}

	variable time Stamp

	Stamp:Set[${Time.Timestamp}]

	${logFile}:Write["${Stamp.Time24}: ${text}\r\n"]
	${logFile}:Flush
	
	if ${tee}
	{
		echo ${Stamp.Time24}: ${text}
	}
}

#endif
