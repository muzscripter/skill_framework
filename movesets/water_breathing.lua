local RS = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")


local module = require(game.ReplicatedStorage.FrameWork.src.Modules.MuchachoHitbox)

local Debriss = require(RS.FrameWork.src.Modules.Debriss)
local animfiles  = RS.FrameWork.src.res.Animation.Water   
local framevfx = RS.FrameWork.src.res.Water
local Ragdoll = require(game.ReplicatedStorage.FrameWork.src.Modules.Ragdoll)


return {
	['WaterBasin'] = function(Character)
		
		local humanoid = Character.Humanoid
		local HumanoidRootPart = Character.HumanoidRootPart

		local bloodanim = humanoid.Animator:LoadAnimation(animfiles.HoldWaterBaisen)
		
		task.delay(0.7,function()
			bloodanim:Play()
		end)
		
		bloodanim:Play()
		local BodyVelocity = Instance.new("BodyVelocity")
		BodyVelocity.Name = "DashForce"
		BodyVelocity.MaxForce = Vector3.new(20000, 4500, 20000)
		BodyVelocity.P = 1250
		BodyVelocity.Parent = Character.Head
		BodyVelocity.Velocity = Character.Head.CFrame.LookVector * 45 + Character:FindFirstChild("HumanoidRootPart").CFrame.UpVector * 70
		game.Debris:AddItem(BodyVelocity, 0.3)



		local touchedExecuted = false

		task.wait(0.8)

		Character["Left Leg"].Touched:Connect(function(part)

			if (part:IsA("Part") or part:IsA("MeshPart")) and not touchedExecuted then
				touchedExecuted = true

				for _, anim in pairs(humanoid:GetPlayingAnimationTracks()) do
					anim:Stop()
					task.wait()
					local holdanim3 = humanoid.Animator:LoadAnimation(animfiles.NewWaterBaisen)
					holdanim3:Play()
				end

				task.wait(0.2)


				local  CoolVfx = framevfx.Waterfallbaisen:Clone()
				local baisenroot = CoolVfx.MainRoot.Root
				CoolVfx.Parent = HumanoidRootPart
				baisenroot.CFrame = HumanoidRootPart.CFrame * CFrame.new(0,-3.2,-6.5)

				for i,v in pairs(CoolVfx.D.Attachment:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						v:Emit(v:GetAttribute("EmitCount"))
					end
				end

				for i,v in pairs(CoolVfx.MainRoot.Root.ATT:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						v:Emit(v:GetAttribute("EmitCount"))
					end
				end
				
				for i,v in pairs(CoolVfx.Root.Root.ATT:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						v:Emit(v:GetAttribute("EmitCount"))
					end
				end
				
				for i,v in pairs(CoolVfx.X:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						v:Emit(v:GetAttribute("EmitCount"))
					end
				end

				for i,v in pairs(CoolVfx.RE.Attachment:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						v:Emit(v:GetAttribute("EmitCount"))
					end
				end

				local part = game:GetService("ReplicatedStorage").FrameWork.src.res.Flame.DebrisPlacer:Clone()
				part.Parent =  workspace
				part.CFrame = Character.HumanoidRootPart.CFrame * CFrame.new(0, -2.8, -20)
				part.Anchored = true
				local ds = false




				local heartbeatConnection
				heartbeatConnection = game:GetService('RunService').Heartbeat:Connect(function()
					if ds == false then
						ds = true
						delay(.001, function()
							ds = false

							Debriss.Shoot(part,1.5,2,0.8,1,100,false)
							Debriss.Normal(part, 3, 15, 0.2, 5, true)


						end)
					end
				end)
				task.delay(0.8,function()

					ds = true
					heartbeatConnection:Disconnect()
				end)


				task.delay(0.9,function()

					CoolVfx:Destroy()
					CoolVfx = nil
				end)


				local hitbox = module.CreateHitbox()

				hitbox.Size = Vector3.new(26, 10, 10)

				local db = false
				hitbox.CFrame = Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-6)
				hitbox:Start()


				hitbox.Visualizer = true
				hitbox.Touched:Connect(function(part)
					if part.Parent and part.Parent:FindFirstChild("Humanoid") and part.Parent.Name ~= Character.Name then
						local humanoid = part.Parent:FindFirstChild("Humanoid")
						if humanoid.Health > 1 and db == false then

							local Velocity = Instance.new("BodyVelocity", part.Parent:FindFirstChild("HumanoidRootPart"))
							Velocity.MaxForce = Vector3.new(0, 10000, 0)
							Velocity.Velocity = Character:FindFirstChild("HumanoidRootPart").CFrame.UpVector * 60
							game.Debris:AddItem(Velocity, 0.3)

							local health = humanoid.Health
							local dmg = 10

							if health - dmg < 1 then
								humanoid:TakeDamage(health-1)

							else
								humanoid:TakeDamage(dmg)

							end

							Ragdoll:Enable(part.Parent)
							task.delay(1.5,function()
								Ragdoll:Disable(part.Parent)

							end)

						end
					end
				end)

				coroutine.wrap(function()

				end)()
				wait(0.1)

				hitbox:Stop()
			end
		end)
	end,
}
