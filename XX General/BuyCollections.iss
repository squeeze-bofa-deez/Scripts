#include SyncItem.iss
#include TargetActor.iss
#include LogText.iss
#include ArgumentProcessor.iss

variable(global) string     g_defaultBroker = "Guild Hall World Market Broker"
variable(global) string		g_defaultCollector = "Guild Hall Collector"
variable(global) string     g_defaultLogFile = BuyCollections.txt
variable(global) float64ptr g_defaultSpendingLimit = 10000000.0
variable(global) float64ptr g_defaultPriceLimit  = 100000.0
variable(global) bool       g_defaultTurnIn = FALSE
variable(global) int        g_defaultStartPage = 1
variable(global) bool       g_defaultBuyTomes = FALSE

variable(global) string     g_broker = "${g_defaultBroker}"
variable(global) string		g_collector = "${g_defaultCollector}"
variable(global) file       g_logFile = "${g_defaultLogFile}"
variable(global) float64ptr g_spendingLimit = ${g_defaultSpendingLimit}
variable(global) float64ptr g_priceLimit  = ${g_defaultPriceLimit}
variable(global) bool       g_turnIn = ${g_defaultTurnIn}
variable(global) int        g_startPage = ${g_defaultStartPage}
variable(global) bool       g_buyTomes = ${g_defaultBuyTomes}

variable(global) bool       g_alreadyCollected = FALSE
variable(global) bool       g_examineOpen = FALSE
variable(global) string     g_windowID
variable(global) string     g_itemName
variable(global) int        g_itemID = 0
variable(global) int        g_currentPage = 0
variable(global) int        g_currentItem = 0
variable(global) float64ptr g_silverSpentOnCollectibles = 0.0
variable(global) int        g_collectiblesPurchased = 0
variable(global) bool       g_notEnoughCoin = FALSE
variable(global) int        g_restartScanAttempts = 0
 
function WaitForBrokerFocus()
{
	while !${EQ2UIPage[Inventory,Market].IsMouseOver}
	{
		waitframe
	}
}

function ExamineCollectible(string itemDS,bool reportProblems=TRUE)
{
	g_examineOpen:Set[FALSE]
	g_alreadyCollected:Set[TRUE]

	Event[EQ2_ExamineItemWindowAppeared]:AttachAtom[OnExamineItemWindowAppeared]

	wait 5

	;call LogText g_logFile "Examining item ${itemDS}"

	variable int ExamineAttempts

	ExamineAttempts:Set[0]

	while ${ExamineAttempts:Inc} < 2 && !${g_examineOpen}
	{
		${itemDS}:Examine

		wait 20 ${g_examineOpen}
	}

	if !${g_examineOpen}
	{
		if ${reportProblems}
		{
			call LogText g_logFile "Timed out waiting for examine window - make sure your mouse cursor is over the broker window."
		}
	}
	else
	{
		;call LogText g_logFile "${g_itemName} ${g_windowID}"

		if !${ExamineItemWindow[${g_windowID}](exists)}
		{
			if ${reportProblems}
			{
				call LogText g_logFile "ExamineWindow doesn't exist!"
			}
		}
		else
		{
			;call SyncItem "ExamineItemWindow[${g_windowID}].ToItem"

			;g_itemID:Set[${ExamineItemWindow[${g_windowID}].ToItem.ID}]

			;g_alreadyCollected:Set[${ExamineItemWindow[${g_windowID}].ToItem.AlreadyCollected}]

			if ${ExamineItemWindow[${g_windowID}].TextVector} < 2 || !${ExamineItemWindow[${g_windowID}].TextVector[2].Type.Equal[Text]} || ${ExamineItemWindow[${g_windowID}].TextVector[2].Label.Find[already collected]} == 0
			{
				g_alreadyCollected:Set[FALSE]
			}

			variable int CloseAttempts

			CloseAttempts:Set[0]

			while ${ExamineItemWindow[${g_windowID}](exists)} && ${CloseAttempts:Inc} < 10
			{
				EQ2Execute /close_top_window

				wait 5
			}

			if ${ExamineItemWindow[${g_windowID}](exists)}
			{
				call LogFile g_logFile "Timed out trying to close Examine window for \\\"${g_itemName}\\\""
			}
		}
	}

	Event[EQ2_ExamineItemWindowAppeared]:DetachAtom[OnExamineItemWindowAppeared]	
}

