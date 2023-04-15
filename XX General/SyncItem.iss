#ifndef SyncItem_i
#define SyncItem_i

function SyncItem(string itemDS)
{
	;echo Syncing Item ${itemDS}

	if ${${itemDS}(exists)}
	{
		if !${${itemDS}.IsInitialized}
		{
			${itemDS}:Initialize

			do
			{
				wait 50 ${${itemDS}.IsInitialized}
			}
			while !${${itemDS}.IsInitialized}
		}
	}
}

#endif