
---------------------------------------------
-- Adds a warning to tooltips containing skills that other members in the party
-- already have memorized.
-- This includes Skill tooltips as well as Item tooltips of items with a skillbook action.
---------------------------------------------

local Tooltip = Client.Tooltip

local Nuzlocke = {
    WARNING_LABEL = "%s already has this skill memorized.",
}
Epip.RegisterFeature("Nuzlocke", Nuzlocke)

---------------------------------------------
-- METHODS
---------------------------------------------

---Adds a warning to tooltips containing skills that another party member already has memorized.
---@param tooltip TooltipLib_FormattedTooltip
---@param skillID string
---@return boolean -- `true` if a warning was added.
function Nuzlocke.ProcessTooltip(tooltip, skillID)
    local clientChar = Client.GetCharacter()
    local partyMembers = Character.GetPartyMembers(clientChar)
    local memberWithSkill = nil ---@type EclCharacter?
    for _,member in ipairs(partyMembers) do
        if member ~= clientChar then
            if Character.IsSkillMemorized(member, skillID) and not Character.IsSkillInnate(member, skillID) then
                memberWithSkill = member
                break
            end
        end
    end

    if memberWithSkill then
        tooltip:InsertElement({
            Type = "Engraving",
            Label = Text.Format(Nuzlocke.WARNING_LABEL, {
                FormatArgs = {
                    memberWithSkill.DisplayName,
                },
                Color = Color.LARIAN.RED,
            })
        })
    end

    return memberWithSkill ~= nil
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Hook skill tooltips.
Tooltip.Hooks.RenderSkillTooltip:Subscribe(function (ev)
    Nuzlocke.ProcessTooltip(ev.Tooltip, ev.SkillID)
end)

-- Hook tooltips of items with a SkillBook action.
Tooltip.Hooks.RenderItemTooltip:Subscribe(function (ev)
    local skillbookActions = Item.GetUseActions(ev.Item, "SkillBook") ---@cast skillbookActions SkillBookActionData[]
    for _,action in ipairs(skillbookActions) do
        if Nuzlocke.ProcessTooltip(ev.Tooltip, action.SkillID) then
            break
        end
    end
end)
