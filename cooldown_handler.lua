local Cooldown  = {}
local Cooldowns = {}

function Cooldown:AddCooldown(Player: any, Skill: string, Length: number)
	Cooldowns[Skill] = {Active = true}
	if not Cooldowns[Skill]['Length'] then
		Cooldowns[Skill]['Length'] = 0
	end

	Cooldowns[Skill]['Length'] += 1

	local Copy = Cooldowns[Skill]['Length']

	task.delay(Length, function()
		if Cooldowns[Skill] and Cooldowns[Skill]['Length'] == Copy then
			Cooldowns[Skill] = nil
		end
	end)
end

function Cooldown:CheckCooldown(Skill: string, Player: any)
	if Cooldowns[Skill] then
		return true
	else
		return false
	end
end


return Cooldown
