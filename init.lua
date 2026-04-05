-- VortexLibrary v2.0
local VortexLibrary = {}
VortexLibrary._listeners = {}
VortexLibrary.CurrentTheme = "Dark"
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Themes = {
	Dark = {Background=Color3.fromRGB(30,30,30),TitleBar=Color3.fromRGB(20,20,20),TabInactive=Color3.fromRGB(40,40,40),TabActive=Color3.fromRGB(60,60,60),Content=Color3.fromRGB(25,25,25),Element=Color3.fromRGB(45,45,45),ElementHover=Color3.fromRGB(55,55,55),TextMain=Color3.fromRGB(255,255,255),TextSub=Color3.fromRGB(200,200,200),Accent=Color3.fromRGB(100,100,255),ToggleOff=Color3.fromRGB(60,60,60),ScrollBar=Color3.fromRGB(60,60,60)},
	Aqua = {Background=Color3.fromRGB(15,35,45),TitleBar=Color3.fromRGB(10,25,35),TabInactive=Color3.fromRGB(20,45,60),TabActive=Color3.fromRGB(30,65,85),Content=Color3.fromRGB(18,40,50),Element=Color3.fromRGB(25,55,70),ElementHover=Color3.fromRGB(35,75,95),TextMain=Color3.fromRGB(200,240,255),TextSub=Color3.fromRGB(150,200,220),Accent=Color3.fromRGB(0,200,255),ToggleOff=Color3.fromRGB(30,60,75),ScrollBar=Color3.fromRGB(40,80,100)},
	Purple = {Background=Color3.fromRGB(35,20,45),TitleBar=Color3.fromRGB(25,15,35),TabInactive=Color3.fromRGB(50,30,65),TabActive=Color3.fromRGB(70,45,90),Content=Color3.fromRGB(40,25,50),Element=Color3.fromRGB(60,40,75),ElementHover=Color3.fromRGB(80,55,100),TextMain=Color3.fromRGB(240,220,255),TextSub=Color3.fromRGB(200,180,220),Accent=Color3.fromRGB(180,100,255),ToggleOff=Color3.fromRGB(60,45,75),ScrollBar=Color3.fromRGB(80,60,100)},
	Midnight = {Background=Color3.fromRGB(10,10,20),TitleBar=Color3.fromRGB(5,5,15),TabInactive=Color3.fromRGB(15,15,30),TabActive=Color3.fromRGB(25,25,45),Content=Color3.fromRGB(12,12,22),Element=Color3.fromRGB(20,20,35),ElementHover=Color3.fromRGB(30,30,50),TextMain=Color3.fromRGB(220,220,240),TextSub=Color3.fromRGB(160,160,180),Accent=Color3.fromRGB(100,150,255),ToggleOff=Color3.fromRGB(30,30,45),ScrollBar=Color3.fromRGB(40,40,60)},
	Light = {Background=Color3.fromRGB(240,240,240),TitleBar=Color3.fromRGB(220,220,220),TabInactive=Color3.fromRGB(200,200,200),TabActive=Color3.fromRGB(180,180,180),Content=Color3.fromRGB(230,230,230),Element=Color3.fromRGB(210,210,210),ElementHover=Color3.fromRGB(190,190,190),TextMain=Color3.fromRGB(20,20,20),TextSub=Color3.fromRGB(60,60,60),Accent=Color3.fromRGB(70,130,255),ToggleOff=Color3.fromRGB(160,160,160),ScrollBar=Color3.fromRGB(180,180,180)}
}
function VortexLibrary:SetTheme(name)
	if not Themes[name] then return end
	self.CurrentTheme = name
	for _,listener in pairs(self._listeners) do
		pcall(function() listener(Themes[name]) end)
	end
