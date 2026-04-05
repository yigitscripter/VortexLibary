-- VortexLibrary v2.0
local VortexLibrary = {}
VortexLibrary._listeners = {}
VortexLibrary._notifStack = {}
VortexLibrary.CurrentTheme = "Dark"
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Themes = {
	Dark = {Bg=Color3.fromRGB(30,30,30),TitleBg=Color3.fromRGB(20,20,20),TabOff=Color3.fromRGB(40,40,40),TabOn=Color3.fromRGB(60,60,60),Content=Color3.fromRGB(25,25,25),Elem=Color3.fromRGB(45,45,45),ElemHover=Color3.fromRGB(55,55,55),TxtMain=Color3.fromRGB(255,255,255),TxtSub=Color3.fromRGB(200,200,200),Accent=Color3.fromRGB(100,100,255),ToggleOff=Color3.fromRGB(60,60,60),Bar=Color3.fromRGB(60,60,60)},
	Aqua = {Bg=Color3.fromRGB(15,35,45),TitleBg=Color3.fromRGB(10,25,35),TabOff=Color3.fromRGB(20,45,60),TabOn=Color3.fromRGB(30,65,85),Content=Color3.fromRGB(18,40,50),Elem=Color3.fromRGB(25,55,70),ElemHover=Color3.fromRGB(35,75,95),TxtMain=Color3.fromRGB(200,240,255),TxtSub=Color3.fromRGB(150,200,220),Accent=Color3.fromRGB(0,200,255),ToggleOff=Color3.fromRGB(30,60,75),Bar=Color3.fromRGB(40,80,100)},
	Purple = {Bg=Color3.fromRGB(35,20,45),TitleBg=Color3.fromRGB(25,15,35),TabOff=Color3.fromRGB(50,30,65),TabOn=Color3.fromRGB(70,45,90),Content=Color3.fromRGB(40,25,50),Elem=Color3.fromRGB(60,40,75),ElemHover=Color3.fromRGB(80,55,100),TxtMain=Color3.fromRGB(240,220,255),TxtSub=Color3.fromRGB(200,180,220),Accent=Color3.fromRGB(180,100,255),ToggleOff=Color3.fromRGB(60,45,75),Bar=Color3.fromRGB(80,60,100)},
	Midnight = {Bg=Color3.fromRGB(10,10,20),TitleBg=Color3.fromRGB(5,5,15),TabOff=Color3.fromRGB(15,15,30),TabOn=Color3.fromRGB(25,25,45),Content=Color3.fromRGB(12,12,22),Elem=Color3.fromRGB(20,20,35),ElemHover=Color3.fromRGB(30,30,50),TxtMain=Color3.fromRGB(220,220,240),TxtSub=Color3.fromRGB(160,160,180),Accent=Color3.fromRGB(100,150,255),ToggleOff=Color3.fromRGB(30,30,45),Bar=Color3.fromRGB(40,40,60)},
	Light = {Bg=Color3.fromRGB(240,240,240),TitleBg=Color3.fromRGB(220,220,220),TabOff=Color3.fromRGB(200,200,200),TabOn=Color3.fromRGB(180,180,180),Content=Color3.fromRGB(230,230,230),Elem=Color3.fromRGB(210,210,210),ElemHover=Color3.fromRGB(190,190,190),TxtMain=Color3.fromRGB(20,20,20),TxtSub=Color3.fromRGB(60,60,60),Accent=Color3.fromRGB(70,130,255),ToggleOff=Color3.fromRGB(160,160,160),Bar=Color3.fromRGB(180,180,180)}
}
function VortexLibrary:_addListener(fn)
	table.insert(self._listeners,fn)
end
function VortexLibrary:SetTheme(name)
	if not Themes[name] then return end
	self.CurrentTheme = name
	for _,fn in pairs(self._listeners) do
		pcall(function() fn(Themes[name]) end)
	end
