---------------------------------------------
-- Removes the "CannotUse" AI flag from all skills.
---------------------------------------------

-- Adjust all skills to remove the flag.
Ext.Events.SessionLoaded:Subscribe(function (_)
    local skills = Ext.Stats.GetStats("SkillData")
    for _,skillID in ipairs(skills) do
        local skill = Ext.Stats.Get(skillID) ---@cast skill StatsLib_StatsEntry_SkillData

        skill.AIFlags = skill.AIFlags:gsub("CanNotUse;?", "") -- No vanilla skill actually uses multiple flags, the ";" as separator is an assumption.
    end
end)
