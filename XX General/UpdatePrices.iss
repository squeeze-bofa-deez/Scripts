#include SyncItem.iss
#include TargetActor.iss
#include LogText.iss
#include ArgumentProcessor.iss

variable(global) string     g_defaultBroker = "Guild Hall World Market Broker"
variable(global) float      g_defaultBrokerCommission=0.10
variable(global) string     g_defaultLogFile = UpdatePrices.txt
variable(global) string     g_defaultScanInterval = 36000
variable(global) float      g_defaultPriceAdjustment = 0.01
variable(global) float      g_defaultMaxAllowedReduction = 0.25
variable(global) float      g_defaultInitialPrice = 10000000.0

variable(global) string     g_broker = "${g_defaultBroker}"
variable(global) float      g_brokerCommission=${g_defaultBrokerCommission}
variable(global) file       g_logFile = "${g_defaultLogFile}"
variable(global) uint       g_scanInterval = ${g_defaultScanInterval}
variable(global) float      g_priceAdjustment  = ${g_defaultPriceAdjustment}
variable(global) float      g_maxAllowedReduction = ${g_defaultMaxAllowedReduction}
variable(global) float      g_initialPrice = ${g_defaultInitialPrice}

variable(global) bool       g_examineOpen = FALSE
variable(global) string     g_windowID
variable(global) string     g_itemName
variable(global) uint       g_itemID = 0
variable(global) string     g_itemTier
variable(global) string     g_itemType
variable(global) int        g_itemLevel
variable(global) string     g_itemSlots
variable(global) string     g_itemClasses
variable(global) uint       g_currentPage = 0
variable(global) uint       g_currentItem = 0
variable(global) uint       g_consignmentsUpdated = 0
 
variable collection:string  g_unupdatedItems

function WaitForBrokerFocus()
{
	call LogText g_logFile "UpdatePrices is waiting for Mouse pointer to be positioned over the Broker window"

	while TRUE
	{
		wait 20 ${EQ2UIPage[Inventory,Market].IsMouseOver}

		if ${EQ2UIPage[Inventory,Market].IsMouseOver}
		{
			call LogText g_logFile "Mouse pointer is over Broker window - UpdatePrices is continuing"

			break
		}

		call LogText g_logFile "UpdatePrices cannot continue until you position the Mouse pointer over the Broker window"
	}
}

function DumpItemModifiers(string ItemDS)
{
	if ${${ItemDS}.NumModifiers} > 0
	{
		call LogText g_logFile "ItemModifiers for Item \\\"${${ItemDS}.Name}\\\""

		variable int ModifierIndex

		ModifierIndex:Set[0]

		while ${ModifierIndex:Inc} <=  ${${ItemDS}.NumModifiers}
		{
			call LogText g_logFile "Type[${ModifierIndex}]:    ${${ItemDS}.Modifier[${ModifierIndex}].Type}"
			call LogText g_logFile "SubType[${ModifierIndex}]: ${${ItemDS}.Modifier[${ModifierIndex}].SubType}"
			call LogText g_logFile "Value[${ModifierIndex}]:   ${${ItemDS}.Modifier[${ModifierIndex}].Value}"
		}
	}
}