end
function VortexLibrary:Notify(title,msg,dur,typ)
	dur = dur or 3
	typ = typ or "Info"
	local colors = {Info=Color3.fromRGB(0,150,255),Success=Color3.fromRGB(0,200,100),Warning=Color3.fromRGB(255,150,0),Error=Color3.fromRGB(220,50,50)}
	local col = colors[typ] or colors.Info
	pcall(function()
		local sg = Instance.new("ScreenGui")
		sg.Name = "VortexNotif"
		sg.DisplayOrder = 999
		sg.ResetOnSpawn = false
		sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		sg.Parent = CoreGui
		local card = Instance.new("Frame")
		card.Size = UDim2.new(0,280,0,75)
		card.Position = UDim2.new(1,10,1,-85-(#self._notifStack*82))
		card.BackgroundColor3 = Themes[self.CurrentTheme].Bg
		card.BorderSizePixel = 0
		card.Parent = sg
		Instance.new("UICorner",card).CornerRadius = UDim.new(0,8)
		local stroke = Instance.new("UIStroke",card)
		stroke.Color = col
		stroke.Thickness = 1
		local border = Instance.new("Frame")
		border.Size = UDim2.new(0,4,1,0)
		border.BackgroundColor3 = col
		border.BorderSizePixel = 0
		border.Parent = card
		Instance.new("UICorner",border).CornerRadius = UDim.new(0,4)
		local titleLbl = Instance.new("TextLabel")
		titleLbl.Size = UDim2.new(1,-15,0,18)
		titleLbl.Position = UDim2.new(0,10,0,6)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = title
		titleLbl.TextColor3 = Themes[self.CurrentTheme].TxtMain
		titleLbl.TextSize = 13
		titleLbl.Font = Enum.Font.GothamBold
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left
		titleLbl.Parent = card
		local msgLbl = Instance.new("TextLabel")
		msgLbl.Size = UDim2.new(1,-15,0,28)
		msgLbl.Position = UDim2.new(0,10,0,24)
		msgLbl.BackgroundTransparency = 1
		msgLbl.Text = msg
		msgLbl.TextColor3 = Themes[self.CurrentTheme].TxtSub
		msgLbl.TextSize = 11
		msgLbl.Font = Enum.Font.Gotham
		msgLbl.TextXAlignment = Enum.TextXAlignment.Left
		msgLbl.TextYAlignment = Enum.TextYAlignment.Top
		msgLbl.TextWrapped = true
		msgLbl.Parent = card
		local progBg = Instance.new("Frame")
		progBg.Size = UDim2.new(1,-16,0,3)
		progBg.Position = UDim2.new(0,8,1,-8)
		progBg.BackgroundColor3 = Color3.fromRGB(30,30,30)
		progBg.BorderSizePixel = 0
		progBg.Parent = card
		Instance.new("UICorner",progBg).CornerRadius = UDim.new(1,0)
		local progBar = Instance.new("Frame")
		progBar.Size = UDim2.new(1,0,1,0)
		progBar.BackgroundColor3 = col
		progBar.BorderSizePixel = 0
		progBar.Parent = progBg
		Instance.new("UICorner",progBar).CornerRadius = UDim.new(1,0)
		table.insert(self._notifStack,card)
		TweenService:Create(card,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.new(1,-290,1,-85-(#self._notifStack*82))}):Play()
		TweenService:Create(progBar,TweenInfo.new(dur,Enum.EasingStyle.Linear),{Size=UDim2.new(0,0,1,0)}):Play()
		task.delay(dur,function()
			TweenService:Create(card,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Position=UDim2.new(1,10,card.Position.Y.Scale,card.Position.Y.Offset)}):Play()
			task.wait(0.3)
			sg:Destroy()
			for i,v in pairs(self._notifStack) do
				if v == card then
					table.remove(self._notifStack,i)
					break
				end
			end
			for i,v in pairs(self._notifStack) do
				TweenService:Create(v,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.new(1,-290,1,-85-(i*82))}):Play()
			end
		end)
	end)
end
function VortexLibrary:AddFire(part,settings)
	pcall(function()
		if part:FindFirstChildOfClass("Fire") then part:FindFirstChildOfClass("Fire"):Destroy() end
		local fire = Instance.new("Fire")
		fire.Heat = settings.Heat or 9
		fire.Size = settings.Size or 5
		fire.Color = settings.Color or Color3.fromRGB(255,100,0)
		fire.SecondaryColor = settings.SecondaryColor or Color3.fromRGB(255,200,0)
		fire.Parent = part
		return fire
	end)
end
function VortexLibrary:RemoveFire(part)
	pcall(function()
		if part:FindFirstChildOfClass("Fire") then part:FindFirstChildOfClass("Fire"):Destroy() end
	end)
end
function VortexLibrary:AddSparkles(part,color)
	pcall(function()
		if part:FindFirstChildOfClass("Sparkles") then part:FindFirstChildOfClass("Sparkles"):Destroy() end
		local sparkles = Instance.new("Sparkles")
		sparkles.SparkleColor = color or Color3.fromRGB(255,255,255)
		sparkles.Parent = part
		return sparkles
	end)
end
function VortexLibrary:RemoveSparkles(part)
	pcall(function()
		if part:FindFirstChildOfClass("Sparkles") then part:FindFirstChildOfClass("Sparkles"):Destroy() end
	end)
end
function VortexLibrary:AddSmoke(part,settings)
	pcall(function()
		if part:FindFirstChildOfClass("Smoke") then part:FindFirstChildOfClass("Smoke"):Destroy() end
		local smoke = Instance.new("Smoke")
		smoke.Color = settings.Color or Color3.fromRGB(100,100,100)
		smoke.Opacity = settings.Opacity or 0.5
		smoke.RiseVelocity = settings.RiseVelocity or 1
		smoke.Size = settings.Size or 5
		smoke.Parent = part
		return smoke
	end)
end
function VortexLibrary:RemoveSmoke(part)
	pcall(function()
		if part:FindFirstChildOfClass("Smoke") then part:FindFirstChildOfClass("Smoke"):Destroy() end
	end)
end
function VortexLibrary:AddGlow(part,color,brightness,range)
	pcall(function()
		if part:FindFirstChildOfClass("PointLight") then part:FindFirstChildOfClass("PointLight"):Destroy() end
		local light = Instance.new("PointLight")
		light.Color = color or Color3.fromRGB(255,255,255)
		light.Brightness = brightness or 2
		light.Range = range or 15
		light.Parent = part
		return light
	end)
end
function VortexLibrary:RemoveGlow(part)
	pcall(function()
		if part:FindFirstChildOfClass("PointLight") then part:FindFirstChildOfClass("PointLight"):Destroy() end
	end)
end
function VortexLibrary:ClearEffects(part)
	pcall(function()
		for _,v in pairs(part:GetChildren()) do
			if v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Smoke") or v:IsA("PointLight") or v:IsA("ParticleEmitter") then
				v:Destroy()
			end
		end
	end)
end
function VortexLibrary:CreateDebugTab(winObj)
	local tab = winObj:CreateTab("🔧 Debug")
	tab:CreateSection("📊 Sistem")
	tab:CreateButton("Sistem Raporu",function()
		local player = Players.LocalPlayer
		pcall(function() print("Ad: "..player.Name) end)
		pcall(function() print("ID: "..player.UserId) end)
		pcall(function() print("Memory: "..math.floor(collectgarbage("count")).." KB") end)
		pcall(function()
			local fps = 0
			local lastTick = tick()
			local conn
			conn = RunService.Heartbeat:Connect(function()
				fps = math.floor(1/(tick()-lastTick))
				lastTick = tick()
				conn:Disconnect()
				print("FPS: "..fps)
			end)
		end)
		pcall(function()
			local ping = player:GetNetworkPing()*1000
			print("Ping: "..math.floor(ping).." ms")
		end)
		pcall(function()
			if player.Character then
				local hum = player.Character:FindFirstChild("Humanoid")
				if hum then
					print("WalkSpeed: "..hum.WalkSpeed)
					print("JumpPower: "..hum.JumpPower)
					print("Health: "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth))
				end
				local hrp = player.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					local pos = hrp.Position
					print("Position: "..math.floor(pos.X).." "..math.floor(pos.Y).." "..math.floor(pos.Z))
				end
			end
		end)
	end)
	tab:CreateSection("🔔 Bildirim")
	tab:CreateButton("4 Tip Bildirim Test",function()
		task.spawn(function()
			VortexLibrary:Notify("Bilgi","Bu bir Info bildirimi",2,"Info")
			task.wait(0.5)
			VortexLibrary:Notify("Başarılı","Bu bir Success bildirimi",2,"Success")
			task.wait(0.5)
			VortexLibrary:Notify("Uyarı","Bu bir Warning bildirimi",2,"Warning")
			task.wait(0.5)
			VortexLibrary:Notify("Hata","Bu bir Error bildirimi",2,"Error")
		end)
	end)
	tab:CreateSection("🎨 Tema")
	tab:CreateButton("Tema Turu",function()
		task.spawn(function()
			local themes = {"Dark","Aqua","Purple","Midnight","Light","Dark"}
			for _,t in ipairs(themes) do
				VortexLibrary:SetTheme(t)
				task.wait(1.5)
			end
		end)
	end)
	tab:CreateSection("✨ Efekt")
	local fireOn = false
	tab:CreateButton("🔥 Karakter Fire Test",function()
		pcall(function()
			local root = Players.LocalPlayer.Character.HumanoidRootPart
			fireOn = not fireOn
			if fireOn then
				VortexLibrary:AddFire(root,{Heat=9,Size=7,Color=Color3.fromRGB(255,80,0),SecondaryColor=Color3.fromRGB(255,220,0)})
			else
				VortexLibrary:RemoveFire(root)
			end
		end)
	end)
	local sparkleOn = false
	tab:CreateButton("❄️ Karakter Sparkle Test",function()
		pcall(function()
			local root = Players.LocalPlayer.Character.HumanoidRootPart
			sparkleOn = not sparkleOn
			if sparkleOn then
				VortexLibrary:AddSparkles(root,Color3.fromRGB(100,200,255))
			else
				VortexLibrary:RemoveSparkles(root)
			end
		end)
	end)
	local smokeOn = false
	tab:CreateButton("💜 Karakter Smoke Test",function()
		pcall(function()
			local root = Players.LocalPlayer.Character.HumanoidRootPart
			smokeOn = not smokeOn
			if smokeOn then
				VortexLibrary:AddSmoke(root,{Color=Color3.fromRGB(180,100,255),Opacity=0.4,RiseVelocity=5,Size=3})
			else
				VortexLibrary:RemoveSmoke(root)
			end
		end)
	end)
	tab:CreateButton("🌟 Tüm Efektleri Temizle",function()
		pcall(function()
			local root = Players.LocalPlayer.Character.HumanoidRootPart
			VortexLibrary:ClearEffects(root)
			fireOn = false
			sparkleOn = false
			smokeOn = false
		end)
	end)
	tab:CreateSection("🛠️ Araçlar")
	tab:CreateButton("FPS Test (3s)",function()
		task.spawn(function()
			local frames = 0
			local startTime = tick()
			local conn
			conn = RunService.Heartbeat:Connect(function()
				frames = frames + 1
				if tick()-startTime >= 3 then
					conn:Disconnect()
					local avgFps = math.floor(frames/3)
					print("Ortalama FPS (3s): "..avgFps)
				end
			end)
		end)
	end)
	tab:CreateButton("GUI Temizle",function()
		for _,v in pairs(CoreGui:GetChildren()) do
			if v.Name == "UILibrary" or v.Name == "VortexNotif" then
				v:Destroy()
			end
		end
	end)
	tab:CreateButton("Karakter Parçaları",function()
		pcall(function()
			local player = Players.LocalPlayer
			if player.Character then
				print("=== KARAKTER PARÇALARI ===")
				for _,v in pairs(player.Character:GetChildren()) do
					print("["..v.ClassName.."] "..v.Name)
				end
			end
		end)
	end)
end
function VortexLibrary:CreateWindow(title,size)
	local theme = Themes[self.CurrentTheme]
	local sg = Instance.new("ScreenGui")
	sg.Name = "UILibrary"
	sg.ResetOnSpawn = false
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	local win = Instance.new("Frame")
	win.Name = "Window"
	win.Size = UDim2.new(0,0,0,0)
	win.Position = UDim2.new(0.5,-250,0.5,-200)
	win.BackgroundColor3 = theme.Bg
	win.BackgroundTransparency = 1
	win.BorderSizePixel = 0
	win.Parent = sg
	Instance.new("UICorner",win).CornerRadius = UDim.new(0,6)
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1,0,0,30)
	titleBar.BackgroundColor3 = theme.TitleBg
	titleBar.BorderSizePixel = 0
	titleBar.Parent = win
	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1,-80,1,0)
	titleLbl.Position = UDim2.new(0,10,0,0)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title or "Vortex Library"
	titleLbl.TextColor3 = theme.TxtMain
	titleLbl.TextSize = 14
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.Parent = titleBar
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0,22,0,22)
	closeBtn.Position = UDim2.new(1,-26,0,4)
	closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
	closeBtn.BorderSizePixel = 0
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
	closeBtn.TextSize = 12
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.Parent = titleBar
	Instance.new("UICorner",closeBtn).CornerRadius = UDim.new(1,0)
	local minBtn = Instance.new("TextButton")
	minBtn.Size = UDim2.new(0,22,0,22)
	minBtn.Position = UDim2.new(1,-52,0,4)
	minBtn.BackgroundColor3 = Color3.fromRGB(200,150,50)
	minBtn.BorderSizePixel = 0
	minBtn.Text = "–"
	minBtn.TextColor3 = Color3.fromRGB(255,255,255)
	minBtn.TextSize = 12
	minBtn.Font = Enum.Font.GothamBold
	minBtn.Parent = titleBar
	Instance.new("UICorner",minBtn).CornerRadius = UDim.new(1,0)
	local maxBtn = Instance.new("TextButton")
	maxBtn.Size = UDim2.new(0,22,0,22)
	maxBtn.Position = UDim2.new(1,-78,0,4)
	maxBtn.BackgroundColor3 = Color3.fromRGB(50,200,100)
	maxBtn.BorderSizePixel = 0
	maxBtn.Text = "⊡"
	maxBtn.TextColor3 = Color3.fromRGB(255,255,255)
	maxBtn.TextSize = 12
	maxBtn.Font = Enum.Font.GothamBold
	maxBtn.Parent = titleBar
	Instance.new("UICorner",maxBtn).CornerRadius = UDim.new(1,0)
	local tabContainer = Instance.new("Frame")
	tabContainer.Size = UDim2.new(1,-10,0,30)
	tabContainer.Position = UDim2.new(0,5,0,35)
	tabContainer.BackgroundTransparency = 1
	tabContainer.Parent = win
	local tabLayout = Instance.new("UIListLayout")
	tabLayout.FillDirection = Enum.FillDirection.Horizontal
	tabLayout.Padding = UDim.new(0,5)
	tabLayout.Parent = tabContainer
	local contentContainer = Instance.new("Frame")
	contentContainer.Size = UDim2.new(1,-10,1,-75)
	contentContainer.Position = UDim2.new(0,5,0,70)
	contentContainer.BackgroundColor3 = theme.Content
	contentContainer.BorderSizePixel = 0
	contentContainer.Parent = win
	Instance.new("UICorner",contentContainer).CornerRadius = UDim.new(0,4)
	local dragging,dragInput,mousePos,framePos = false,nil,nil,nil
	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = input.Position
			framePos = win.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	titleBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			local vpSize = workspace.CurrentCamera.ViewportSize
			local winSize = win.AbsoluteSize
			local clampedX = math.clamp(framePos.X.Offset+delta.X,0,vpSize.X-winSize.X)
			local clampedY = math.clamp(framePos.Y.Offset+delta.Y,0,vpSize.Y-winSize.Y)
			win.Position = UDim2.new(0,clampedX,0,clampedY)
		end
	end)
	local originalSize = size or UDim2.new(0,500,0,400)
	local originalPos = UDim2.new(0.5,-250,0.5,-200)
	local minimized = false
	local maximized = false
	closeBtn.MouseButton1Click:Connect(function()
		TweenService:Create(win,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0),BackgroundTransparency=1}):Play()
		task.wait(0.4)
		sg:Destroy()
	end)
	minBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			TweenService:Create(win,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(originalSize.X.Scale,originalSize.X.Offset,0,30)}):Play()
			tabContainer.Visible = false
			contentContainer.Visible = false
		else
			TweenService:Create(win,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=originalSize}):Play()
			tabContainer.Visible = true
			contentContainer.Visible = true
		end
	end)
	maxBtn.MouseButton1Click:Connect(function()
		maximized = not maximized
		if maximized then
			TweenService:Create(win,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,1,0),Position=UDim2.new(0,0,0,0)}):Play()
		else
			TweenService:Create(win,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=originalSize,Position=originalPos}):Play()
		end
	end)
	sg.Parent = CoreGui
	TweenService:Create(win,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=originalSize,BackgroundTransparency=0}):Play()
	local winObj = {}
	winObj.Tabs = {}
	VortexLibrary:_addListener(function(t)
		TweenService:Create(win,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=t.Bg}):Play()
		TweenService:Create(titleBar,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=t.TitleBg}):Play()
		TweenService:Create(titleLbl,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{TextColor3=t.TxtMain}):Play()
		TweenService:Create(contentContainer,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=t.Content}):Play()
	end)
	function winObj:CreateTab(name)
		local theme = Themes[VortexLibrary.CurrentTheme]
		local tabBtn = Instance.new("TextButton")
		tabBtn.Size = UDim2.new(0,100,1,0)
		tabBtn.BackgroundColor3 = theme.TabOff
		tabBtn.BorderSizePixel = 0
		tabBtn.Text = name
		tabBtn.TextColor3 = theme.TxtSub
		tabBtn.TextSize = 12
		tabBtn.Font = Enum.Font.Gotham
		tabBtn.Parent = tabContainer
		Instance.new("UICorner",tabBtn).CornerRadius = UDim.new(0,4)
		local tabContent = Instance.new("Frame")
		tabContent.Size = UDim2.new(1,0,1,0)
		tabContent.BackgroundTransparency = 1
		tabContent.Visible = false
		tabContent.Parent = contentContainer
		local scrollFrame = Instance.new("ScrollingFrame")
		scrollFrame.Size = UDim2.new(1,-10,1,-10)
		scrollFrame.Position = UDim2.new(0,5,0,5)
		scrollFrame.BackgroundTransparency = 1
		scrollFrame.BorderSizePixel = 0
		scrollFrame.ScrollBarThickness = 4
		scrollFrame.ScrollBarImageColor3 = theme.Bar
		scrollFrame.Parent = tabContent
		local contentLayout = Instance.new("UIListLayout")
		contentLayout.Padding = UDim.new(0,5)
		contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
		contentLayout.Parent = scrollFrame
		contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			scrollFrame.CanvasSize = UDim2.new(0,0,0,contentLayout.AbsoluteContentSize.Y+10)
		end)
		local tabObj = {}
		tabObj.Button = tabBtn
		tabObj.Content = tabContent
		tabObj.ScrollFrame = scrollFrame
		tabObj.Name = name
		tabObj._order = 0
		VortexLibrary:_addListener(function(t)
			TweenService:Create(scrollFrame,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{ScrollBarImageColor3=t.Bar}):Play()
		end)
		function tabObj:CreateSection(text)
			self._order = self._order + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1,-10,0,24)
			frame.BackgroundTransparency = 1
			frame.LayoutOrder = self._order
			frame.Parent = scrollFrame
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1,0,1,0)
			lbl.BackgroundTransparency = 1
			lbl.Text = "▸ "..text
			lbl.TextColor3 = theme.Accent
			lbl.TextSize = 11
			lbl.Font = Enum.Font.GothamBold
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = frame
			VortexLibrary:_addListener(function(t)
				lbl.TextColor3 = t.Accent
			end)
			return frame
		end
		function tabObj:CreateLabel(text)
			self._order = self._order + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1,-10,0,20)
			frame.BackgroundTransparency = 1
			frame.LayoutOrder = self._order
			frame.Parent = scrollFrame
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1,0,1,0)
			lbl.BackgroundTransparency = 1
			lbl.Text = text
			lbl.TextColor3 = theme.TxtSub
			lbl.TextSize = 12
			lbl.Font = Enum.Font.Gotham
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.TextWrapped = true
			lbl.Parent = frame
			VortexLibrary:_addListener(function(t)
				lbl.TextColor3 = t.TxtSub
			end)
			return frame
		end
		function tabObj:CreateButton(text,callback)
			self._order = self._order + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,-10,0,35)
			btn.BackgroundColor3 = theme.Elem
			btn.BorderSizePixel = 0
			btn.Text = text or "Button"
			btn.TextColor3 = theme.TxtMain
			btn.TextSize = 13
			btn.Font = Enum.Font.Gotham
			btn.LayoutOrder = self._order
			btn.Parent = scrollFrame
			Instance.new("UICorner",btn).CornerRadius = UDim.new(0,4)
			btn.MouseEnter:Connect(function()
				TweenService:Create(btn,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=theme.ElemHover}):Play()
			end)
			btn.MouseLeave:Connect(function()
				TweenService:Create(btn,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=theme.Elem}):Play()
			end)
			btn.MouseButton1Click:Connect(function()
				TweenService:Create(btn,TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=theme.Accent}):Play()
				task.wait(0.1)
				TweenService:Create(btn,TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=theme.Elem}):Play()
				if callback then pcall(callback) end
			end)
			VortexLibrary:_addListener(function(t)
				btn.BackgroundColor3 = t.Elem
				btn.TextColor3 = t.TxtMain
			end)
			return btn
		end
		function tabObj:CreateToggle(text,default,callback)
			self._order = self._order + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local toggled = default or false
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1,-10,0,36)
			frame.BackgroundColor3 = theme.Elem
			frame.BorderSizePixel = 0
			frame.LayoutOrder = self._order
			frame.Parent = scrollFrame
			Instance.new("UICorner",frame).CornerRadius = UDim.new(0,6)
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1,-50,1,0)
			lbl.Position = UDim2.new(0,10,0,0)
			lbl.BackgroundTransparency = 1
			lbl.Text = text or "Toggle"
			lbl.TextColor3 = theme.TxtMain
			lbl.TextSize = 13
			lbl.Font = Enum.Font.Gotham
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = frame
			local track = Instance.new("Frame")
			track.Size = UDim2.new(0,38,0,20)
			track.Position = UDim2.new(1,-44,0.5,-10)
			track.BackgroundColor3 = toggled and theme.Accent or theme.ToggleOff
			track.BorderSizePixel = 0
			track.Parent = frame
			Instance.new("UICorner",track).CornerRadius = UDim.new(1,0)
			local knob = Instance.new("Frame")
			knob.Size = UDim2.new(0,14,0,14)
			knob.Position = toggled and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
			knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
			knob.BorderSizePixel = 0
			knob.Parent = track
			Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,0,1,0)
			btn.BackgroundTransparency = 1
			btn.Text = ""
			btn.Parent = frame
			local toggleObj = {Value=toggled}
			function toggleObj:Set(val)
				toggled = val
				self.Value = val
				TweenService:Create(track,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=toggled and theme.Accent or theme.ToggleOff}):Play()
				TweenService:Create(knob,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=toggled and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)}):Play()
			end
			btn.MouseButton1Click:Connect(function()
				toggled = not toggled
				toggleObj.Value = toggled
				TweenService:Create(track,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=toggled and theme.Accent or theme.ToggleOff}):Play()
				TweenService:Create(knob,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=toggled and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)}):Play()
				if callback then pcall(function() callback(toggled) end) end
			end)
			VortexLibrary:_addListener(function(t)
				frame.BackgroundColor3 = t.Elem
				lbl.TextColor3 = t.TxtMain
				track.BackgroundColor3 = toggled and t.Accent or t.ToggleOff
			end)
			return toggleObj
		end
		function tabObj:CreateSlider(text,min,max,default,callback)
			self._order = self._order + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local value = default or min
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1,-10,0,55)
			frame.BackgroundColor3 = theme.Elem
			frame.BorderSizePixel = 0
			frame.LayoutOrder = self._order
			frame.Parent = scrollFrame
			Instance.new("UICorner",frame).CornerRadius = UDim.new(0,6)
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(0.7,0,0,18)
			lbl.Position = UDim2.new(0,10,0,6)
			lbl.BackgroundTransparency = 1
			lbl.Text = text or "Slider"
			lbl.TextColor3 = theme.TxtMain
			lbl.TextSize = 12
			lbl.Font = Enum.Font.Gotham
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = frame
			local valueLbl = Instance.new("TextLabel")
			valueLbl.Size = UDim2.new(0.3,-10,0,18)
			valueLbl.Position = UDim2.new(0.7,0,0,6)
			valueLbl.BackgroundTransparency = 1
			valueLbl.Text = tostring(value)
			valueLbl.TextColor3 = theme.Accent
			valueLbl.TextSize = 12
			valueLbl.Font = Enum.Font.GothamBold
			valueLbl.TextXAlignment = Enum.TextXAlignment.Right
			valueLbl.Parent = frame
			local trackBg = Instance.new("Frame")
			trackBg.Size = UDim2.new(1,-20,0,6)
			trackBg.Position = UDim2.new(0,10,1,-14)
			trackBg.BackgroundColor3 = Color3.fromRGB(30,30,30)
			trackBg.BorderSizePixel = 0
			trackBg.Parent = frame
			Instance.new("UICorner",trackBg).CornerRadius = UDim.new(1,0)
			local fill = Instance.new("Frame")
			fill.Size = UDim2.new((value-min)/(max-min),0,1,0)
			fill.BackgroundColor3 = theme.Accent
			fill.BorderSizePixel = 0
			fill.Parent = trackBg
			Instance.new("UICorner",fill).CornerRadius = UDim.new(1,0)
			local knob = Instance.new("Frame")
			knob.Size = UDim2.new(0,10,0,10)
			knob.Position = UDim2.new((value-min)/(max-min),-5,0.5,-5)
			knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
			knob.BorderSizePixel = 0
			knob.Parent = trackBg
			Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,0,1,0)
			btn.BackgroundTransparency = 1
			btn.Text = ""
			btn.Parent = frame
			local dragging = false
			local sliderObj = {Value=value}
			function sliderObj:Set(val)
				value = math.clamp(val,min,max)
				self.Value = value
				valueLbl.Text = tostring(value)
				local relative = (value-min)/(max-min)
				fill.Size = UDim2.new(relative,0,1,0)
				knob.Position = UDim2.new(relative,-5,0.5,-5)
			end
			btn.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local mousePos = UserInputService:GetMouseLocation().X
					local trackPos = trackBg.AbsolutePosition.X
					local trackSize = trackBg.AbsoluteSize.X
					local relative = math.clamp((mousePos-trackPos)/trackSize,0,1)
					value = math.floor(min+(max-min)*relative)
					sliderObj.Value = value
					valueLbl.Text = tostring(value)
					fill.Size = UDim2.new(relative,0,1,0)
					knob.Position = UDim2.new(relative,-5,0.5,-5)
					if callback then pcall(function() callback(value) end) end
				end
			end)
			VortexLibrary:_addListener(function(t)
				frame.BackgroundColor3 = t.Elem
				lbl.TextColor3 = t.TxtMain
				valueLbl.TextColor3 = t.Accent
				fill.BackgroundColor3 = t.Accent
			end)
			return sliderObj
		end
		function tabObj:CreateTextbox(labelText,placeholder,callback)
			self._order = self._order + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1,-10,0,36)
			frame.BackgroundColor3 = theme.Elem
			frame.BorderSizePixel = 0
			frame.LayoutOrder = self._order
			frame.Parent = scrollFrame
			Instance.new("UICorner",frame).CornerRadius = UDim.new(0,6)
			local stroke = Instance.new("UIStroke")
			stroke.Color = theme.Elem
			stroke.Thickness = 0
			stroke.Parent = frame
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(0.4,0,1,0)
			lbl.Position = UDim2.new(0,10,0,0)
			lbl.BackgroundTransparency = 1
			lbl.Text = labelText or "Input"
			lbl.TextColor3 = theme.TxtMain
			lbl.TextSize = 12
			lbl.Font = Enum.Font.Gotham
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = frame
			local textboxBg = Instance.new("Frame")
			textboxBg.Size = UDim2.new(0.55,-10,0,26)
			textboxBg.Position = UDim2.new(0.4,0,0.5,-13)
			textboxBg.BackgroundColor3 = theme.Content
			textboxBg.BorderSizePixel = 0
			textboxBg.Parent = frame
			Instance.new("UICorner",textboxBg).CornerRadius = UDim.new(0,4)
			local textbox = Instance.new("TextBox")
			textbox.Size = UDim2.new(1,-10,1,0)
			textbox.Position = UDim2.new(0,5,0,0)
			textbox.BackgroundTransparency = 1
			textbox.PlaceholderText = placeholder or "Metin girin..."
			textbox.PlaceholderColor3 = theme.TxtSub
			textbox.Text = ""
			textbox.TextColor3 = theme.TxtMain
			textbox.TextSize = 12
			textbox.Font = Enum.Font.Gotham
			textbox.TextXAlignment = Enum.TextXAlignment.Left
			textbox.ClearTextOnFocus = false
			textbox.Parent = textboxBg
			local textboxObj = {Value=""}
			function textboxObj:Set(txt)
				textbox.Text = txt
				self.Value = txt
			end
			textbox.Focused:Connect(function()
				stroke.Thickness = 2
				TweenService:Create(stroke,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Color=theme.Accent}):Play()
			end)
			textbox.FocusLost:Connect(function()
				stroke.Thickness = 0
				TweenService:Create(stroke,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Color=theme.Elem}):Play()
				textboxObj.Value = textbox.Text
				if callback and textbox.Text ~= "" then pcall(function() callback(textbox.Text) end) end
			end)
			VortexLibrary:_addListener(function(t)
				frame.BackgroundColor3 = t.Elem
				stroke.Color = t.Elem
				lbl.TextColor3 = t.TxtMain
				textboxBg.BackgroundColor3 = t.Content
				textbox.TextColor3 = t.TxtMain
				textbox.PlaceholderColor3 = t.TxtSub
			end)
			return textboxObj
		end
		function tabObj:CreateDropdown(text,options,default,callback)
			self._order = self._order + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local isOpen = false
			local selected = default or (options[1] or "Seçiniz")
			local wrapper = Instance.new("Frame")
			wrapper.Size = UDim2.new(1,-10,0,36)
			wrapper.BackgroundColor3 = theme.Elem
			wrapper.BorderSizePixel = 0
			wrapper.LayoutOrder = self._order
			wrapper.ClipsDescendants = true
			wrapper.Parent = scrollFrame
			Instance.new("UICorner",wrapper).CornerRadius = UDim.new(0,6)
			local header = Instance.new("Frame")
			header.Size = UDim2.new(1,0,0,36)
			header.BackgroundTransparency = 1
			header.Parent = wrapper
			local headerBtn = Instance.new("TextButton")
			headerBtn.Size = UDim2.new(1,0,1,0)
			headerBtn.BackgroundTransparency = 1
			headerBtn.Text = ""
			headerBtn.Parent = header
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(0.4,-10,0,36)
			lbl.Position = UDim2.new(0,10,0,0)
			lbl.BackgroundTransparency = 1
			lbl.Text = text or "Dropdown"
			lbl.TextColor3 = theme.TxtMain
			lbl.TextSize = 12
			lbl.Font = Enum.Font.Gotham
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = header
			local selectedLbl = Instance.new("TextLabel")
			selectedLbl.Size = UDim2.new(0.5,-30,0,36)
			selectedLbl.Position = UDim2.new(0.4,0,0,0)
			selectedLbl.BackgroundTransparency = 1
			selectedLbl.Text = selected
			selectedLbl.TextColor3 = theme.Accent
			selectedLbl.TextSize = 12
			selectedLbl.Font = Enum.Font.GothamBold
			selectedLbl.TextXAlignment = Enum.TextXAlignment.Right
			selectedLbl.Parent = header
			local arrow = Instance.new("TextLabel")
			arrow.Size = UDim2.new(0,20,0,36)
			arrow.Position = UDim2.new(1,-24,0,0)
			arrow.BackgroundTransparency = 1
			arrow.Text = "▼"
			arrow.TextColor3 = theme.TxtSub
			arrow.TextSize = 10
			arrow.Font = Enum.Font.Gotham
			arrow.Parent = header
			local listFrame = Instance.new("Frame")
			listFrame.Size = UDim2.new(1,0,0,#options*30)
			listFrame.Position = UDim2.new(0,0,0,36)
			listFrame.BackgroundTransparency = 1
			listFrame.Parent = wrapper
			local listLayout = Instance.new("UIListLayout")
			listLayout.Padding = UDim.new(0,2)
			listLayout.Parent = listFrame
			local dropObj = {Value=selected}
			function dropObj:Set(val)
				selected = val
				self.Value = val
				selectedLbl.Text = val
			end
			function dropObj:Refresh(newOptions)
				for _,v in pairs(listFrame:GetChildren()) do
					if v:IsA("TextButton") then v:Destroy() end
				end
				options = newOptions
				listFrame.Size = UDim2.new(1,0,0,#options*30)
				for _,opt in ipairs(options) do
					local optBtn = Instance.new("TextButton")
					optBtn.Size = UDim2.new(1,-10,0,28)
					optBtn.Position = UDim2.new(0,5,0,0)
					optBtn.BackgroundColor3 = theme.Elem
					optBtn.BorderSizePixel = 0
					optBtn.Text = opt
					optBtn.TextColor3 = theme.TxtMain
					optBtn.TextSize = 11
					optBtn.Font = Enum.Font.Gotham
					optBtn.Parent = listFrame
					Instance.new("UICorner",optBtn).CornerRadius = UDim.new(0,4)
					optBtn.MouseEnter:Connect(function()
						TweenService:Create(optBtn,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=theme.ElemHover}):Play()
					end)
					optBtn.MouseLeave:Connect(function()
						TweenService:Create(optBtn,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=theme.Elem}):Play()
					end)
					optBtn.MouseButton1Click:Connect(function()
						selected = opt
						dropObj.Value = opt
						selectedLbl.Text = opt
						isOpen = false
						TweenService:Create(wrapper,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(1,-10,0,36)}):Play()
						if callback then pcall(function() callback(opt) end) end
					end)
				end
			end
			for _,opt in ipairs(options) do
				local optBtn = Instance.new("TextButton")
				optBtn.Size = UDim2.new(1,-10,0,28)
				optBtn.Position = UDim2.new(0,5,0,0)
				optBtn.BackgroundColor3 = theme.Elem
				optBtn.BorderSizePixel = 0
				optBtn.Text = opt
				optBtn.TextColor3 = theme.TxtMain
				optBtn.TextSize = 11
				optBtn.Font = Enum.Font.Gotham
				optBtn.Parent = listFrame
				Instance.new("UICorner",optBtn).CornerRadius = UDim.new(0,4)
				optBtn.MouseEnter:Connect(function()
					TweenService:Create(optBtn,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=theme.ElemHover}):Play()
				end)
				optBtn.MouseLeave:Connect(function()
					TweenService:Create(optBtn,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=theme.Elem}):Play()
				end)
				optBtn.MouseButton1Click:Connect(function()
					selected = opt
					dropObj.Value = opt
					selectedLbl.Text = opt
					isOpen = false
					TweenService:Create(wrapper,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(1,-10,0,36)}):Play()
					if callback then pcall(function() callback(opt) end) end
				end)
			end
			headerBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				local targetSize = isOpen and UDim2.new(1,-10,0,36+#options*30) or UDim2.new(1,-10,0,36)
				TweenService:Create(wrapper,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=targetSize}):Play()
			end)
			VortexLibrary:_addListener(function(t)
				wrapper.BackgroundColor3 = t.Elem
				lbl.TextColor3 = t.TxtMain
				selectedLbl.TextColor3 = t.Accent
				arrow.TextColor3 = t.TxtSub
			end)
			return dropObj
		end
		tabBtn.MouseButton1Click:Connect(function()
			local theme = Themes[VortexLibrary.CurrentTheme]
			for _,tab in pairs(winObj.Tabs) do
				tab.Content.Visible = false
				TweenService:Create(tab.Button,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=theme.TabOff,TextColor3=theme.TxtSub}):Play()
			end
			tabContent.Visible = true
			TweenService:Create(tabBtn,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=theme.Accent,TextColor3=theme.TxtMain}):Play()
		end)
		table.insert(winObj.Tabs,tabObj)
		if #winObj.Tabs == 1 then
			tabContent.Visible = true
			tabBtn.BackgroundColor3 = theme.Accent
			tabBtn.TextColor3 = theme.TxtMain
		end
		VortexLibrary:_addListener(function(t)
			if tabContent.Visible then
				tabBtn.BackgroundColor3 = t.Accent
				tabBtn.TextColor3 = t.TxtMain
			else
				tabBtn.BackgroundColor3 = t.TabOff
				tabBtn.TextColor3 = t.TxtSub
			end
		end)
		return tabObj
	end
	return winObj
