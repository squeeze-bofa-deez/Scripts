
function main()
{
	while ${Actor[namednpc,haraakat](exists)} && ${Actor[namednpc,haraakat].Target(exists)}
	{
		if ${Math.Distance[${Me.X},${Me.Y},${Me.Z},-143.19,-57.56,-311.12]} > 4
		{
			call ReturnToPortal
		}
		else
		{
			wait 5
		}
	}
}

function ReturnToPortal()
{
	if ${Me.Y} < -50
	{
	}
	if ${Me.X} > -136 && ${Me.X} < -120 && ${Me.Y} > -15 && ${Me.Y} < 0 && ${Me.Z} > -391 && ${Me.Z} < -374
	{
		eq2ex target_none
		wait 5
		call CampSpotMoveTo ${Me.Name} -127.00 -15.00 -370.96
		call CampSpotMoveTo ${Me.Name} -118.16 -15.00 -357.16
		call CampSpotMoveTo ${Me.Name} -143.19 -57.56 -311.12
		wait 20
		return
	}
	if ${Me.X} > -153 && ${Me.X} < -136 && ${Me.Y} > -15 && ${Me.Y} < 0 && ${Me.Z} > -391 && ${Me.Z} < -374
	{
		eq2ex target_none
		wait 5
		call CampSpotMoveTo ${Me.Name} -149.52 -15.00 -370.48
		call CampSpotMoveTo ${Me.Name} -155.24 -19.23 -359.05
		call CampSpotMoveTo ${Me.Name} -143.19 -57.56 -311.12
		wait 20
		return
	}
	if ${Me.X} > -78 && ${Me.X} < -61 && ${Me.Y} > -15 && ${Me.Y} < 0 && ${Me.Z} > -331 && ${Me.Z} < -315
	{
		eq2ex target_none
		wait 5
		call CampSpotMoveTo ${Me.Name} -80.80 -15.00 -327.60
		call CampSpotMoveTo ${Me.Name} -93.53 -15.00 -333.88
		call CampSpotMoveTo ${Me.Name} -143.19 -57.56 -311.12
		wait 20
		return
	}
	if ${Me.X} > -78 && ${Me.X} < -61 && ${Me.Y} > -15 && ${Me.Y} < 0 && ${Me.Z} > -315 && ${Me.Z} < -298
	{
		eq2ex target_none
		wait 5
		call CampSpotMoveTo ${Me.Name} -68.62 -15.00 -316.65
		call CampSpotMoveTo ${Me.Name} -80.80 -15.00 -327.60
		call CampSpotMoveTo ${Me.Name} -93.53 -15.00 -333.88
		call CampSpotMoveTo ${Me.Name} -143.19 -57.56 -311.12
		wait 20
		return
	}
	if ${Me.X} > -197 && ${Me.X} < -177 && ${Me.Y} > -52 && ${Me.Y} < -39 && ${Me.Z} > -344 && ${Me.Z} < -314
	{
		eq2ex target_none
		wait 5
		call CampSpotMoveTo ${Me.Name} -164.73 -60.00 -327.83
		call CampSpotMoveTo ${Me.Name} -143.19 -57.56 -311.12
		wait 20
		return
	}
	if ${Me.X} > -187 && ${Me.X} < -149 && ${Me.Y} > -42 && ${Me.Y} < -15 && ${Me.Z} > -370 && ${Me.Z} < -338
	{
		eq2ex target_none
		wait 5
		call CampSpotMoveTo ${Me.Name} -143.19 -57.56 -311.12
		wait 20
		return
	}
	if ${Me.X} > -152 && ${Me.X} < -136 && ${Me.Y} > -17 && ${Me.Y} < -13 && ${Me.Z} > -390 && ${Me.Z} < -358
	{
		eq2ex target_none
		wait 5
		call CampSpotMoveTo ${Me.Name} -152.20 -16.63 -360.30
		call CampSpotMoveTo ${Me.Name} -143.19 -57.56 -311.12
		wait 20
		return
	}
	if ${Me.X} > -138 && ${Me.X} < -120 && ${Me.Y} > -15 && ${Me.Y} < 0 && ${Me.Z} > -388 && ${Me.Z} < -359
	{
		eq2ex target_none
		wait 5
		call CampSpotMoveTo ${Me.Name} -127.31 -15.00 -370.02
		call CampSpotMoveTo ${Me.Name} -120.89 -15.00 -360.38
		call CampSpotMoveTo ${Me.Name} -128.46 -60.00 -336.33
		call CampSpotMoveTo ${Me.Name} -143.19 -57.56 -311.12
		wait 20
		return
	}
	if ${Me.X} > -124 && ${Me.X} < -81 && ${Me.Y} > -15 && ${Me.Y} < 0 && ${Me.Z} > -369 && ${Me.Z} < -326
	{
		eq2ex target_none
		wait 5
		call CampSpotMoveTo ${Me.Name} -128.46 -60.00 -336.33
		call CampSpotMoveTo ${Me.Name} -143.19 -57.56 -311.12
		wait 20
		return
	}
	if ${Me.X} > -92 && ${Me.X} < -61 && ${Me.Y} > -15 && ${Me.Y} < 0 && ${Me.Z} > -330 && ${Me.Z} < -298
	{
		eq2ex target_none
		wait 5
		call CampSpotMoveTo ${Me.Name} -128.46 -60.00 -336.33
		call CampSpotMoveTo ${Me.Name} -143.19 -57.56 -311.12
		wait 20
		return
	}
	wait 5
	call CampSpotAt ${Me.Name} -143.19 -57.56 -311.12
}

function CampSpotMoveTo(string forWho, int x, int y, int z, bool exitIfDead)
{
	call CampSpotAt ${forWho} ${x} ${y} ${z}
	while ${Math.Distance[${Me.X},${Me.Z},${x},${z}]} > 4 && !${Me.IsDead}
	{
		waitframe
	}
}

function CampSpotAt(string who, int x, int y, int z)
{
	oc !ci -CampSpot ${who}
	oc !ci -ChangeCampSpotWho ${who} ${x} ${y} ${z}
}