function ExamineConsignment(string itemDS,bool reportProblems=TRUE)
{
	g_examineOpen:Set[FALSE]
	g_itemID:Set[0]

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
		;call LogText g_logFile "${g_windowID}"

		if !${ExamineItemWindow[${g_windowID}](exists)}
		{
			if ${reportProblems}
			{
				call LogText g_logFile "ExamineWindow doesn't exist!"
			}
		}
		else
		{
			variable string ExamineItemDS

			ExamineItemDS:Set["ExamineItemWindow[${g_windowID}].ToItem"]

			call SyncItem "${ExamineItemDS}"

			g_itemName:Set["${${ExamineItemDS}.Name}"]
			g_itemID:Set[${${ExamineItemDS}.ID}]
			g_itemTier:Set[${${ExamineItemDS}.Tier}]
			g_itemLevel:Set[${${ExamineItemDS}.Level}]
			g_itemType:Set[""]

			switch "${${ExamineItemDS}.Type}"
			{
				case House Item
					g_itemType:Set[HouseItem]
					break
				case Spell Scroll
					g_itemType:Set[Scroll]
					break
				case Recipe Book
					g_itemType:Set[RecipeBook]
					break
				case Armor
				case Weapon
				case Shield
					g_itemType:Set[Attuneable]
					break
				case Food
				case Drink
				case Book
				case Ammo
					g_itemType:Set[${${ExamineItemDS}.Type}]
					break
				case Item
					if ${${ExamineItemDS}.IsCollectible}
					{
						g_itemType:Set[Collectible]
					}
					elseif ${${ExamineItemDS}.Lore}
					{
						g_itemType:Set[Lore]
					}
					else
					{
						call DumpItemModifiers "${ExamineItemDS}"
					}
					break
				case Container
					g_itemType:Set[Bag]
					break
				case Activateable
					call DumpItemModifiers "${ExamineItemDS}"
					break
				case Decoration
					call DumpItemModifiers "${ExamineItemDS}"
					break
				default
					call LogText g_logFile "Unexpected item type encountered for Item \\\"${g_itemName}\\\": \\\"${${ExamineItemDS}.Type}\\\""
			}

			g_itemSlots:Set[""]

			variable int EquipSlotIndex

			EquipSlotIndex:Set[0]

			while ${EquipSlotIndex:Inc} <= ${${ExamineItemDS}.NumEquipSlots}
			{
				if ${EquipSlotIndex} != 1
				{
					g_itemSlots:Concat["|"]
				}

				switch "${${ExamineItemDS}.EquipSlot[${EquipSlotIndex}]}"
				{
					case left_ring
					case right_ring
						g_itemSlots:Concat[Fingers]
						break
					case left_wrist
					case right_wrist
						g_itemSlots:Concat[Wrist]
						break
					case activate1
					case activate2
						g_itemSlots:Concat[Charm]
						break
					case primary
						switch  ${${ExamineItemDS}.WieldStyle}
						{
							case One-Handed
								g_itemSlots:Concat[Primary1H]
								break
							case Dual Wield
								g_itemSlots:Concat[PrimaryDual]
								break
							case Two-Handed
								g_itemSlots:Concat[Primary2H]
								break
							default
								call LotText g_logFile "Unexpected item wield style encountered for Item \\\"${g_itemName}\\\": \\\"${${ExamineItemDS}.WieldStyle}\\\""
						}
						break
					case secondary
						if ${${ExamineItemDS}.NumEquipSlots} == 1 || ${EquipSlotIndex} == 1
						{
							g_itemSlots:Concat[Secondary]
						}
						else
						{
							g_itemSlots:Set[${g_itemSlots.Left[-1]}]
						}
						break
					case ammo
						break
					default
						g_itemSlots:Concat["${${ExamineItemDS}.EquipSlot[${EquipSlotIndex}]}"]

				}
			}

			g_itemClasses:Set[""]

			variable int ClassIndex

			ClassIndex:Set[0]

			while ${ClassIndex:Inc} <= ${${ExamineItemDS}.NumClasses}
			{
				if ${ClassIndex} != 1
				{
					g_itemClasses:Concat["|"]
				}

				g_itemClasses:Concat["${${ExamineItemDS}.Class[${ClassIndex}]}"]
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

	wait 10

	g_currentItem:Set[0]
	g_currentPage:Set[${pageNumber}]
}

function DoConsignmentSearch(string ItemName,string ItemTier,int ItemLevel,string ItemClasses,string ItemType,string ItemSlots)
{
	variable string BrokerCommandArguments

	BrokerCommandArguments:Set["Sort ByPriceAsc"]

	if ${ItemTier.Length} > 0
	{
		BrokerCommandArguments:Concat[" Tier ${ItemTier}"]
	}

	if ${ItemLevel} > 0
	{
		BrokerCommandArguments:Concat[" MinLevel ${ItemLevel} MaxLevel ${ItemLevel}"]
	}

	while ${ItemClasses.Length} > 0
	{
		variable int PipeIndex

		PipeIndex:Set[${ItemClasses.Find["|"]}]

		if ${PipeIndex} == 0
		{
			BrokerCommandArguments:Concat[" Class ${ItemClasses}"]

			break
		}
		else
		{
			BrokerCommandArguments:Concat[" Class ${ItemClasses.Left[${Math.Calc64[${PipeIndex}-1]}]}"]

			ItemClasses:Set[${ItemClasses.Right[${Math.Calc64[-${PipeIndex}]}]}]

			break
		}
	}

	if ${ItemType.Length} > 0
	{
		BrokerCommandArguments:Concat[" -Type ${ItemType}"]
	}

	if ${ItemSlots.Length} > 0
	{
		BrokerCommandArguments:Concat[" -Slot ${ItemSlots}"]
	}

	call LogText g_logFile "Executing broker command: broker Name \\\"${ItemName}\\\" ${BrokerCommandArguments}"

	broker Name "${ItemName}" ${BrokerCommandArguments}

	wait 20 ${Vendor.NumItemsForSale} != 0

	if ${Vendor.NumItemsForSale} > 0
	{
		call GotoPage 1
	}
	else
	{
		call LogText g_logFile "Broker command did not find any of the requested items for sale"
	}
}

objectdef UpdatePricesArgumentProcessor inherits ArgumentProcessor
{
	method ProcessArg(string Option,string Value)
	{
		if ${Option.Equal["broker_npc"]}
		{
			if ${Value.Length} == 0
			{
				Value:Set["${g_defaultBroker}"]
			}

			g_broker:Set[${Value}]
		}
		elseif ${Option.Equal["broker_commission"]}
		{
			if ${Value.Length} == 0
			{
				Value:Set[${g_defaultBrokerCommission}]
			}
			elseif ${Value} <= 0.0 || ${Value} > 100.0
			{
				echo The provided Broker Commission, \"${Option}\", must be > 0 and <= 100 - using default value \"${g_defaultBrokerCommission}\"

				Value:Set[${g_defaultBrokerCommission}]
			}

			g_brokerCommission:Set[${Math.Calc[${Value}/100.0]}]
		}
		elseif ${Option.Equal["log_file"]}
		{
			if ${Value.Length} == 0
			{
				Value:Set["${g_defaultLogFile}"]
			}

			g_logFile:Set[${Value}]
		}
		elseif ${Option.Equal["scan_interval"]}
		{
			if ${Value.Length} == 0
			{
				Value:Set[${g_defaultScanInterval}]
			}

			g_scanInterval:Set[${Math.Calc64[${Value}*600]}]
		}
		elseif ${Option.Equal["price_adjustment"]}
		{
			if ${Value.Length} == 0
			{
				Value:Set[${g_defaultPriceAdjustment}]
			}
			elseif ${Value} <= 0.0 || ${Value} > 100.0
			{
				echo The provided Price Adjustment, \"${Option}\", must be > 0 and <= 100 - using default value \"${g_defaultPriceAdjustment}\"

				Value:Set[${g_defaultPriceAdjustment}]
			}

			g_priceAdjustment:Set[${Math.Calc[${Value}/100.0]}]
		}
		elseif ${Option.Equal["max_allowed_reduction"]}
		{
			if ${Value.Length} == 0
			{
				Value:Set[${g_defaultMaxAllowedReduction}]
			}
			elseif ${Value} <= 0.0 || ${Value} > 100.0
			{
				echo The provided Max Allowed Reduction, \"${Option}\", must be > 0 and <= 100 - using default value \"${g_defaultMaxAllowedReduction}\"

				Value:Set[${g_defaultMaxAllowedReduction}]
			}

			g_maxAllowedReduction:Set[${Math.Calc[${Value}/100.0]}]
		}
		elseif ${Option.Equal["initial_price"]}
		{
			if ${Value.Length} == 0
			{
				Value:Set[${g_defaultInitalPrice}]
			}

			g_initialPrice:Set[${g_defaultInitialPrice}]
		}
		else
		{
			echo Unrecognized command option \"${Option}\" was ignored
		}
	}
}

atom OnExamineItemWindowAppeared(string itemName, string windowID)
{
	g_windowID:Set[${windowID}]
	g_examineOpen:Set[TRUE]
}

function main(... Args)
{
	variable UpdatePricesArgumentProcessor MyArgumentProcessor

	MyArgumentProcessor:Process[${Args.ExpandComma}]

	call LogText g_logFile "Executing UpdatePrices for ${Me.Name}"

	if !${Actor[${g_broker}](exists)}
	{
		call LogText g_logFile "Broker NPC \\\"${g_broker}\\\" doesn't exist"

		return
	}

	variable int BrokerID

	BrokerID:Set[${Actor[${g_broker}].ID}]

	call TargetActor ${BrokerID} TRUE TRUE

	Actor[${g_broker}]:DoubleClick

	call WaitForBrokerFocus

	ISXEQ2:ResetInternalVendingSystem

	variable int VendingContainerIndex

	VendingContainerIndex:Set[0]

	g_unupdatedItems:Clear

	while ${VendingContainerIndex:Inc} <= ${Me.NumVendingContainers}
	{
		variable int ConsignmentIndex

		ConsignmentIndex:Set[0]

		while ${ConsignmentIndex:Inc} <= ${Me.Vending[${VendingContainerIndex}].NumItems}
		{
			variable string ConsignmentDS

			ConsignmentDS:Set["Me.Vending[${VendingContainerIndex}].Consignment[${ConsignmentIndex}]"]

			variable bool WasListed

			WasListed:Set[${${ConsignmentDS}.IsListed}]

			if ${WasListed}
			{
				variable int UnlistAttempts

				UnlistAttempts:Set[0]

				${ConsignmentDS}:Unlist

				while ${UnlistAttempts:Inc} <= 10 && ${${ConsignmentDS}.IsListed}
				{
					wait 5
				}

				if ${${ConsignmentDS}.IsListed}
				{
					call LogText g_logFile "Timed out trying to unlist consignment"

					continue
				}
			}

			call ExamineConsignment "${ConsignmentDS}"

			if ${g_itemID} != 0
			{
				call LogText g_logFile "ItemName    = \\\"${g_itemName}\\\""
				call LogText g_logFile "ItemID      = \\\"${g_itemID}\\\""
				call LogText g_logFile "ItemTier    = \\\"${g_itemTier}\\\""
				call LogText g_logFile "ItemLevel   = \\\"${g_itemLevel}\\\""
				call LogText g_logFile "ItemType    = \\\"${g_itemType}\\\""
				call LogText g_logFile "ItemSlots   = \\\"${g_itemSlots}\\\""
				call LogText g_logFile "ItemClasses = \\\"${g_itemClasses}\\\""

				call DoConsignmentSearch "${g_itemName}" "${g_itemTier}" "${g_itemLevel}" "${g_itemClasses}" "${g_itemType}" "${g_itemSlots}"

				if ${Vendor.NumItemsForSale} == 0
				{
					if !${WasListed}
					{
						if !${g_unupdatedItems.Element["${g_itemName}"](exists)}
						{
							g_unupdatedItems:Set["${g_itemName}","${g_itemName}"]
						}

						call LogText g_logFile "No items with the requested parameters are for sale, so item will be listed at initial price of ${g_initialPrice}."

						${ConsignmentDS}:SetPrice[${g_initialPrice}]
					}
					else
					{
						call LogText g_logFile "No items with the requested parameters are for sale, so item will be relisted at current price."
					}
				}
				else
				{
					variable string VendorItemDS

					VendorItemDS:Set["Vendor.Item[1]"]

					variable float Price
					variable float BasePrice
					variable float Commission

					Price:Set[${${VendorItemDS}.Price}]
					BasePrice:Set[${${VendorItemDS}.BasePrice}]
					Commission:Set[${Math.Calc[${Price}-${BasePrice}]}]

					call LogText g_logFile "Lowest price for \\\"${g_itemName}\\\" is ${Price} silver, base price is ${BasePrice}, commission is ${Commission}"

					variable float TargetPrice

					TargetPrice:Set[${Math.Calc[${Price}-${Price}*${g_priceAdjustment}]}]

					call LogText g_logFile "Setting target price to ${TargetPrice}"

					variable float NewBasePrice

					NewBasePrice:Set[${Math.Calc[${TargetPrice}/(1.0+${g_brokerCommission})]}]

					call LogText g_logFile "Desired new base price is ${NewBasePrice}"

					call LogText g_logFile "Current base price is ${${ConsignmentDS}.BasePrice}"

					variable float LowestAllowedNewBasePrice

					LowestAllowedNewBasePrice:Set[${Math.Calc[${${ConsignmentDS}.BasePrice}*(1.0-${g_maxAllowedReduction})]}]

					call LogText g_logFile "Lowest allowed new base price is ${LowestAllowedNewBasePrice}"

					if ${NewBasePrice} < ${LowestAllowedNewBasePrice}
					{
						call LogText g_logFile "The new base price is lower than the lowest allowed new base price, so its pricing was not changed"

						if !${g_unupdatedItems.Element["${g_itemName}"](exists)}
						{
							g_unupdatedItems:Set["${g_itemName}","${g_itemName}"]
						}
					}
					elseif ${NewBasePrice} != ${${ConsignmentDS}.BasePrice}
					{
						call LogText g_logFile "Setting new base price"

						${ConsignmentDS}:SetPrice[${NewBasePrice}]

						g_consignmentsUpdated:Inc
					}
					else
					{
						call LogText g_logFile "Base price does not need to be changed"
					}
				}

				variable int ListAttempts

				ListAttempts:Set[0]

				${ConsignmentDS}:List

				while ${ListAttempts:Inc} <= 10 && !${${ConsignmentDS}.IsListed}
				{
					wait 5
				}

				if !${${ConsignmentDS}.IsListed}
				{
					call LogText g_logFile "Timed out trying to List consignment"
				}
			}
			else
			{
				call LogText g_logFile "Unexpected problem occurred examining Vending Container Index ${VendingContainerIndex}, Consignment index ${ConsignmentIndex}"
			}
		}
	}
}

atom atexit()
{
	call LogText g_logFile "Leaving BuyCollections."

	call LogText g_logFile "Total Consignments Updated: ${g_consignmentsUpdated}"

	if ${g_unupdatedItems.FirstKey(exists)}
	{
		call LogText g_logFile "The following consignments were not updated due to your price reduction constraint:"

		while 1
		{
			variable string NextItemName

			NextItemName:Set["${g_unupdatedItems.CurrentKey}"]

			call LogText g_logFile "\\\"${NextItemName}\\\""

			if !${g_unupdatedItems.NextKey(exists)}
			{
				break
			}
		}
	}

	g_logFile:Close
}
