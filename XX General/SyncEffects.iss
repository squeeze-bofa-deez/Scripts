#ifndef SyncEffects_i
#define SyncEffects_i

function SyncEffects(string Toon="Me")
{
	${Toon}:InitializeEffects

	while ${${Toon}.InitializingEffects}
	{
		wait 100 !${${Toon}.InitializingEffects}
	}
}

#endif