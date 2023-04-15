#ifndef TargetActor_i
#define TargetActor_i

function TargetActor(int actorId,bool faceMob=FALSE,bool waitUntilTargetted=FALSE)
{
	;echo Targeting ${Actor[${actorId}].Name} (${actorId})

	do
	{
		Actor[${actorId}]:DoTarget

		wait 5
	}
	while ${waitUntilTargetted} && ${Actor[${actorId}](exists)} && ${Me.ToActor.Target.ID} != ${actorId}

	if ${faceMob} && ${Actor[${actorId}](exists)}
	{
		Actor[${actorId}]:DoFace
	}
}

#endif