function GotoPage(int pageNumber)
{
	if ${pageNumber} <= 0
	{
		pageNumber:Set[1]
	}

	Vendor:GotoSearchPage[${pageNumber}]
			
	while ${Vendor.CurrentSearchPage} != ${pageNumber}
	{
		waitframe
	}

	wait 5

	g_currentItem:Set[0]
	g_currentPage:Set[${pageNumber}]
}

function DoCollectibleSearch(int CurrentPage = 0)
{
	broker Sort ByPriceAsc -type collectible 

	while ${Vendor.NumItemsForSale} == 0
	{
		waitframe
	}

	call GotoPage ${CurrentPage}
}

function AddToCollection(int ItemID)
{
	if ${ItemID} == 0
	{
		call LogText g_logFile "NULL ItemID ignored"

		return
	}

	variable string ItemDS

	ItemDS:Set["Me.Inventory[ID,${ItemID}]"]

	call SyncItem "${ItemDS}"

	variable string Name

	Name:Set["${${ItemDS}.Name}"]

	while TRUE
	{
		call FindElement "EQ2UIPage[Journals,JournalsQuest].Child[Page,TabPages.Collection.CollectionFrame.CollectionComposite].Child[Page,1]" "Button" "Add" 1

		if ${Return.Length} > 0
		{
			variable string AddButton

			AddButton:Set["${Return}"]

			call LogText g_logFile "Using Journal Add button to add \\\"${Name}\\\" to collection"

			${AddButton}:LeftClick

			wait 20
		}

		if !${${ItemDS}(exists)}
		{
			break
		}

		call LogText g_logFile "Item \\\"${Name}\\\" is still in inventory - checking if it is a duplicate"

		if ${${ItemDS}.AlreadyCollected}
		{
			break
		}

		call LogText g_logFile "Item \\\"${Name}\\\" is still in inventory and is collectable - trying to add it manually"

		call ExamineCollectible "${ItemDS}" FALSE
	}
}

function TakeReward()
{
	variable bool RewardTaken

	RewardTaken:Set[FALSE]

	while TRUE
	{
		call LogText g_logFile "Trying to take reward"

		wait 20 ${RewardWindow(exists)}

		if !${RewardWindow(exists)}
		{
			;call LogText g_logFile "Timed out waiting for award window to appear"
			break
		}

		call LogWidgets g_logFile "RewardWindow.ToEQ2UIPage.Child[Page,RewardPack]"

		call FindElement "RewardWindow.ToEQ2UIPage.Child[Page,RewardPack]" "Button" "Accept" 1

		if ${Return.Length} > 0
		{
			variable string AcceptButton1

			AcceptButton1:Set["${Return}"]

			call LogText g_logFile "No reward selection required"

			call LogText g_logFile" Clicking ${AcceptButton1}"

			${AcceptButton1}:LeftClick

			RewardTaken:Set[TRUE]

			continue
		}

		call FindElement "RewardWindow.ToEQ2UIPage.Child[Page,RewardPack]" "Button" "Select" 1

		if ${Return.Length} == 0
		{
			call LogText g_logFile "Unknown reward button encountered"

			RewardWindow:Receive

			continue
		}

		call LogText g_logFile Select button found - "${Return}"

		call LogText g_logFile "Need to select a reward"

		variable int  whichReward
		variable bool SelectedReward

		whichReward:Set[1]
		SelectedReward:Set[FALSE]

		do
		{
			call LogText g_logFile "Trying to select reward ${whichReward}"

			call FindElement "RewardWindow.ToEQ2UIPage.Child[Page,RewardPack]" "Icon" "" "${whichReward}"

			if ${Return.Length} == 0
			{
				break
			}

			variable string RewardButton

			RewardButton:Set["${Return}"]

			call LogText g_logFile "Clicking reward \\\"${RewardButton}\\\""

	;		${RewardButton}:LeftClick

			wait 10

			call FindElement "RewardWindow.ToEQ2UIPage.Child[Page,RewardPack]" "Button" "Accept" 1

			if ${Return.Length} > 0
			{
				variable string AcceptButton2

				AcceptButton2:Set["${Return}"]

				call LogText g_logFile "Successfully selected a reward :)"

				call LogText g_logFile "Clicking ${AcceptButton2}"

				${AcceptButton2}:LeftClick

				SelectedReward:Set[TRUE]

				break
			}
			else
			{
				call LogText g_logFile "Was unable to select reward ${whichReward}"
			}

			whichReward:Inc
		}
		while TRUE

		if ${SelectedReward}
		{
			RewardTaken:Set[TRUE]
		}
		else
		{
			call LogText g_logFile "Was unable to take a selectable reward"

			RewardWindow:Receive
		}
	}

	if !${RewardTaken}
	{
		call LogText g_logFile "Was unable to take any reward"
	}

	return ${RewardTaken}
}

