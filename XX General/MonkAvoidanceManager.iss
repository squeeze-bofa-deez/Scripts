#include SpellCasting.iss
#include Log.iss
#include GetAbility.iss

variable uint   OutwardCalmID    = 0
variable string OutwardCalmBase  = "Outward Calm"
variable string OutwardCalmLevel = " IV"
variable string OutwardCalmFull  = "${OutwardCalmBase}${OutwardCalmLevel}"

variable uint   BodyLikeMountainID    = 0
variable string BodyLikeMountainBase  = "Body Like Mountain"
variable string BodyLikeMountainLevel = " VI"
variable string BodyLikeMountainFull  = "${BodyLikeMountainBase}${BodyLikeMountainLevel}"

variable uint   MountainStanceID    = 0
variable string MountainStanceBase  = "Mountain Stance"
variable string MountainStanceLevel = " V"
variable string MountainStanceFull  = "${MountainStanceBase}${MountainStanceLevel}"

variable uint   MendID    = 0
variable string MendBase  = "Mend"
variable string MendLevel = " V"
variable string MendFull  = "${MendBase}${MendLevel}"

variable uint   BobAndWeaveID      = 0
variable string BobAndWeaveBase    = "Bob And Weave"
variable string BobAndWeaveLevel   = ""
variable string BobAndWeaveFull    = "${BobAndWeaveBase}${BobAndWeaveLevel}"

variable uint   TsunamiID    = 0
variable string TsunamiBase  = "Tsunami"
variable string TsunamiLevel = ""
variable string TsunamiFull  = "${TsunamiBase}${TsunamiLevel}"

variable uint   SuperiorGuardID    = 0
variable string SuperiorGuardBase  = "Superior Guard"
variable string SuperiorGuardLevel = ""
variable string SuperiorGuardFull  = "${SuperiorGuardBase}${SuperiorGuardLevel}"

variable uint   InnerFocusID    = 0
variable string InnerFocusBase  = "Inner Focus"
variable string InnerFocusLevel = ""
variable string InnerFocusFull  = "${InnerFocusBase}${InnerFocusLevel}"

variable uint   ProvokingStanceID    = 0
variable string ProvokingStanceBase  = "Provoking Stance"
variable string ProvokingStanceLevel = ""
variable string ProvokingStanceFull  = "${ProvokingStanceBase}${ProvokingStanceLevel}"

variable uint   BrawlersTenacityID    = 0
variable string BrawlersTenacityBase  = "Brawler's Tenacity"
variable string BrawlersTenacityLevel = ""
variable string BrawlersTenacityFull  = "${BrawlersTenacityBase}${BrawlersTenacityLevel}"

variable bool MountainStanceIsDown
variable bool BodyLikeMountainIsDown
variable bool TsunamiIsDown
variable bool BobAndWeaveIsDown
variable bool SuperiorGuardIsDown
variable bool InnerFocusIsDown
variable bool ProvokingStanceIsDown
variable bool BrawlersTenacityIsDown

variable float LowHealthThreshold = 0.7

function UpdateSpellStates()
{
	MountainStanceIsDown:Set[!${Me.Maintained[${MountainStanceFull}](exists)} || (${Me.Maintained[${MountainStanceFull}](exists)} && ${Me.Maintained[${MountainStanceFull}].Duration} <= 3.0)]
	BodyLikeMountainIsDown:Set[!${Me.Maintained[${BodyLikeMountainFull}](exists)} || (${Me.Maintained[${BodyLikeMountainFull}](exists)} && ${Me.Maintained[${BodyLikeMountainFull}].Duration} <= 3.0)]
	TsunamiIsDown:Set[!${Me.Maintained[${TsunamiFull}](exists)} || (${Me.Maintained[${TsunamiFull}](exists)} && ${Me.Maintained[${TsunamiFull}].Duration} <= 3.0)]
	BobAndWeaveIsDown:Set[!${Me.Maintained[${BobAndWeaveFull}](exists)} || (${Me.Maintained[${BobAndWeaveFull}](exists)} && ${Me.Maintained[${BobAndWeaveFull}].Duration} <= 3.0)]
	SuperiorGuardIsDown:Set[!${Me.Maintained[${SuperiorGuardFull}](exists)} || (${Me.Maintained[${SuperiorGuardFull}](exists)} && ${Me.Maintained[${SuperiorGuardFull}].Duration} <= 3.0)]
	InnerFocusIsDown:Set[!${Me.Maintained[${InnerFocusFull}](exists)} || (${Me.Maintained[${InnerFocusFull}](exists)} && ${Me.Maintained[${InnerFocusFull}].Duration} <= 3.0)]
	ProvokingStanceIsDown:Set[!${Me.Maintained[${ProvokingStanceFull}](exists)} || (${Me.Maintained[${ProvokingStanceFull}](exists)} && ${Me.Maintained[${ProvokingStanceFull}].Duration} <= 3.0)]
	BrawlersTenacityIsDown:Set[!${Me.Maintained[${BrawlersTenacityFull}](exists)} || (${Me.Maintained[${BrawlersTenacityFull}](exists)} && ${Me.Maintained[${BrawlersTenacityFull}].Duration} <= 3.0)]
}

