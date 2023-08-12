local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')

local Cooldown = require(ReplicatedStorage.Storage.Modules.Cooldown)
local Player = game.Players.LocalPlayer

local GetData = ReplicatedStorage.Storage.Remotes.GetData

local function UseSkill(skillName)
	print("Using skill:", skillName)
	
	if skillName == 'Water Basin' then
		local Water = require(ReplicatedStorage.Storage.Modules.Moves.Water)
		
		Water['WaterBasin'](Player.Character)
	end
end


UserInputService.InputBegan:Connect(function(ClientInput, GameProcessed)
	if GameProcessed then return end
	
	local SkillTable = GetData:InvokeServer(Player)
	
	for Skill, SkillSet in pairs(SkillTable) do
		if ClientInput.KeyCode == Enum.KeyCode[SkillSet[Skill].KeyBind] then
			UseSkill(Skill)
		end
	end
end)
