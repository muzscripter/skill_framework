local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')

local SFX = ReplicatedStorage.Storage.SFX
local Cooldown = require(ReplicatedStorage.Storage.Modules.Cooldown)
local Player = game.Players.LocalPlayer
local Character = Player.Character

local GetData = ReplicatedStorage.Storage.Remotes.GetData
local UsingSkill = false

local Notify = require(ReplicatedStorage.Storage.Modules.Notification)

local function UseSkill(Skill)
	UsingSkill = true
	
	local Moves = ReplicatedStorage.Storage.Modules.Moves
	
	local SkillTable = GetData:InvokeServer(Player.Character)
	
	local MoveSet = require(Moves[tostring(SkillTable.Skillset)])

	if MoveSet[Skill] then
		MoveSet[Skill](Player.Character)
		Notify:Send(game.Players.LocalPlayer, 'Notification :', string.format("Used Skill '%s'", Skill), 3)
	end
	UsingSkill = false
end


UserInputService.InputBegan:Connect(function(ClientInput, GameProcessed)
	if GameProcessed then return end



	local SkillTable = GetData:InvokeServer(Player)
	
	if SkillTable then
		for Skill, SkillSet in pairs(SkillTable.Skills) do
			if ClientInput.KeyCode == Enum.KeyCode[SkillSet[Skill].KeyBind] then
				if UsingSkill then return end
				
				print("KeyBind:", SkillSet[Skill].KeyBind)
				
				if not Cooldown:CheckCooldown(Player, Skill) then
					UseSkill(Skill)
					
					Cooldown:AddCooldown(Player, Skill, SkillSet[Skill].ExtraInfo.CooldownTime)
					
					print(string.format("Skill Used '%s' ", Skill))
				else
					Notify:Send(game.Players.LocalPlayer, 'Notification :', string.format("Skill '%s' is on cooldown", Skill), 3)
					print(string.format("Skill '%s' is on cooldown", Skill))
				end

			end
		end
	else
		print("SkillTable is nil")
	end
end)
