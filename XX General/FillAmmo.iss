#include SyncItem.iss
#include TargetActor.iss
#include LogText.iss
#include ArgumentProcessor.iss

variable(global) string     g_defaultBroker = "Guild Hall World Market Broker"
variable(global) string     g_defaultLogFile = "FillAmmo.txt"
variable(global) float64ptr g_defaultSpendingLimit = 1000000.0
variable(global) float64ptr g_defaultPriceLimit  = 100.0
variable(global) string     g_defaultAmmoName = "Rhenium Shuriken"
variable(global) int        g_defaultAmmoPerSlot = 200

variable(global) string     g_broker = "${g_defaultBroker}"
variable(global) file       g_logFile = "${g_defaultLogFile}"
variable(global) float64ptr g_spendingLimit = ${g_defaultSpendingLimit}
variable(global) float64ptr g_priceLimit  = ${g_defaultPriceLimit}
variable(global) string     g_ammoName = "${g_defaultAmmoName}"
variable(global) int        g_ammoPerSlot = ${g_defaultAmmoPerSlot}

variable(global) int        g_currentPage = 0
variable(global) int        g_currentItem = 0
variable(global) float64ptr g_silverSpentOnAmmo = 0.0
variable(global) int        g_ammoPurchased = 0
variable(global) bool       g_notEnoughCoin = FALSE
variable(global) bool       g_invalidQuantity = FALSE
variable(global) bool       g_boughtAmmo = FALSE
variable(global) bool       g_consignmentInProgress = FALSE
variable(global) int        g_purchaseTimeOutLimit = 40
variable(global) int        g_purchaseTimeOutWait = 5
 
function WaitForBrokerFocus()
{
	while !${EQ2UIPage[Inventory,Market].IsMouseOver}
	{
		waitframe
	}
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

function GetAmmoNeeded(string AmmoContainerDS)
{
	variable int SlotIndex
	variable int AmmoNeeded

	SlotIndex:Set[-1]
	AmmoNeeded:Set[0]

	while ${SlotIndex:Inc} < ${${AmmoContainerDS}.NumSlots}
	{
		variable string AmmoDS

		AmmoDS:Set["${AmmoContainerDS}.ItemInSlot[${SlotIndex}]"]

		if !${${AmmoDS}(exists)}
		{
			AmmoNeeded:Set[${Math.Calc64[${AmmoNeeded}+${g_ammoPerSlot}]}]

			continue
		}

		call SyncItem "${AmmoDS}"
		
		if ${${AmmoDS}.Name.Equal["${g_ammoName}"]} && ${${AmmoDS}.Quantity} < ${g_ammoPerSlot}
		{
			variable int UsedAmmo

			UsedAmmo:Set[${Math.Calc64[${g_ammoPerSlot}-${${AmmoDS}.Quantity}]}]

			AmmoNeeded:Set[${Math.Calc64[${AmmoNeeded}+${UsedAmmo}]}]
		}
	}

	return ${AmmoNeeded}
}

function DoAmmoSearch(string Name)
{
	call LogText g_logFile "Executing broker command: broker Name \\\"${Name}\\\" Sort ByPriceAsc -type ammo"

	broker Name "${Name}" Sort ByPriceAsc -type ammo 

	wait 20 ${Vendor.NumItemsForSale} != 0

	if ${Vendor.NumItemsForSale} > 0
	{
		call GotoPage 1
	}
	else
	{
		call LogText g_logFile "Broker command did not find any of the requested ammo, \\\"${Name}\\\", for sale"
	}
}

objectdef FillAmmoArgumentProcessor inherits ArgumentProcessor
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
		elseif ${Option.Equal["ammo_name"]}
		{
			if ${Value.Length} == 0
			{
				Value:Set["${g_defaultAmmoName}"]
			}

			g_ammoName:Set["${Value}"]

			echo ${g_ammoName}
		}
		elseif ${Option.Equal["ammo_per_slot"]}
		{
			if ${Value.Length} == 0
			{
				Value:Set["${g_defaultAmmoPerSlot}"]
			}

			g_ammoPerSlot:Set[${Value}]
		}
		else
		{
			echo Unrecognized command option \"${Option}\" was ignored
		}
	}
}

