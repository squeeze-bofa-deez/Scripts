;==========================================
;   Title: Assassin Concealment Script
;  Author: The Marty Party
;    Date: 18 Oct 2023
; Version: 1.0
;==========================================

;;; This script is intended to be ran as a runscript via the announce tab, attached to concealment. 
;;; Do not have the following CAs in your cast stack: Masked Strike, Mortal Blade, Eviscerate, Jugular Strike, Assassinate, Fatal Followup.
;;; Do have the following in your cast stack: Concealment.
;;; Add in any buffs/CAs that are missing from CAOn and CAOff.

function main()
{
	eq2execute autoattack 0
	call CAOff
	wait 5
	OgreBotAPI:CastAbility[${Me.Name},"Masked Strike"]
	wait 5
	OgreBotAPI:CastAbility[${Me.Name},"Mortal Blade"]
	wait 5
	OgreBotAPI:CastAbility[${Me.Name},"Eviscerate"]
	wait 5
	OgreBotAPI:CastAbility[${Me.Name},"Jugular Slice"]
	wait 5
	OgreBotAPI:CastAbility[${Me.Name},"Mortal Blade"]
	Wait 5
	OgreBotAPI:CastAbility[${Me.Name},"Assassinate"]
	wait 5
	OgreBotAPI:CastAbility[${Me.Name},"Fatal Followup"]
	wait 25
	Call CAOn
	eq2execute autoattack 1
	end Concealment.iss
}
	
function CAOn()
{
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Deadly Shot"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Quick Strike"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Spine Shot"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Crippling Strike"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Improvised Weapon"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Massacre"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Paralyzing Strike"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Death Mark"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Masked Strike"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Ambush"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Death Blow"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Gushing Wound"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Head Shot"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Impale"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Stealth Assault"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Stalk"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Caltrops"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Hilt Strike"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Honed Reflexes"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Exacting"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Deadly Focus"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Evade"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Placating Strike"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Smoke Bomb"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Frontload"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Torture"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Poison Combination"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Bladed Opening"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Point Blank Shot"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Murderous Design"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Villainy"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Whirling Blades"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Apply Poison"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Getaway"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Spinning Spear"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Intoxication"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Impenetrable"  TRUE TRUE
}

function CAOff()
{	
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Deadly Shot"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Quick Strike"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Spine Shot"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Crippling Strike"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Improvised Weapon"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Massacre"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Paralyzing Strike"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Death Mark"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Masked Strike"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Ambush"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Death Blow"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Gushing Wound"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Head Shot"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Impale"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Stealth Assault"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Stalk"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Caltrops"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Hilt Strike"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Honed Reflexes"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Exacting"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Deadly Focus"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Evade"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Placating Strike"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Smoke Bomb"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Frontload"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Torture"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Poison Combination"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Bladed Opening"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Point Blank Shot"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Murderous Design"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Villainy"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Whirling Blades"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Apply Poison"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Getaway"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Spinning Spear"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Intoxication"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Impenetrable"  FALSE TRUE
}