end
_G.Vortex = VortexLibrary
--[[
╔══════════════════════════════════════════════════════════════════╗
║              VORTEX UI LIBRARY v2.0 — KULLANIM KILAVUZU         ║
║              Kodlama bilmeden harika GUI'ler yapmak için         ║
╚══════════════════════════════════════════════════════════════════╝

─────────────────────────────────────────────────────────────────
 ADIM 1: KÜTÜPHANEYİ YÜKLE
─────────────────────────────────────────────────────────────────

local Vortex = loadstring(game:HttpGet("SENIN_RAW_URL_BURAYA"))()

─────────────────────────────────────────────────────────────────
 ADIM 2: TEMA SEÇ (isteğe bağlı, varsayılan Dark)
─────────────────────────────────────────────────────────────────

Vortex:SetTheme("Dark")     -- Koyu (varsayılan)
Vortex:SetTheme("Aqua")     -- Mavi-cyan
Vortex:SetTheme("Purple")   -- Mor
Vortex:SetTheme("Midnight") -- Lacivert-siyah
Vortex:SetTheme("Light")    -- Açık

─────────────────────────────────────────────────────────────────
 ADIM 3: PENCERE OLUŞTUR
─────────────────────────────────────────────────────────────────

local Win = Vortex:CreateWindow("Başlık", UDim2.new(0, 520, 0, 430))

-- İkinci parametre isteğe bağlı, yazmasan da olur:
local Win = Vortex:CreateWindow("Benim Scriptim")

─────────────────────────────────────────────────────────────────
 ADIM 4: TAB EKLE
─────────────────────────────────────────────────────────────────

local Tab1 = Win:CreateTab("🏠 Ana")
local Tab2 = Win:CreateTab("⚙️ Ayarlar")
local Tab3 = Win:CreateTab("✨ Efektler")

─────────────────────────────────────────────────────────────────
 ADIM 5: ELEMENTLER EKLE
─────────────────────────────────────────────────────────────────

── BÖLÜM BAŞLIĞI ──────────────────────────────────────────────

Tab1:CreateSection("Hız Ayarları")

── BİLGİ YAZISI ───────────────────────────────────────────────

Tab1:CreateLabel("Bu bölümde karakterini özelleştirebilirsin.")

── BUTON ──────────────────────────────────────────────────────

Tab1:CreateButton("Tıkla Beni!", function()
    print("Buton çalıştı!")
end)

── TOGGLE (AÇMA/KAPATMA) ──────────────────────────────────────

local GodToggle = Tab1:CreateToggle("God Mode", false, function(aktif)
    if aktif then
        -- açıkken ne olacak
        game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge
        game.Players.LocalPlayer.Character.Humanoid.Health = math.huge
    else
        -- kapanınca ne olacak
        game.Players.LocalPlayer.Character.Humanoid.MaxHealth = 100
    end
end)

-- Sonradan değiştirmek için:
GodToggle:Set(true)  -- aç
GodToggle:Set(false) -- kapat

── SLIDER (KAYDIRICI) ─────────────────────────────────────────

local HizSlider = Tab1:CreateSlider("WalkSpeed", 16, 100, 16, function(deger)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = deger
end)

-- Sonradan değiştirmek için:
HizSlider:Set(50)

── TEXTBOX (YAZI GİRİŞİ) ──────────────────────────────────────

local IsimBox = Tab1:CreateTextbox("Oyuncu Adı", "buraya yaz...", function(metin)
    print("Girilen: " .. metin)
end)

-- Sonradan değiştirmek için:
IsimBox:Set("yeni metin")

── DROPDOWN (AÇILIR MENÜ) ─────────────────────────────────────

local TakimMenu = Tab1:CreateDropdown("Takım Seç", {"Kırmızı","Mavi","Yeşil"}, "Kırmızı", function(secim)
    print("Seçilen takım: " .. secim)
end)

-- Sonradan değiştirmek için:
TakimMenu:Set("Mavi")

-- Listeyi güncellemek için:
TakimMenu:Refresh({"Sarı", "Mor", "Turuncu"})

─────────────────────────────────────────────────────────────────
 BİLDİRİM GÖNDER
─────────────────────────────────────────────────────────────────

Vortex:Notify("Başlık", "Mesaj", 3, "Success")
                              --  ^    ^
                              -- saniye tip

-- Tipler:
Vortex:Notify("Bilgi", "Normal bilgi.", 3, "Info")
Vortex:Notify("Başardın", "İşlem tamam!", 3, "Success")
Vortex:Notify("Dikkat", "Bir şeye dikkat et!", 3, "Warning")
Vortex:Notify("Hata", "Bir şey ters gitti.", 3, "Error")

─────────────────────────────────────────────────────────────────
 EFEKT EKLE / KALDIR
─────────────────────────────────────────────────────────────────

local karakter = game.Players.LocalPlayer.Character
local rootPart = karakter.HumanoidRootPart

-- Ateş efekti ekle:
Vortex:AddFire(rootPart, {
    Heat = 9,
    Size = 7,
    Color = Color3.fromRGB(255, 80, 0),
    SecondaryColor = Color3.fromRGB(255, 220, 0)
})

-- Ateşi kaldır:
Vortex:RemoveFire(rootPart)

-- Parıltı efekti ekle:
Vortex:AddSparkles(rootPart, Color3.fromRGB(100, 200, 255))

-- Parıltıyı kaldır:
Vortex:RemoveSparkles(rootPart)

-- Duman efekti ekle:
Vortex:AddSmoke(rootPart, {
    Color = Color3.fromRGB(180, 100, 255),
    Opacity = 0.4,
    RiseVelocity = 5,
    Size = 3
})

-- Dumanı kaldır:
Vortex:RemoveSmoke(rootPart)

-- Işık efekti ekle:
Vortex:AddGlow(rootPart, Color3.fromRGB(0, 200, 255), 3, 20)

-- Işığı kaldır:
Vortex:RemoveGlow(rootPart)

-- Tüm efektleri tek seferde kaldır:
Vortex:ClearEffects(rootPart)

─────────────────────────────────────────────────────────────────
 DEBUG PANELI EKLE (hata ayıklama için)
─────────────────────────────────────────────────────────────────

Vortex:CreateDebugTab(Win)

-- Bu satır, pencerenize otomatik "🔧 Debug" tabı ekler.
-- İçinde sistem raporu, efekt testleri, tema turu ve araçlar var.

─────────────────────────────────────────────────────────────────
 TAM ÖRNEK SCRIPT
─────────────────────────────────────────────────────────────────

local Vortex = loadstring(game:HttpGet("SENIN_RAW_URL"))()
Vortex:SetTheme("Aqua")

local Win = Vortex:CreateWindow("✨ Süper Script")

local Ana = Win:CreateTab("🏠 Ana")
local Efekt = Win:CreateTab("✨ Efektler")

-- Ana tab
Ana:CreateSection("Karakter")

Ana:CreateSlider("WalkSpeed", 16, 100, 16, function(h)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = h
end)

Ana:CreateSlider("JumpPower", 50, 300, 50, function(h)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = h
end)

Ana:CreateToggle("God Mode", false, function(a)
    local hum = game.Players.LocalPlayer.Character.Humanoid
    hum.MaxHealth = a and math.huge or 100
    hum.Health = hum.MaxHealth
end)

-- Efekt tab
Efekt:CreateSection("Görsel Efektler")

local atesAcik = false
Efekt:CreateButton("🔥 Ateş Efekti Aç/Kapat", function()
    local root = game.Players.LocalPlayer.Character.HumanoidRootPart
    atesAcik = not atesAcik
    if atesAcik then
        Vortex:AddFire(root, {Heat=9, Size=7, Color=Color3.fromRGB(255,80,0), SecondaryColor=Color3.fromRGB(255,220,0)})
        Vortex:AddGlow(root, Color3.fromRGB(255,120,0), 3, 20)
        Vortex:Notify("Efekt", "🔥 Ateş açıldı!", 2, "Success")
    else
        Vortex:RemoveFire(root)
        Vortex:RemoveGlow(root)
        Vortex:Notify("Efekt", "Ateş kapatıldı.", 2, "Info")
    end
end)

Efekt:CreateButton("❄️ Buz Efekti Aç/Kapat", function()
    local root = game.Players.LocalPlayer.Character.HumanoidRootPart
    if root:FindFirstChildOfClass("Sparkles") then
        Vortex:RemoveSparkles(root)
        Vortex:RemoveGlow(root)
        Vortex:Notify("Efekt", "Buz kapatıldı.", 2, "Info")
    else
        Vortex:AddSparkles(root, Color3.fromRGB(100, 200, 255))
        Vortex:AddGlow(root, Color3.fromRGB(100, 200, 255), 2, 15)
        Vortex:Notify("Efekt", "❄️ Buz açıldı!", 2, "Success")
    end
end)

Efekt:CreateButton("🌟 Tüm Efektleri Temizle", function()
    local root = game.Players.LocalPlayer.Character.HumanoidRootPart
    Vortex:ClearEffects(root)
    atesAcik = false
    Vortex:Notify("Temizlendi", "Tüm efektler kaldırıldı.", 2, "Warning")
end)

-- Debug paneli
Vortex:CreateDebugTab(Win)

Vortex:Notify("Hazır!", "Script başarıyla yüklendi 🚀", 4, "Success")

╔══════════════════════════════════════════════════════════════════╗
║              KISA ÖZET — NEYİ NE ZAMAN KULLANIRSIN              ║
╠══════════════════════════════════════════════════════════════════╣
║  CreateSection   → Bölüm başlığı (görsel ayraç)                 ║
║  CreateLabel     → Bilgi yazısı                                  ║
║  CreateButton    → Tıklanabilir buton                            ║
║  CreateToggle    → Açma/Kapatma switch'i                         ║
║  CreateSlider    → Sayısal değer seçici (WalkSpeed gibi)        ║
║  CreateTextbox   → Kullanıcıdan yazı alma                        ║
║  CreateDropdown  → Listeden seçim yaptırma                       ║
║  Notify          → Ekranda bildiri gösterme                      ║
║  AddFire         → Karaktere ateş efekti                         ║
║  AddSparkles     → Karaktere parıltı efekti                      ║
║  AddSmoke        → Karaktere duman efekti                        ║
║  AddGlow         → Karaktere ışık efekti                         ║
║  ClearEffects    → Tüm efektleri temizle                         ║
╚══════════════════════════════════════════════════════════════════╝
]]

return VortexLibrary
