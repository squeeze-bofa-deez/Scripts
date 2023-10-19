;==========================================
;   Title: Joust for Chat Event
;  Author: The Marty Party
;    Date: 24 Apr 2022
; Version: 1.0
;==========================================

function main()
{
    OgreBotAPI:JoustOut["all"]
    call refresh
}

function refresh()
{
	TargetDist:Set[${Math.Calc[${Target.Distance}-(${Actor[${Target.ID}].CollisionRadius}*${Actor[${Target.ID}].CollisionScale}+${Me.CollisionRadius}*${Me.CollisionScale})]}]
	TargetTargetDist:Set[${Math.Calc[${Target.Target.Distance}-(${Actor[${Target.Target.ID}].CollisionRadius}*${Actor[${Target.Target.ID}].CollisionScale}+${Me.CollisionRadius}*${Me.CollisionScale})]}]
}