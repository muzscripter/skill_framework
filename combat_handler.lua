local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Skillset = require(ReplicatedStorage.Storage.Modules.Skillset)
local SkillSets = ReplicatedStorage.Storage.Modules.SkillSets

local GetData = (ReplicatedStorage.Storage.Remotes.GetData)
local SendData = (ReplicatedStorage.Storage.Remotes.SendData)

local Notify = require(ReplicatedStorage.Storage.Modules.Notification)

local PlayerSkillSets = {}

local function GetPlayerSkillset(Player)
	return PlayerSkillSets[Player.Name]
end

local function InitiatePlayer(Player)
    print('Creating Player SkillSet')
 

	local PlayerSkillset = Skillset.new(Player)

	PlayerSkillSets[Player.Name] = PlayerSkillset
end

game.Players.PlayerAdded:Connect(function(Player)
	print('Player Added:', Player.Name)
	
	local Sucess, Error = InitiatePlayer(Player)
	
	if Sucess then
		print('Successfully Created Players SkillSet')
	elseif Error then
		error('Failed to create Player SkillSet')
	end

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

SendData.OnServerEvent:Connect(function(Player, skillsetName)
    print(Player, skillsetName)

    local playerSkillset = GetPlayerSkillset(Player)

	if playerSkillset then
		if skillsetName == 'WaterBreathing' then
			
			playerSkillset:UnlockSkillset(skillsetName)
			
			playerSkillset:UnlockSkill('Waterfall Basin', require(SkillSets['WaterBreathing']))
			playerSkillset:UnlockSkill('Drop Ripple Thrust', require(SkillSets['WaterBreathing']))			
		elseif skillsetName == 'FlameBreathing' then
			
			playerSkillset:UnlockSkillset(skillsetName)
			
			playerSkillset:UnlockSkill('Flame Barrage', require(SkillSets['FlameBreathing']))
			playerSkillset:UnlockSkill('Icho No Kata Shiran', require(SkillSets['FlameBreathing']))
			playerSkillset:UnlockSkill('Ni No Kata Koborienten', require(SkillSets['FlameBreathing']))
			playerSkillset:UnlockSkill('San No Kata Kienbansyou', require(SkillSets['FlameBreathing']))	
		end
		
        return true
    else
        return false
    end
end)
