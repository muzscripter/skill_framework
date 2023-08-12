local Skillset = {}
Skillset.__index = Skillset

function Skillset.new(Player)
	local self = setmetatable({
		Skillset = nil,
		Skills = {}
	}, Skillset)

	return self
end

function Skillset:UnlockSkillset(skillsetName)
	if self.Skillset ~= skillsetName then
		self.Skillset = skillsetName
	end
end

function Skillset:UnlockSkill(skillName, skillData)
	if not skillData[skillName] then
		return error(string.format("Failed to find skill called '%s' inside SkillData table", skillName))
	end
	
	if not self.Skills[skillName] then
		self.Skills[skillName] = skillData
		print(string.format("Unlocked skill '%s' for player", skillName))
	else
		warn(string.format("Player already has skill '%s' unlocked", skillName))
	end
end

return Skillset
