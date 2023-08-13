local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')

local SFX = ReplicatedStorage.Storage.SFX
local Cooldown = require(ReplicatedStorage.Storage.Modules.Cooldown)
local Player = game.Players.LocalPlayer
local Character = Player.Character

local GetData = ReplicatedStorage.Storage.Remotes.GetData

local function UseSkill(Skill)
	local Moves = ReplicatedStorage.Storage.Modules.Moves
	
	local SkillTable = GetData:InvokeServer(Player)
	
	local MoveSet = require(Moves[SkillTable.Skillset])

	if MoveSet[Skill] then
		MoveSet[Skill](Player.Character)
	end
end

UserInputService.InputBegan:Connect(function(ClientInput, GameProcessed)
	if GameProcessed then return end



	local SkillTable = GetData:InvokeServer(Player)
	
	if SkillTable then
		for Skill, SkillSet in pairs(SkillTable.Skills) do
			if ClientInput.KeyCode == Enum.KeyCode[SkillSet[Skill].KeyBind] then
				print("KeyBind:", SkillSet[Skill].KeyBind)
				print(string.format("Skill Used '%s' ", Skill))
				UseSkill(Skill)
			end
		end
	else
		print("SkillTable is nil")
	end
end)
