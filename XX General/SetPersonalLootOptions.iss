function main(string _option)
{
	;;;
	/*
	Purpose: To change your personal loot settings.
	Parameters for _option can be: None, All, Decline (Default = None)
	*/
	;;;
	
	variable int optionNumber = 0
	
	if ${_option.Equal["None"]} || ${_option.Equal[""]} || ${_option.Equal[NULL]}
	{
		_option:Set["ALNone"]
		optionNumber:Set[0]
	}	
	if ${_option.Equal["All"]}
	{
		_option:Set["ALGreedOrAccept"]
		optionNumber:Set[1]
	}	
	if ${_option.Equal["Decline"]}
	{
		_option:Set["ALDecline"]	
		optionNumber:Set[2]
	}	
		
	if ${Me.Grouped} || ${Me.InRaid}
	{
		;//In order to interact with the EQ2 Group Options window, it must have been opened once.
		eq2execute groupoptions
		
		wait 5
		
		;//Set my EQ2 group option, Auto Loot Mode, to None
		if ${EQ2UIPage[popup,groupoptions].Child[DropDownBox,GroupOptions.PersonalPage.AutoLootCombo].GetProperty[LocalText].NotEqual[${_option}]}
		{
			EQ2UIPage[popup,groupoptions].Child[DropDownBox,GroupOptions.PersonalPage.AutoLootCombo]:Set[${optionNumber}]
		
			wait 5
			
			;//Press the apply button for the changes to take affect.
			EQ2UIPage[popup,groupoptions].Child[Button,GroupOptions.ApplyButton]:LeftClick
		}
		else
		{
			;//Press the cancel button because our auto loot options were already set to None.
			EQ2UIPage[popup,groupoptions].Child[Button,GroupOptions.CancelButton]:LeftClick
		}			
	}
}