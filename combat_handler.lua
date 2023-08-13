local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Skillset = require(ReplicatedStorage.Storage.Modules.Skillset)
local SkillSets = ReplicatedStorage.Storage.Modules.SkillSets

local GetData = (ReplicatedStorage.Storage.Remotes.GetData)

local PlayerSkillSets = {}

local function GetPlayerSkillset(Player)
	return PlayerSkillSets[Player.Name]
end

local function InitiatePlayer(Player)
    print('Creating Player SkillSet')
 

	local PlayerSkillset = Skillset.new(Player)

	print('Unlocking Skillset')

	PlayerSkillset:UnlockSkillset('WaterBreathing')

	print('Unlocking Skill')
	
	PlayerSkillset:UnlockSkill('Water Basin', require(SkillSets['WaterBreathing']))
	PlayerSkillset:UnlockSkill('Water Ripple', require(SkillSets['WaterBreathing']))
	
	print('Creating Player SkillSet Table')

	PlayerSkillSets[Player.Name] = PlayerSkillset
end

game.Players.PlayerAdded:Connect(function(Player)
	print('Player Added:', Player.Name)
	InitiatePlayer(Player)

	print('Checking if Player SkillSet Table is made')

	if PlayerSkillSets[Player.Name] then
		local skillset = GetPlayerSkillset(Player)
		if skillset then
			for skillName, skillData in pairs(skillset.Skills) do
				print('Skill:', skillName)
				for key, value in pairs(skillData) do
					print(' -', key, value)
				end
			end
		else
			error('Couldn\'t find player SkillSet')
		end
	else
		InitiatePlayer(Player)
		error('Couldn\'t find player SkillSet table')
	end
end)

GetData.OnServerInvoke = function(Player)
	
	local PlayerSkillData = GetPlayerSkillset(Player)

	if PlayerSkillData then
	
		return PlayerSkillData
	else
	
		return nil
	end
end
