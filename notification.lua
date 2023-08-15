local TweenService = game:GetService("TweenService")

local Notify = {}

Notify.__index = Notify
Notify.Cache = {}
Notify.Offset = 75

local function InsCache(Inst)
	if (not Inst) then
		return
	end

	if not table.find(Notify.Cache, Inst) then
		table.insert(Notify.Cache, Inst)
	end
end

function Notify:Send(Player, Title, Description, Duration)
	local PUI = Player:WaitForChild('PlayerGui')
	
	print(PUI)
	local NotificationTemplate = game.StarterGui.Framework.Notification.Template
	
	local Notification = NotificationTemplate:Clone()
	
	print('Cloned')
	
	Notification.Name = string.format('Notification%s', Player.Name)

	InsCache(Notification)

	Notification.Title.Text = Title or 'Notification:'
	Notification.Description.Text = Description or 'Place Holder'

	Notification.Parent = PUI.Framework.Notification

	Notification.Visible = true

	local IntRatio = 5
	local CacheIndex = #Notify.Cache
	local Offset = (CacheIndex - 1) * Notify.Offset

	local PositionTweenTo = UDim2.new(1, -260, 0, Offset)
	if CacheIndex >= 1 then
		PositionTweenTo = UDim2.new(1, -260, 0, Offset)
	else
		PositionTweenTo = UDim2.new(1, -260 + IntRatio, 0, Offset)
	end

	local Info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local TweenIn = TweenService:Create(Notification, Info, {Position = PositionTweenTo})
	TweenIn:Play()
	
	game:GetService('ReplicatedStorage').Storage.SFX['Notification']:Play()

	local Duration = Duration or 3

	task.delay(Duration, function()
		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local TweenOut = TweenService:Create(Notification, tweenInfo, {BackgroundTransparency = 1})
		local TweenOut2 = TweenService:Create(Notification, Info, {Position = UDim2.new(1, -260, -0.0252631605, 0)})

		TweenOut:Play()
		TweenOut2:Play()

		TweenOut.Completed:Connect(function()
			for i, v in ipairs(Notify.Cache) do
				if v == self then
					table.remove(Notify.Cache, i)
					break
				end
			end

			for i, v in ipairs(Notify.Cache) do
				local OffsetTweenTo = UDim2.new(1, -260, 0, (i - 1) * Notify.Offset)
				local OffsetTween = TweenService:Create(Notification, Info, {Position = OffsetTweenTo})
				OffsetTween:Play()
			end
			
			Notification:Destroy()
		end)
	end)
end

return Notify