function CastMaintainedSpell(uint SpellID, string SpellBaseName, string SpellLevel="")
{
	variable string SpellFullName

	SpellFullName:Set["${SpellBaseName}${SpellLevel}"]

	if ${Me.Ability[id,${SpellID}].IsReady} && (!${Me.Maintained[${SpellFullName}](exists)} || (${Me.Maintained[${SpellFullName}](exists)} && ${Me.Maintained[${SpellFullName}].Duration} <= 3.0))
	{
		call Log "Casting ${SpellFullName}"

		;Me.Ability[id,${SpellID}]:Use

		;relay all OgreBotAtom a_CastFromUplink ${Me.Name} "${SpellBaseName}" TRUE

		call CastSpellNow ${Me.Name} "${SpellBaseName}"

		wait 20 ${Me.Maintained[${SpellFullName}](exists)}

		if !${Me.Maintained[${SpellFullName}](exists)}
		{
			call Log "Timed out waiting on maintained effect for ${SpellFullName} to appear"
		}
	}
}

function CastSpell(uint SpellID, string SpellBaseName, string SpellLevel="")
{
	variable string SpellFullName

	SpellFullName:Set["${SpellBaseName}${SpellLevel}"]

	if ${Me.Ability[id,${SpellID}].IsReady}
	{
		call Log "Casting ${SpellFullName}"

		call CastSpellNow ${Me.Name} "${SpellBaseName}"
	}
}