end
function VortexLibrary:Notify(title,message,duration,notifType)
	duration = duration or 3
	notifType = notifType or "Info"
	local typeColors = {Info=Color3.fromRGB(100,150,255),Success=Color3.fromRGB(50,200,100),Warning=Color3.fromRGB(255,180,50),Error=Color3.fromRGB(255,80,80)}
	local color = typeColors[notifType] or typeColors.Info
	pcall(function()
		local sg = Instance.new("ScreenGui")
		sg.Name = "VortexNotif"
		sg.DisplayOrder = 999
		sg.ResetOnSpawn = false
		sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		sg.Parent = CoreGui
		local existing = 0
		for _,v in pairs(CoreGui:GetChildren()) do
			if v.Name == "VortexNotif" and v ~= sg then existing = existing + 1 end
		end
		local card = Instance.new("Frame")
		card.Size = UDim2.new(0,280,0,70)
		card.Position = UDim2.new(1,10,1,-80-(existing*80))
		card.BackgroundColor3 = Themes[VortexLibrary.CurrentTheme].Element
		card.BorderSizePixel = 0
		card.Parent = sg
		Instance.new("UICorner",card).CornerRadius = UDim.new(0,6)
		local border = Instance.new("Frame")
		border.Size = UDim2.new(0,4,1,0)
		border.BackgroundColor3 = color
		border.BorderSizePixel = 0
		border.Parent = card
		Instance.new("UICorner",border).CornerRadius = UDim.new(0,6)
		local titleLbl = Instance.new("TextLabel")
		titleLbl.Size = UDim2.new(1,-15,0,18)
		titleLbl.Position = UDim2.new(0,10,0,6)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = title
		titleLbl.TextColor3 = Themes[VortexLibrary.CurrentTheme].TextMain
		titleLbl.TextSize = 13
		titleLbl.Font = Enum.Font.GothamBold
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left
		titleLbl.Parent = card
		local msgLbl = Instance.new("TextLabel")
		msgLbl.Size = UDim2.new(1,-15,0,26)
		msgLbl.Position = UDim2.new(0,10,0,24)
		msgLbl.BackgroundTransparency = 1
		msgLbl.Text = message
		msgLbl.TextColor3 = Themes[VortexLibrary.CurrentTheme].TextSub
		msgLbl.TextSize = 11
		msgLbl.Font = Enum.Font.Gotham
		msgLbl.TextXAlignment = Enum.TextXAlignment.Left
		msgLbl.TextYAlignment = Enum.TextYAlignment.Top
		msgLbl.TextWrapped = true
		msgLbl.Parent = card
		local progBg = Instance.new("Frame")
		progBg.Size = UDim2.new(1,-16,0,3)
		progBg.Position = UDim2.new(0,8,1,-8)
		progBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
		progBg.BorderSizePixel = 0
		progBg.Parent = card
		Instance.new("UICorner",progBg).CornerRadius = UDim.new(1,0)
		local progBar = Instance.new("Frame")
		progBar.Size = UDim2.new(0,0,1,0)
		progBar.BackgroundColor3 = color
		progBar.BorderSizePixel = 0
		progBar.Parent = progBg
		Instance.new("UICorner",progBar).CornerRadius = UDim.new(1,0)
		TweenService:Create(card,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.new(1,-290,1,-80-(existing*80))}):Play()
		TweenService:Create(progBar,TweenInfo.new(duration,Enum.EasingStyle.Linear),{Size=UDim2.new(1,0,1,0)}):Play()
		task.delay(duration,function()
			TweenService:Create(card,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Position=UDim2.new(1,10,card.Position.Y.Scale,card.Position.Y.Offset)}):Play()
			task.wait(0.3)
			sg:Destroy()
		end)
	end)