function TurnInCollection(string CollectorID)
{
	variable bool RewardTaken

	RewardTaken:Set[FALSE]

	call FindElement "EQ2UIPage[Journals,JournalsQuest].Child[Page,TabPages.Collection.CollectionFrame.CollectionComposite].Child[Page,1]" "Text" "(Ready to Turn In) Level" 1

	if ${Return.Length} > 0
	{
		call TargetActor ${CollectorID} TRUE TRUE

		EQ2Execute /hail

		wait 10

		;variable int ReplyIndex
		;variable int ReplyCount

		;ReplyIndex:Set[0]
		;ReplyCount:Set[${EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].NumChildren}]

		;while ${ReplyIndex:Inc} <= ${ReplyCount}
		;{
			;call LogText g_logFile "${EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,${ReplyIndex}].Label}"
		;}

		if ${EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2].Label.Equal["I have a collection for you."]}
		{
			call LogText g_logFile "** Turning in a collection **"

			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick

			call TakeReward

			RewardTaken:Set[${Return}]

			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
		}
		else
		{
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
		}
	}

	return ${RewardTaken}
}

function RestartBrokerScan()
{
	if ${g_restartScanAttempts:Inc} > 1
	{
		call LogText g_logFile "** Ending script because not enough silver remains to purchase needed collectibles **"

		Script:End
	}

	call LogText g_logFile "** Starting over at beginning because all futher collectibles will be too expensive **"

	call DoCollectibleSearch 1
}

objectdef BuyCollectionsArgumentProcessor inherits ArgumentProcessor
{
	method ProcessArg(string Option,string Value)
	{
		if ${Option.Equal["broker_npc"]}
		{
			if ${Value.Length} == 0
			{
				Value:Set["${g_defaultBroker}"]
			}

			g_broker:Set["${Value}"]
		}
		elseif ${Option.Equal["collection_npc"]}
		{
			if ${Value.Length} == 0
			{
				Value:Set["${g_defaultCollector}"]
			}

			g_collector:Set["${Value}"]
		}
		elseif ${Option.Equal["log_file"]}
		{
			if ${Value.Length} == 0
			{
				Value:Set["${g_defaultLogFile}"]
			}

			g_logFile:Set["${Value}"]
		}
		elseif ${Option.Equal["spending_limit"]}
		{
			if ${Value.Length} == 0
			{
				Value:Set["${g_defaultSpendingLimit}"]
			}

			g_spendingLimit:Set[${Value}]
		}
		elseif ${Option.Equal["price_limit"]}
		{
			if ${Value.Length} == 0
			{
				Value:Set["${g_defaultPriceLimit}"]
			}

			g_priceLimit:Set[${Value}]
		}
		elseif ${Option.Equal["turn_in"]}
		{
			if ${Value.Length} == 0
			{
				Value:Set["${g_defaultTurnIn}"]
			}

			g_turnIn:Set[${Value}]
		}
		elseif ${Option.Equal["start_page"]}
		{
			if ${Value.Length} == 0
			{
				Value:Set["${g_defaultStartPage}"]
			}

			g_startPage:Set[${Value}]
		}
		elseif ${Option.Equal["buy_tomes"]}
		{
			if ${Value.Length} == 0
			{
				Value:Set["${g_defaultBuyTomes}"]
			}

			g_startPage:Set[${Value}]
		}
		else
		{
			echo Unrecognized command option \"${Option}\" was ignored
		}
	}
}

