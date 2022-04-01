if VendorSlotTable == nil then
    VendorSlotTable = {}
end

local timer = 0

function StartVendorSlot()
    timer = 1
    print("Scheduled delayed update")
end

function VendorSlotOnUpdate()
    if timer > 0 then
        timer = timer + 1
        if timer > 50 then
            VendorSlot()
            timer = 0
        end
    end
end

function VendorSlot()
    vendorName = GetUnitName("target")
    if VendorSlotTable[vendorName] == nil then
        local numItems = GetMerchantNumItems()
        entry = {}
        for index = 1, numItems do
            local link = GetMerchantItemLink(index)
            local itemEntry = tonumber(link:match("|Hitem:(%d+):"))
            entry[index] = itemEntry
        end
        VendorSlotTable[vendorName] = entry
        print("Inserted vendor", vendorName, "in DB.")
    else
        print("Vendor with name", vendorName, "already in DB.")
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", StartVendorSlot)
f:SetScript("OnUpdate", VendorSlotOnUpdate)