end
function VortexLibrary:CreateDebugTab(windowObj)
	local tab = windowObj:CreateTab("🔧 Debug")
	tab:CreateSection("Sistem Testleri")
	tab:CreateButton("📊 Sistem Raporu",function()
		local player = Players.LocalPlayer
		print("=== SİSTEM RAPORU ===")
		print("Oyuncu:",player.Name)
		print("UserId:",player.UserId)
		print("Memory:",math.floor(collectgarbage("count")).." KB")
		local fps = 0
		local lastTick = tick()
		local conn
		conn = RunService.Heartbeat:Connect(function()
			fps = math.floor(1/(tick()-lastTick))
			lastTick = tick()
			conn:Disconnect()
			print("FPS:",fps)
		end)
		local pingSuccess,pingVal = pcall(function() return player:GetNetworkPing()*1000 end)
		print("Ping:",pingSuccess and math.floor(pingVal).." ms" or "N/A")
		if player.Character then
			local hum = player.Character:FindFirstChild("Humanoid")
			if hum then
				print("WalkSpeed:",hum.WalkSpeed)
				print("JumpPower:",hum.JumpPower)
				print("Health:",math.floor(hum.Health).."/"..math.floor(hum.MaxHealth))
			end
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			if hrp then print("Position:",tostring(hrp.Position)) end
		end
	end)
	tab:CreateButton("🔔 4 Tip Bildirim Test",function()
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
	tab:CreateButton("🌈 Tema Turu",function()
		task.spawn(function()
			local themes = {"Dark","Aqua","Purple","Midnight","Light","Dark"}
			for _,t in ipairs(themes) do
				VortexLibrary:SetTheme(t)
				task.wait(1.5)
			end
		end)
	end)
	tab:CreateButton("🗑️ GUI Temizle",function()
		for _,v in pairs(CoreGui:GetChildren()) do
			if v.Name == "UILibrary" then v:Destroy() end
		end
		VortexLibrary:Notify("Temizlendi","Tüm GUI'ler silindi",2,"Success")
	end)
	tab:CreateButton("⚡ FPS Test (3s)",function()
		task.spawn(function()
			local frames = 0
			local startTime = tick()
			local conn
			conn = RunService.Heartbeat:Connect(function()
				frames = frames + 1
				if tick()-startTime >= 3 then
					conn:Disconnect()
					local avgFps = math.floor(frames/3)
					print("Ortalama FPS (3s):",avgFps)
					VortexLibrary:Notify("FPS Test","Ortalama: "..avgFps.." FPS",3,"Info")
				end
			end)
		end)
	end)
	tab:CreateButton("🔍 Karakter Parçaları",function()
		local player = Players.LocalPlayer
		if player.Character then
			print("=== KARAKTER PARÇALARI ===")
			for _,v in pairs(player.Character:GetChildren()) do
				print("["..v.ClassName.."]",v.Name)
			end
		else
			print("Karakter bulunamadı")
		end
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
	win.BackgroundColor3 = theme.Background
	win.BorderSizePixel = 0
	win.Parent = sg
	Instance.new("UICorner",win).CornerRadius = UDim.new(0,6)
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1,0,0,30)
	titleBar.BackgroundColor3 = theme.TitleBar
	titleBar.BorderSizePixel = 0
	titleBar.Parent = win
	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1,-80,1,0)
	titleLbl.Position = UDim2.new(0,10,0,0)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title or "Vortex Library"
	titleLbl.TextColor3 = theme.TextMain
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
		TweenService:Create(win,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)}):Play()
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
			local vpSize = workspace.CurrentCamera.ViewportSize
			TweenService:Create(win,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,1,0),Position=UDim2.new(0,0,0,0)}):Play()
		else
			TweenService:Create(win,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=originalSize,Position=originalPos}):Play()
		end
	end)
	sg.Parent = CoreGui
	TweenService:Create(win,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=originalSize}):Play()
	local winObj = {}
	winObj.Tabs = {}
	table.insert(self._listeners,function(t)
		TweenService:Create(win,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=t.Background}):Play()
		TweenService:Create(titleBar,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=t.TitleBar}):Play()
		TweenService:Create(titleLbl,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{TextColor3=t.TextMain}):Play()
		TweenService:Create(contentContainer,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=t.Content}):Play()
	end)
	function winObj:CreateTab(name)
		local theme = Themes[VortexLibrary.CurrentTheme]
		local tabBtn = Instance.new("TextButton")
		tabBtn.Size = UDim2.new(0,100,1,0)
		tabBtn.BackgroundColor3 = theme.TabInactive
		tabBtn.BorderSizePixel = 0
		tabBtn.Text = name
		tabBtn.TextColor3 = theme.TextSub
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
		scrollFrame.ScrollBarImageColor3 = theme.ScrollBar
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
		table.insert(VortexLibrary._listeners,function(t)
			TweenService:Create(scrollFrame,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{ScrollBarImageColor3=t.ScrollBar}):Play()
		end)
		function tabObj:CreateSection(text)
			self._order = self._order + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local section = Instance.new("Frame")
			section.Size = UDim2.new(1,-10,0,22)
			section.BackgroundTransparency = 1
			section.LayoutOrder = self._order
			section.Parent = scrollFrame
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1,0,1,0)
			lbl.BackgroundTransparency = 1
			lbl.Text = text
			lbl.TextColor3 = theme.Accent
			lbl.TextSize = 12
			lbl.Font = Enum.Font.GothamBold
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = section
			table.insert(VortexLibrary._listeners,function(t)
				lbl.TextColor3 = t.Accent
			end)
			return section
		end
		function tabObj:CreateLabel(text)
			self._order = self._order + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1,-10,0,20)
			lbl.BackgroundTransparency = 1
			lbl.Text = text
			lbl.TextColor3 = theme.TextSub
			lbl.TextSize = 11
			lbl.Font = Enum.Font.Gotham
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.TextWrapped = true
			lbl.LayoutOrder = self._order
			lbl.Parent = scrollFrame
			table.insert(VortexLibrary._listeners,function(t)
				lbl.TextColor3 = t.TextSub
			end)
			return lbl
		end
		function tabObj:CreateButton(text,callback)
			self._order = self._order + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,-10,0,35)
			btn.BackgroundColor3 = theme.Element
			btn.BorderSizePixel = 0
			btn.Text = text or "Button"
			btn.TextColor3 = theme.TextMain
			btn.TextSize = 13
			btn.Font = Enum.Font.Gotham
			btn.LayoutOrder = self._order
			btn.Parent = scrollFrame
			Instance.new("UICorner",btn).CornerRadius = UDim.new(0,4)
			btn.MouseEnter:Connect(function()
				TweenService:Create(btn,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=theme.ElementHover}):Play()
			end)
			btn.MouseLeave:Connect(function()
				TweenService:Create(btn,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=theme.Element}):Play()
			end)
			btn.MouseButton1Click:Connect(function()
				if callback then pcall(callback) end
			end)
			table.insert(VortexLibrary._listeners,function(t)
				btn.BackgroundColor3 = t.Element
				btn.TextColor3 = t.TextMain
			end)
			return btn
		end
		function tabObj:CreateToggle(text,default,callback)
			self._order = self._order + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local toggled = default or false
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1,-10,0,35)
			frame.BackgroundColor3 = theme.Element
			frame.BorderSizePixel = 0
			frame.LayoutOrder = self._order
			frame.Parent = scrollFrame
			Instance.new("UICorner",frame).CornerRadius = UDim.new(0,4)
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1,-50,1,0)
			lbl.Position = UDim2.new(0,10,0,0)
			lbl.BackgroundTransparency = 1
			lbl.Text = text or "Toggle"
			lbl.TextColor3 = theme.TextMain
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
				TweenService:Create(track,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=toggled and theme.Accent or theme.ToggleOff}):Play()
				TweenService:Create(knob,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=toggled and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)}):Play()
			end
			btn.MouseButton1Click:Connect(function()
				toggled = not toggled
				toggleObj.Value = toggled
				TweenService:Create(track,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=toggled and theme.Accent or theme.ToggleOff}):Play()
				TweenService:Create(knob,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=toggled and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)}):Play()
				if callback then pcall(function() callback(toggled) end) end
			end)
			table.insert(VortexLibrary._listeners,function(t)
				frame.BackgroundColor3 = t.Element
				lbl.TextColor3 = t.TextMain
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
			frame.BackgroundColor3 = theme.Element
			frame.BorderSizePixel = 0
			frame.LayoutOrder = self._order
			frame.Parent = scrollFrame
			Instance.new("UICorner",frame).CornerRadius = UDim.new(0,4)
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(0.7,0,0,18)
			lbl.Position = UDim2.new(0,10,0,6)
			lbl.BackgroundTransparency = 1
			lbl.Text = text or "Slider"
			lbl.TextColor3 = theme.TextMain
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
			local barBg = Instance.new("Frame")
			barBg.Size = UDim2.new(1,-20,0,6)
			barBg.Position = UDim2.new(0,10,1,-14)
			barBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
			barBg.BorderSizePixel = 0
			barBg.Parent = frame
			Instance.new("UICorner",barBg).CornerRadius = UDim.new(1,0)
			local barFill = Instance.new("Frame")
			barFill.Size = UDim2.new((value-min)/(max-min),0,1,0)
			barFill.BackgroundColor3 = theme.Accent
			barFill.BorderSizePixel = 0
			barFill.Parent = barBg
			Instance.new("UICorner",barFill).CornerRadius = UDim.new(1,0)
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
				TweenService:Create(barFill,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new((value-min)/(max-min),0,1,0)}):Play()
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
					local barPos = barBg.AbsolutePosition.X
					local barSize = barBg.AbsoluteSize.X
					local relative = math.clamp((mousePos-barPos)/barSize,0,1)
					value = math.floor(min+(max-min)*relative)
					sliderObj.Value = value
					valueLbl.Text = tostring(value)
					barFill.Size = UDim2.new(relative,0,1,0)
					if callback then pcall(function() callback(value) end) end
				end
			end)
			table.insert(VortexLibrary._listeners,function(t)
				frame.BackgroundColor3 = t.Element
				lbl.TextColor3 = t.TextMain
				valueLbl.TextColor3 = t.Accent
				barFill.BackgroundColor3 = t.Accent
			end)
			return sliderObj
		end
		function tabObj:CreateTextbox(labelText,placeholder,callback)
			self._order = self._order + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1,-10,0,36)
			frame.BackgroundColor3 = theme.Element
			frame.BorderSizePixel = 0
			frame.LayoutOrder = self._order
			frame.Parent = scrollFrame
			Instance.new("UICorner",frame).CornerRadius = UDim.new(0,4)
			local stroke = Instance.new("UIStroke")
			stroke.Color = theme.Element
			stroke.Thickness = 2
			stroke.Parent = frame
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(0.4,0,1,0)
			lbl.Position = UDim2.new(0,10,0,0)
			lbl.BackgroundTransparency = 1
			lbl.Text = labelText or "Input"
			lbl.TextColor3 = theme.TextMain
			lbl.TextSize = 12
			lbl.Font = Enum.Font.Gotham
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = frame
			local textbox = Instance.new("TextBox")
			textbox.Size = UDim2.new(0.6,-20,1,0)
			textbox.Position = UDim2.new(0.4,0,0,0)
			textbox.BackgroundTransparency = 1
			textbox.PlaceholderText = placeholder or "Metin girin..."
			textbox.PlaceholderColor3 = theme.TextSub
			textbox.Text = ""
			textbox.TextColor3 = theme.TextMain
			textbox.TextSize = 12
			textbox.Font = Enum.Font.Gotham
			textbox.TextXAlignment = Enum.TextXAlignment.Left
			textbox.ClearTextOnFocus = false
			textbox.Parent = frame
			local textboxObj = {Value=""}
			function textboxObj:Set(txt)
				textbox.Text = txt
				self.Value = txt
			end
			textbox.Focused:Connect(function()
				TweenService:Create(stroke,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Color=theme.Accent}):Play()
			end)
			textbox.FocusLost:Connect(function()
				TweenService:Create(stroke,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Color=theme.Element}):Play()
				textboxObj.Value = textbox.Text
				if callback and textbox.Text ~= "" then pcall(function() callback(textbox.Text) end) end
			end)
			table.insert(VortexLibrary._listeners,function(t)
				frame.BackgroundColor3 = t.Element
				stroke.Color = t.Element
				lbl.TextColor3 = t.TextMain
				textbox.TextColor3 = t.TextMain
				textbox.PlaceholderColor3 = t.TextSub
			end)
			return textboxObj
		end
		function tabObj:CreateDropdown(text,options,default,callback)
			self._order = self._order + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local isOpen = false
			local selected = default or (options[1] or "Seçiniz")
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1,-10,0,35)
			frame.BackgroundColor3 = theme.Element
			frame.BorderSizePixel = 0
			frame.LayoutOrder = self._order
			frame.ClipsDescendants = true
			frame.Parent = scrollFrame
			Instance.new("UICorner",frame).CornerRadius = UDim.new(0,4)
			local headerBtn = Instance.new("TextButton")
			headerBtn.Size = UDim2.new(1,0,0,35)
			headerBtn.BackgroundTransparency = 1
			headerBtn.Text = ""
			headerBtn.Parent = frame
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(0.5,-10,0,35)
			lbl.Position = UDim2.new(0,10,0,0)
			lbl.BackgroundTransparency = 1
			lbl.Text = text or "Dropdown"
			lbl.TextColor3 = theme.TextMain
			lbl.TextSize = 12
			lbl.Font = Enum.Font.Gotham
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = frame
			local selectedLbl = Instance.new("TextLabel")
			selectedLbl.Size = UDim2.new(0.5,-30,0,35)
			selectedLbl.Position = UDim2.new(0.5,0,0,0)
			selectedLbl.BackgroundTransparency = 1
			selectedLbl.Text = selected
			selectedLbl.TextColor3 = theme.Accent
			selectedLbl.TextSize = 12
			selectedLbl.Font = Enum.Font.GothamBold
			selectedLbl.TextXAlignment = Enum.TextXAlignment.Right
			selectedLbl.Parent = frame
			local arrow = Instance.new("TextLabel")
			arrow.Size = UDim2.new(0,20,0,35)
			arrow.Position = UDim2.new(1,-24,0,0)
			arrow.BackgroundTransparency = 1
			arrow.Text = "▼"
			arrow.TextColor3 = theme.TextSub
			arrow.TextSize = 10
			arrow.Font = Enum.Font.Gotham
			arrow.Parent = frame
			local optContainer = Instance.new("Frame")
			optContainer.Size = UDim2.new(1,0,0,#options*30)
			optContainer.Position = UDim2.new(0,0,0,35)
			optContainer.BackgroundTransparency = 1
			optContainer.Parent = frame
			local optLayout = Instance.new("UIListLayout")
			optLayout.Padding = UDim.new(0,2)
			optLayout.Parent = optContainer
			local dropObj = {Value=selected}
			function dropObj:Set(val)
				selected = val
				self.Value = val
				selectedLbl.Text = val
			end
			function dropObj:Refresh(newOptions)
				for _,v in pairs(optContainer:GetChildren()) do
					if v:IsA("TextButton") then v:Destroy() end
				end
				options = newOptions
				optContainer.Size = UDim2.new(1,0,0,#options*30)
				for _,opt in ipairs(options) do
					local optBtn = Instance.new("TextButton")
					optBtn.Size = UDim2.new(1,-10,0,28)
					optBtn.Position = UDim2.new(0,5,0,0)
					optBtn.BackgroundColor3 = theme.Content
					optBtn.BorderSizePixel = 0
					optBtn.Text = opt
					optBtn.TextColor3 = theme.TextMain
					optBtn.TextSize = 11
					optBtn.Font = Enum.Font.Gotham
					optBtn.Parent = optContainer
					Instance.new("UICorner",optBtn).CornerRadius = UDim.new(0,3)
					optBtn.MouseButton1Click:Connect(function()
						selected = opt
						dropObj.Value = opt
						selectedLbl.Text = opt
						isOpen = false
						TweenService:Create(frame,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(1,-10,0,35)}):Play()
						if callback then pcall(function() callback(opt) end) end
					end)
				end
			end
			for _,opt in ipairs(options) do
				local optBtn = Instance.new("TextButton")
				optBtn.Size = UDim2.new(1,-10,0,28)
				optBtn.Position = UDim2.new(0,5,0,0)
				optBtn.BackgroundColor3 = theme.Content
				optBtn.BorderSizePixel = 0
				optBtn.Text = opt
				optBtn.TextColor3 = theme.TextMain
				optBtn.TextSize = 11
				optBtn.Font = Enum.Font.Gotham
				optBtn.Parent = optContainer
				Instance.new("UICorner",optBtn).CornerRadius = UDim.new(0,3)
				optBtn.MouseButton1Click:Connect(function()
					selected = opt
					dropObj.Value = opt
					selectedLbl.Text = opt
					isOpen = false
					TweenService:Create(frame,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(1,-10,0,35)}):Play()
					if callback then pcall(function() callback(opt) end) end
				end)
			end
			headerBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				local targetSize = isOpen and UDim2.new(1,-10,0,35+#options*30+5) or UDim2.new(1,-10,0,35)
				TweenService:Create(frame,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=targetSize}):Play()
			end)
			table.insert(VortexLibrary._listeners,function(t)
				frame.BackgroundColor3 = t.Element
				lbl.TextColor3 = t.TextMain
				selectedLbl.TextColor3 = t.Accent
				arrow.TextColor3 = t.TextSub
			end)
			return dropObj
		end
		tabBtn.MouseButton1Click:Connect(function()
			local theme = Themes[VortexLibrary.CurrentTheme]
			for _,tab in pairs(winObj.Tabs) do
				tab.Content.Visible = false
				TweenService:Create(tab.Button,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=theme.TabInactive,TextColor3=theme.TextSub}):Play()
			end
			tabContent.Visible = true
			TweenService:Create(tabBtn,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=theme.Accent,TextColor3=theme.TextMain}):Play()
		end)
		table.insert(winObj.Tabs,tabObj)
		if #winObj.Tabs == 1 then
			tabContent.Visible = true
			tabBtn.BackgroundColor3 = theme.Accent
			tabBtn.TextColor3 = theme.TextMain
		end
		table.insert(VortexLibrary._listeners,function(t)
			if tabContent.Visible then
				tabBtn.BackgroundColor3 = t.Accent
				tabBtn.TextColor3 = t.TextMain
			else
				tabBtn.BackgroundColor3 = t.TabInactive
				tabBtn.TextColor3 = t.TextSub
			end
		end)
		return tabObj
	end
	return winObj
end
_G.Vortex = VortexLibrary
return VortexLibrary
