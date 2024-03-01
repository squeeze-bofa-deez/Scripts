

;KramJump v1.0 (by Kram)
;_________________________________________________________________________________________
;DESCRIPTION:
;Yes, KramJump is finally here.
;For those of you who are sick of jumping off cliffs yourself
;For the children who can't stand trying to skill up safe fall since the LU that screwed it up
;_________________________________________________________________________________________
;USAGE:
;0. Download and store the kramjump.iss file in your scripts folder
;1. Go to a cliff that you can jump off and walk back down.
;2. Face the direction you wish to jump
;3. Open the ISXEQ2 console window (press `) type "run kramjump" and press enter
;4. Relax and enjoy the show.
;
;Your character will simply walk forward about 1 second then turn, run back up the hill and 
;start jumping. If your guy doesn't make it back up the hill to where he started, pick a new spot
;_________________________________________________________________________________________
;TIPS:
;Only hard part is finding a good palce to jump from. The place I used was right off
;the CL docks at the loc -1054, -600, just face the ocean and go.
;
;You'll stop jumping if your hp is under 60%
;
;Helps if you use a mount of run speed of some time.
;
;Use caution, you'll die if you jump too far. You knew that, what kind of tips are these?


#include ${LavishScript.HomeDirectory}/Scripts/moveto.iss

function main()
	{
		declare kJumps int script
		declare kJumpX float script
		declare kJumpZ float script
		declare kHeadingX float script
		declare kHeadingZ float script

		kJumpX:Set[${Me.X}]
		kJumpZ:Set[${Me.Z}]
		
	
		;figure out what direction to jump by grabbing the loc a few steps ahead of the current loc
		press -hold MOVEFORWARD
		wait 10
		press MOVEFORWARD
		
		kHeadingX:Set[${Me.X}]
		kHeadingZ:Set[${Me.Z}]
		echo Gathering Jump Locs ${kHeadingX}, ${kHeadingZ}
		
		eq2echo Starting KramJump v1.0

		do
			{
			;echo Move to jump point		
			call moveto ${kJumpX}, ${kJumpZ}, 4
						
			;echo face cliff
			face ${kHeadingX}, ${kHeadingZ}
			
			;echo check health
			if ${Me.ToActor.Health}>60
			{			
				;echo Jump
				press SPACE
				
				;echo Move Foward
				press -hold MOVEFORWARD
			
					wait 5
			
				;echo press forward to break previous movement
				press MOVEFORWARD
				
				kJumps:Set[${kJumps}+1]
				eq2echo Jumps: ${kJumps}
				
				;echo wait 20 and start again
				wait 20
			}
			
			Do
			{
				ExecuteQueued
			}
			While ${QueuedCommands}
			
			}
			while 0<1
	}