atom OnIncomingText(string Message)
{
	if !${g_notEnoughCoin} && ${Message.Find["You do not have enough coin to purchase the item"](exists)}
	{
		g_notEnoughCoin:Set[TRUE]

		return
	}

	if !${g_invalidQuantity} && ${Message.Find["That item cannot be purchased in the quantity requested"](exists)}
	{
		g_invalidQuantity:Set[TRUE]

		return
	}

	if !${g_consignmentInProgress} && ${Message.Find["You have a consignment transaction in progress"](exists)}
	{
		g_consignmentInProgress:Set[TRUE]

		return
	}

	if !${g_boughtAmmo} && ${Message.Find["You bought"](exists)}
	{
		g_boughtAmmo:Set[TRUE]

		return
	}
}

atom atexit()
{
	call LogText g_logFile "Leaving FillAmmo."

	call LogText g_logFile "Silver spent on ammo: ${g_silverSpentOnAmmo}"
	call LogText g_logFile "Total ammo purchased: ${g_ammoPurchased}"

	g_logFile:Close
}

function main(... Args)
{
	variable FillAmmoArgumentProcessor MyArgumentProcessor

	MyArgumentProcessor:Process[${Args.ExpandComma}]

	call LogText g_logFile "Executing FillAmmo for ${Me.Name}"

	variable string AmmoContainerDS
	
	AmmoContainerDS:Set["Me.Equipment[Ammo]"]

	if !${${AmmoContainerDS}(exists)}
	{
		call LogText g_logFile "You do not have an ammo container equipped"

		return
	}

	call SyncItem "${AmmoContainerDS}"

	call GetAmmoNeeded "${AmmoContainerDS}"

	variable int AmmoNeeded

	AmmoNeeded:Set[${Return}]

	if ${AmmoNeeded} == 0
	{
		call LogText g_logFile "You don't need any \\\"${g_ammoName}\\\""

		return
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

	call LogText g_logFile "You will attempt to purchase ${AmmoNeeded} \\\"${g_ammoName}\\\""

	variable float64ptr MySilverToSpend

	MySilverToSpend:Set[${Math.Calc[${Me.Platinum}*10000.0+${Me.Gold}*100.0+${Me.Silver}+${Me.Copper}/100.0]}]
	
	if ${MySilverToSpend} < ${g_spendingLimit}
	{
		call LogText g_logFile "FYI, the total silver in your bank, ${MySilverToSpend}, is less than the silver you have allocated to spend on ammo (${g_spendingLimit})"
		call LogText g_logFile "Setting the silver to spend on ammo to what you have in your bank"

		g_spendingLimit:Set[${MySilverToSpend}]
	}

	call LogText g_logFile "You have ${MySilverToSpend} total silver in your bank\\\; ${g_spendingLimit} silver has been allocated to spend on ammo"
	call LogText g_logFile "The maximum silver you will spend on a single piece of ammo is ${g_priceLimit}"

	Event[EQ2_onIncomingText]:AttachAtom[OnIncomingText]

	call DoAmmoSearch "${g_ammoName}"

	g_currentPage:Dec

	while ${g_currentPage:Inc} <= ${Vendor.TotalSearchPages}
	{
		call GotoPage ${g_currentPage}

		while ${g_currentItem:Inc} <= ${Vendor.NumItemsForSale}
		{
			variable string VendorItem

			VendorItem:Set["Vendor.Item[${g_currentItem}]"]

			variable string     Name
			variable float64ptr Price
			variable int        Quantity

			Name:Set["${${VendorItem}.Name}"]
			Price:Set[${${VendorItem}.Price}]
			Quantity:Set[${${VendorItem}.Quantity}]

			if !${Name.Equal["${g_ammoName}"]} || ${Quantity} == 0
			{
				continue
			}

			;call LogText g_logFile "Examining \\\"${Name}\\\" ${Level} ${Price} ${Quantity}"

			if ${Price} > ${g_priceLimit}
			{
				call LogText g_logFile "** Not buying \\\"${Name}\\\" because its price (${Price}) exceeds the silver price limit (${g_priceLimit}) **"

				return
			}

			variable int AmountToPurchase

			if ${Quantity} <= ${AmmoNeeded}
			{
				AmountToPurchase:Set[${Quantity}]
			}
			else
			{
				AmountToPurchase:Set[${AmmoNeeded}]
			}

			if ${AmountToPurchase} > ${g_ammoPerSlot}
			{
				AmountToPurchase:Set[${g_ammoPerSlot}]

				g_currentItem:Dec
			}

			variable float64ptr TotalPrice

			TotalPrice:Set[${Math.Calc[${AmountToPurchase}*${Price}]}]

			if ${TotalPrice} > ${g_spendingLimit}
			{
				call LogText g_logFile "** Not buying \\\"${Name}\\\" because its total price (${TotalPrice}) exceeds the silver left to spend on ammo (${g_spendingLimit}) **"

				return
			}

			call LogText g_logFile "** Buying ${AmountToPurchase} \\\"${Name}\\\" for ${TotalPrice} silver on Page ${g_currentPage}**"

			g_boughtAmmo:Set[FALSE]

			${VendorItem}:Buy[${AmountToPurchase}]

			call LogText g_logFile "** Waiting for purchased \\\"${Name}\\\" to show up in inventory **"

			variable int AmountPurchased
			variable int PurchaseTimeOut

			AmmountPurchased:Set[0]
			PurchaseTimeOut:Set[0]

			while ${PurchaseTimeOut:Inc} <= ${g_purchaseTimeOutLimit} && !${g_notEnoughCoin} && !${g_invalidQuantity}
			{
				if ${g_boughtAmmo}
				{
					call GetAmmoNeeded "${AmmoContainerDS}"

					AmountPurchased:Set[${Math.Calc64[${AmmoNeeded}-${Return}]}]
					AmmoNeeded:Set[${Return}]

					if ${AmountPurchased} > 0
					{
						if ${AmountPurchased} != ${AmountToPurchase}
						{
							call LogText g_logFile "** Tried to buy ${AmountToPurchase} \\\"${Name}\\\", but only ${AmountPurchased} were actually purchased **"
						}

						g_ammoPurchased:Set[${Math.Calc64[${g_ammoPurchased}+${AmountPurchased}]}]

						break
					}
				}

				wait ${g_purchaseTimeOutWait}
			}

			if ${PurchaseTimeOut} > ${g_purchaseTimeOutLimit}
			{
				call LogText g_logFile "** Not buying \\\"${Name}\\\" because we timed out - make sure the specified ammo can actually be placed in the ammo container **"

				return
			}

			if ${g_notEnoughCoin}
			{
				call LogText g_logFile "** Not buying \\\"${Name}\\\" because broker is telling us we don't have enough coin **"

				return
			}

			if ${g_invalidQuantity}
			{
				call LogText g_logFile "** Not buying \\\"${Name}\\\" because broker is telling us it can't purchase the requested quantity **"

				return
			}

			variable float64ptr AmountSpent

			AmountSpent:Set[${Math.Calc[${AmountPurchased}*${Price}]}]

			g_spendingLimit:Set[${Math.Calc[${g_spendingLimit}-${AmountSpent}]}]
			g_silverSpentOnAmmo:Set[${Math.Calc[${g_silverSpentOnAmmo}+${AmountSpent}]}]

			call LogText g_logFile "You bought ${AmountPurchased} \\\"${Name}\\\" for ${AmountSpent} silver"

			;call LogText g_logFile "** You have ${g_spendingLimit} silver left to spend on ammo **"

			if ${AmmoNeeded} == 0
			{
				call LogText g_logFile "Ammo has been completely filled"

				return
			}
		}
	}
}

