#ifndef SpellCasting_i
#define SpellCasting_i

function CastSpellNow(string caster, string spell)
{
	relay all OgreBotAtom a_CastFromUplink ${caster} "${spell}" TRUE
}

function CastSpellQueued(string caster, string spell)
{
	relay all OgreBotAtom a_QueueCommand CastFromUplink ${caster} "${spell}"
}

function CastSpellOnNow(string caster, string spell, string onWho)
{
	relay all OgreBotAtom a_CastFromUplinkOnPlayer ${caster} "${spell}" ${onWho} TRUE
}

function CastSpellOnQueued(string caster, string spell, string onWho)
{
	relay all OgreBotAtom a_QueueCommand CastFromUplinkOnPlayer ${caster} "${spell}" ${onWho}
}

#endif