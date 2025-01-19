local f = CreateFrame("Frame", "RaidListAddonFrame")

editBoxFrame = CreateFrame("Frame", "RaidListEditBoxFrame", UIParent)
 editBoxFrame:SetWidth(100)
 editBoxFrame:SetHeight(50)
 editBoxFrame:SetPoint("LEFT", UIParent, "CENTER")
 editBoxFrame:SetMovable(true)
 editBoxFrame:EnableMouse(true)
 editBoxFrame:RegisterForDrag("LeftButton")
 editBoxFrame:SetScript("OnDragStart", editBoxFrame.StartMoving)
 editBoxFrame:SetScript("OnDragStop", editBoxFrame.StopMovingOrSizing)
 
 local background = CreateFrame("Frame", nil, editBoxFrame)
 background:SetAllPoints(editBoxFrame)
 background:SetBackdropColor(0,0,0,0)

local editBox = CreateFrame("EditBox", nil, editBoxFrame, "InputBoxTemplate")
editBox:SetBackdrop({
	bgFile = [[Interface\Buttons\WHITE8x8]],
	edgeSize = 10,
	insets = {left = -5, right = -5, top = -5, bottom = -5},
})
editBox:SetBackdropColor(0.3, 0.3, 0.3, 1)
editBox:SetBackdropBorderColor(0, 0, 0, 1)
editBox:SetMultiLine(true)
editBox:SetWidth(96)
editBox:SetPoint("LEFT", editBoxFrame, "TOP", 2, -2)
editBox:SetAutoFocus(true)
editBox:SetFont("Fonts\\FRIZQT__.TTF", 10)
editBoxFrame:Hide()

-- Toggle button
local toggleButton = CreateFrame("Button", "ToggleTextFrameButton", editBoxFrame, "UIPanelButtonTemplate")
toggleButton:SetWidth(25)
toggleButton:SetHeight(20)
toggleButton:SetText("OK")
toggleButton:SetPoint("TOPLEFT", editBoxFrame, "TOPRIGHT", 55, 8)
toggleButton:SetScript("OnClick",  function()
    if editBoxFrame:IsShown() then
        editBoxFrame:Hide()
    end
end)

-- raid member list
local function getRaidMemberList()
    local raidMembers = {}
    local numRaidMembers = GetNumRaidMembers()
    for i = 1, numRaidMembers do
        local name = GetRaidRosterInfo(i)
        if name then
            table.insert(raidMembers, name)
        end
    end
    return raidMembers
end

local function displayRaidList()
    
    local raidMembers = getRaidMemberList()
    local raidListText = table.concat(raidMembers, "\n")
    
    editBox:SetText(raidListText)
    
    -- frame height
    local numLines = GetNumRaidMembers()
   
    local padding = 5;  -- top + bottom padding
    local calculatedHeight = (10 * (numLines + 1)) + padding
    
    
    editBoxFrame:SetHeight(calculatedHeight)
	editBoxFrame:Show()
end


minimapButton = CreateFrame("Button", "RaidListAddonMinimapButton", Minimap)
minimapButton:SetWidth(32)
minimapButton:SetHeight(32)
minimapButton:SetNormalTexture("Interface\\Icons\\ability_stealth")
minimapButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
minimapButton:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -10, -10)
minimapButton:SetScript("OnClick", onMinimapClick)
minimapButton:SetScript("OnClick", function()
    if editBoxFrame:IsShown() then
        editBoxFrame:Hide()
    elseif GetNumRaidMembers() > 0 then
		displayRaidList()
	else
        DEFAULT_CHAT_FRAME:AddMessage("You are not in a raid.")
    end
end)

-- minimap button positioning
local function OnUpdate()
    minimapButton:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -10, -10)
end

-- Register the update function
f:SetScript("OnUpdate", OnUpdate)