function main(bool CastBrawlersTenacity=TRUE, bool CastBodyLikeMountain=TRUE)
{
	call Log "Entering MonkAvoidanceManager"

	if ${CastBrawlersTenacity}
	{
		call Log "You will automatically cast Brawler's Tenacity when all your avoidance buffs are down"
	}
	else
	{
		call Log "You have elected to cast Brawler's Tenacity yourself"
	}

	if ${CastBodyLikeMountain}
	{
		call Log "You will automatically cast Body Like Mountain when needed"
	}
	else
	{
		call Log "You have elected to cast Body Like Mountain yourself"
	}

	call GetAbility "${OutwardCalmFull}"

	OutwardCalmID:Set[${Return}]

	call Log "OutwardCalmID=${OutwardCalmID}"

	call GetAbility "${BodyLikeMountainFull}"

	BodyLikeMountainID:Set[${Return}]

	call Log "BodyLikeMountainID=${BodyLikeMountainID}"

	call GetAbility "${MountainStanceFull}"

	MountainStanceID:Set[${Return}]

	call Log "MountainStanceID=${MountainStanceID}"

	call GetAbility "${MendFull}"

	MendID:Set[${Return}]

	call Log "MendID=${MendID}"

	call GetAbility "${BobAndWeaveFull}"

	BobAndWeaveID:Set[${Return}]

	call Log "BobAndWeaveID=${BobAndWeaveID}"

	call GetAbility "${TsunamiFull}"

	TsunamiID:Set[${Return}]

	call Log "TsunamiID=${TsunamiID}"

	call GetAbility "${SuperiorGuardFull}"

	SuperiorGuardID:Set[${Return}]

	call Log "SuperiorGuardID=${SuperiorGuardID}"

	call GetAbility "${InnerFocusFull}"

	InnerFocusID:Set[${Return}]

	call Log "InnerFocusID=${InnerFocusID}"

	call GetAbility "${ProvokingStanceFull}"

	ProvokingStanceID:Set[${Return}]

	call Log "ProvokingStanceID=${ProvokingStanceID}"

	call GetAbility "${BrawlersTenacityFull}"

	BrawlersTenacityID:Set[${Return}]

	call Log "BrawlersTenacityID=${BrawlersTenacityID}"

	do
	{
		if ${Me.InCombat}
		{
			call UpdateSpellStates

			if ${BrawlersTenacityIsDown}
			{
				call CastMaintainedSpell ${OutwardCalmID} "${OutwardCalmBase}" "${OutwardCalmLevel}"

				call UpdateSpellStates

				if ${BobAndWeaveIsDown} && ${InnerFocusIsDown} && ${SuperiorGuardIsDown}
				{
					call CastMaintainedSpell ${TsunamiID} "${TsunamiBase}" "${TsunamiLevel}"
				}

				call UpdateSpellStates

				if ${TsunamiIsDown} && ${InnerFocusIsDown} && ${SuperiorGuardIsDown}
				{
					call CastMaintainedSpell ${BobAndWeaveID} "${BobAndWeaveFull}" "${BobAndWeaveLevel}"
				}

				call UpdateSpellStates

				if ${BobAndWeaveIsDown} && ${TsunamiIsDown} && ${SuperiorGuardIsDown}
				{
					call CastMaintainedSpell ${InnerFocusID} "${InnerFocusBase}" "${InnerFocusLevel}"
				}

				call UpdateSpellStates

				if ${BobAndWeaveIsDown} && ${TsunamiIsDown} && ${InnerFocusIsDown}
				{
					call CastMaintainedSpell ${SuperiorGuardID} "${SuperiorGuardBase}" "${SuperiorGuardLevel}"
				}

				call UpdateSpellStates

				if ${BobAndWeaveIsDown} && ${TsunamiIsDown} && ${InnerFocusIsDown} && ${SuperiorGuardIsDown}
				{
					if ${Math.Calc[${Me.Health}/${Me.MaxHealth}]} <= ${LowHealthThreshold} || (${BodyLikeMountainIsDown} && ${ProvokingStanceIsDown})
					{
						call CastMaintainedSpell ${MountainStanceID} "${MountainStanceBase}" "${MountainStanceLevel}"
					}
				}

				if ${CastBodyLikeMountain}
				{
					call UpdateSpellStates

					if ${BobAndWeaveIsDown} && ${TsunamiIsDown} && ${InnerFocusIsDown}  && ${SuperiorGuardIsDown}
					{
						if ${Math.Calc[${Me.Health}/${Me.MaxHealth}]} <= ${LowHealthThreshold} || (${MountainStanceIsDown} && ${ProvokingStanceIsDown})
						{
							call CastMaintainedSpell ${BodyLikeMountainID} "${BodyLikeMountainBase}" "${BodyLikeMountainLevel}"
						}
					}
				}

				call UpdateSpellStates

				if ${BobAndWeaveIsDown} && ${TsunamiIsDown} && ${InnerFocusIsDown} && ${SuperiorGuardIsDown}
				{
						if ${Math.Calc[${Me.Health}/${Me.MaxHealth}]} <= ${LowHealthThreshold} || (${MountainStanceIsDown} && ${BodyLikeMountainIsDown})
						{
							call CastMaintainedSpell ${ProvokingStanceID} "${ProvokingStanceBase}" "${ProvokingStanceLevel}"
						}
				}

				if ${Math.Calc[${Me.Health}/${Me.MaxHealth}]} <= 0.5
				{
					call CastSpell ${MendID} "${MendBase}" "${MendLevel}"
				}

				if ${CastBrawlersTenacity}
				{
					call UpdateSpellStates

					if ${BobAndWeaveIsDown} && ${TsunamiIsDown} && ${InnerFocusIsDown} && ${SuperiorGuardIsDown}
					{
						if ${Math.Calc[${Me.Health}/${Me.MaxHealth}]} <= ${LowHealthThreshold} || (${MountainStanceIsDown} && ${BodyLikeMountainIsDown} && ${ProvokingStanceIsDown})
						{
							call CastMaintainedSpell ${BrawlersTenacityID} "${BrawlersTenacityBase}" "${BrawlersTenacityLevel}"
						}
					}
				}
			}
		}

		wait 10
	}
	while TRUE
}

atom atexit()
{
	call Log "Leaving MonkAvoidanceManager"
}