atom OnExamineItemWindowAppeared(string itemName, string windowID)
{
	g_itemName:Set["${itemName}"]
	g_windowID:Set[${windowID}]
	g_examineOpen:Set[TRUE]
}

atom OnIncomingText(string Message)
{
	if !${g_notEnoughCoin} && ${Message.Find["You do not have enough coin to purchase the item"](exists)}
	{
		g_notEnoughCoin:Set[TRUE]
	}
}

atom atexit()
{
	call LogText g_logFile "Leaving BuyCollections."

	call LogText g_logFile "Silver spent on collectibles: ${g_silverSpentOnCollectibles}"
	call LogText g_logFile "Total collectibles purchased: ${g_collectiblesPurchased}"

	g_logFile:Close
}

function main(... Args)
{
	variable BuyCollectionsArgumentProcessor MyArgumentProcessor

	MyArgumentProcessor:Process[${Args.ExpandComma}]

	call LogText g_logFile "Executing BuyCollections for ${Me.Name}"

	if ${g_turnIn}
	{
		call LogText g_logFile "You have opted to turn in collections as they are completed"

		if !${Actor[${g_collector}](exists)}
		{
			call LogText g_logFile "Collector NPC \\\"${g_collector}\\\" doesn't exist"

			return
		}

		variable int CollectorID

		CollectorID:Set[${Actor[${g_collector}].ID}]
	}
	else
	{
		call LogText g_logFile "You have opted to not turn in collections as they are completed"
	}
		
	if ${g_buyTomes}
	{
		call LogText g_logFile "You have opted to buy tome collectibles"
	}
	else
	{
		call LogText g_logFile "You have opted to not buy tome collectibles"
	}

	if !${Actor[${g_broker}](exists)}
	{
		call LogText g_logFile "Broker NPC \\\"${g_broker}\\\" doesn't exist"

		return
	}

	variable int BrokerID

	BrokerID:Set[${Actor[${g_broker}].ID}]

	ISXEQ2:ResetInternalVendingSystem

	call TargetActor ${BrokerID} TRUE TRUE

	Actor[${g_broker}]:DoubleClick

	variable float64ptr MySilverToSpend

	MySilverToSpend:Set[${Math.Calc[${Me.Platinum}*10000.0+${Me.Gold}*100.0+${Me.Silver}+${Me.Copper}/100.0]}]
	
	if ${MySilverToSpend} < ${g_spendingLimit}
	{
		call LogText g_logFile "FYI, the total silver in your bank, ${MySilverToSpend}, is less than the silver you have allocated to spend on collectibles (${g_spendingLimit})"
		call LogText g_logFile "Setting the silver to spend on collectibles to what you have in your bank"

		g_spendingLimit:Set[${MySilverToSpend}]
	}

	call LogText g_logFile "You have ${MySilverToSpend} total silver in your bank\\\; ${g_spendingLimit} silver has been allocated to spend on collectibles"
	call LogText g_logFile "The maximum silver you will spend on a single collectible is ${g_priceLimit}"

	Event[EQ2_onIncomingText]:AttachAtom[OnIncomingText]

	call DoCollectibleSearch ${g_startPage}

	g_currentPage:Dec

	while ${g_currentPage:Inc} <= ${Vendor.TotalSearchPages}
	{
		call GotoPage ${g_currentPage}

		while ${g_currentItem:Inc} <= ${Vendor.NumItemsForSale}
		{
			variable string VendorItem

			VendorItem:Set["Vendor.Item[${g_currentItem}]"]

			call ExamineCollectible "${VendorItem}"

			variable string     Name
			variable float64ptr Price

			Name:Set["${${VendorItem}.Name}"]
			Price:Set[${${VendorItem}.Price}]
			;call LogText g_logFile "Examining \\\"${Name}\\\" ${Level} ${Price}"

			if ${g_alreadyCollected}
			{
				if ${Price} > ${g_spendingLimit}
				{
					call LogText g_logFile "** Price of \\\"${Name}\\\" (${Price}) exceeds the silver left to spend on collectibles (${g_spendingLimit}) **"

					call RestartBrokerScan

					continue
				}

				if ${Price} > ${g_priceLimit}
				{
					call LogText g_logFile "** Price of \\\"${Name}\\\" (${Price}) exceeds the silver price limit (${g_priceLimit}) **"

					call RestartBrokerScan
				}
			}
			else
			{
				;call LogText g_logFile "** Need \\\"${Name}\\\" (${g_currentPage},${g_currentItem}) **"

				if !${g_buyTomes} && ${Name.Find[" Page "]} != 0
				{
					call LogText g_logFile "** Not buying \\\"${Name}\\\" because you have elected to not buy tome collectibles **"

					continue
				}

				if ${Level} < ${g_minLevel} || ${Level} >  ${g_maxLevel}
				{
					call LogText g_logFile "** Not buying \\\"${Name}\\\" because its level is not between ${g_minLevel} and ${g_maxLevel} **"

					continue
				}

				if ${Price} > ${g_priceLimit}
				{
					call LogText g_logFile "** Not buying \\\"${Name}\\\" because its price (${Price}) exceeds the silver price limit (${g_priceLimit}) **"

					call RestartBrokerScan

					continue
				}

				if ${Price} > ${g_spendingLimit}
				{
					call LogText g_logFile "** Not buying \\\"${Name}\\\" because its price (${Price}) exceeds the silver left to spend on collectibles (${g_spendingLimit}) **"

					call RestartBrokerScan

					continue
				}

				call LogText g_logFile "** Buying \\\"${Name}\\\" for ${Price} silver on Page ${g_currentPage}**"

				g_notEnoughCoin:Set[FALSE]

				${VendorItem}:Buy

				call LogText g_logFile "** Waiting for \\\"${Name}\\\" to show up in inventory **"

				while !${g_notEnoughCoin}
				{
					Me:CreateCustomInventoryArray[nonbankonly]

					variable int ItemID

					ItemID:Set[${Me.CustomInventory[${Name}].ID}]

					if ${ItemID} != 0
					{
						break
					}

					wait 20
				}

				if ${g_notEnoughCoin}
				{
					call LogText g_logFile "** Not buying \\\"${Name}\\\" because broker is telling us we don't have enough coin **"

					call RestartBrokerScan

					continue
				}

				g_spendingLimit:Set[${Math.Calc[${g_spendingLimit}-${Price}]}]
				g_silverSpentOnCollectibles:Set[${Math.Calc[${g_silverSpentOnCollectibles}+${Price}]}]
				g_collectiblesPurchased:Inc
				g_restartScanAttempts:Set[0]

				;call LogText g_logFile "** You have ${g_spendingLimit} silver left to spend on collectibles **"

				call LogText g_logFile "** \\\"${Name}\\\" is now in inventory - attempting to add it to its collection **"

				call AddToCollection ${ItemID} FALSE

				if ${g_turnIn}
				{
					call TurnInCollection ${CollectorID}

					variable bool CheckInventory

					CheckInventory:Set[${Return}]

					while ${CheckInventory}
					{
						call LogText g_logFile "** Turned a collection in - check for collectible rewards in inventory **"

						Me:CreateCustomInventoryArray[nonbankonly]

						variable int CustomInventoryIndex

						CustomInventoryIndex:Set[0]
						CheckInventory:Set[FALSE]

						while ${CustomInventoryIndex:Inc} <= ${Me.CustomInventoryArraySize}
						{
							variable string ItemDS

							ItemDS:Set["Me.CustomInventory[${CustomInventoryIndex}]"]

							;call LogText g_logFile "Checking \\\"${${ItemDS}.Name}\\\": IsCollectible=${${ItemDS}.IsCollectible}, AlreadyCollected=${${ItemDS}.AlreadyCollected}"

							if ${${ItemDS}.IsCollectible} && !${${ItemDS}.AlreadyCollected}
							{
								call AddToCollection ${${ItemDS}.ID} FALSE

								call TurnInCollection ${CollectorID}

								if ${Return}
								{
									CheckInventory:Set[TRUE]
								}
							}
						}
					}

					call TargetActor ${BrokerID} TRUE TRUE
				}
			}
		}
	}
}

