-- VortexLibrary v2.0
local VortexLibrary = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Themes = {
	Dark = {Background = Color3.fromRGB(30,30,30), TitleBar = Color3.fromRGB(20,20,20), TabInactive = Color3.fromRGB(40,40,40), TabActive = Color3.fromRGB(60,60,60), Content = Color3.fromRGB(25,25,25), Element = Color3.fromRGB(45,45,45), ElementHover = Color3.fromRGB(55,55,55), TextMain = Color3.fromRGB(255,255,255), TextSub = Color3.fromRGB(200,200,200), Accent = Color3.fromRGB(100,100,255), ToggleOff = Color3.fromRGB(60,60,60), ScrollBar = Color3.fromRGB(60,60,60)},
	Aqua = {Background = Color3.fromRGB(15,35,45), TitleBar = Color3.fromRGB(10,25,35), TabInactive = Color3.fromRGB(20,45,60), TabActive = Color3.fromRGB(30,65,85), Content = Color3.fromRGB(18,40,50), Element = Color3.fromRGB(25,55,70), ElementHover = Color3.fromRGB(35,75,95), TextMain = Color3.fromRGB(200,240,255), TextSub = Color3.fromRGB(150,200,220), Accent = Color3.fromRGB(0,200,255), ToggleOff = Color3.fromRGB(30,60,75), ScrollBar = Color3.fromRGB(40,80,100)},
	Purple = {Background = Color3.fromRGB(35,20,45), TitleBar = Color3.fromRGB(25,15,35), TabInactive = Color3.fromRGB(50,30,65), TabActive = Color3.fromRGB(70,45,90), Content = Color3.fromRGB(40,25,50), Element = Color3.fromRGB(60,40,75), ElementHover = Color3.fromRGB(80,55,100), TextMain = Color3.fromRGB(240,220,255), TextSub = Color3.fromRGB(200,180,220), Accent = Color3.fromRGB(180,100,255), ToggleOff = Color3.fromRGB(60,45,75), ScrollBar = Color3.fromRGB(80,60,100)},
	Midnight = {Background = Color3.fromRGB(10,10,20), TitleBar = Color3.fromRGB(5,5,15), TabInactive = Color3.fromRGB(15,15,30), TabActive = Color3.fromRGB(25,25,45), Content = Color3.fromRGB(12,12,22), Element = Color3.fromRGB(20,20,35), ElementHover = Color3.fromRGB(30,30,50), TextMain = Color3.fromRGB(220,220,240), TextSub = Color3.fromRGB(160,160,180), Accent = Color3.fromRGB(100,150,255), ToggleOff = Color3.fromRGB(30,30,45), ScrollBar = Color3.fromRGB(40,40,60)},
	Light = {Background = Color3.fromRGB(240,240,240), TitleBar = Color3.fromRGB(220,220,220), TabInactive = Color3.fromRGB(200,200,200), TabActive = Color3.fromRGB(180,180,180), Content = Color3.fromRGB(230,230,230), Element = Color3.fromRGB(210,210,210), ElementHover = Color3.fromRGB(190,190,190), TextMain = Color3.fromRGB(20,20,20), TextSub = Color3.fromRGB(60,60,60), Accent = Color3.fromRGB(70,130,255), ToggleOff = Color3.fromRGB(160,160,160), ScrollBar = Color3.fromRGB(180,180,180)}
}
VortexLibrary.CurrentTheme = "Dark"
VortexLibrary.ThemeListeners = {}
VortexLibrary.NotificationQueue = {}
VortexLibrary.Windows = {}
local TI_Default = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TI_Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TI_Back = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
function VortexLibrary:SetTheme(themeName)
	if not Themes[themeName] then return end
	self.CurrentTheme = themeName
	for _, listener in pairs(self.ThemeListeners) do
		pcall(function() listener(Themes[themeName]) end)
	end
end
function VortexLibrary:Notify(title, message, duration, notifType)
	duration = duration or 3
	notifType = notifType or "Info"
	local typeColors = {Info = Color3.fromRGB(100,150,255), Success = Color3.fromRGB(50,200,100), Warning = Color3.fromRGB(255,180,50), Error = Color3.fromRGB(255,80,80)}
	local accentColor = typeColors[notifType] or typeColors.Info
	local theme = Themes[self.CurrentTheme]
	pcall(function()
		local sg = Instance.new("ScreenGui")
		sg.Name = "VortexNotif"
		sg.ResetOnSpawn = false
		sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		sg.Parent = CoreGui
		local card = Instance.new("Frame")
		card.Size = UDim2.new(0,300,0,80)
		card.Position = UDim2.new(1,320,1,-100-(#self.NotificationQueue*90))
		card.BackgroundColor3 = theme.Element
		card.BorderSizePixel = 0
		card.Parent = sg
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0,6)
		corner.Parent = card
		local stripe = Instance.new("Frame")
		stripe.Size = UDim2.new(0,4,1,0)
		stripe.BackgroundColor3 = accentColor
		stripe.BorderSizePixel = 0
		stripe.Parent = card
		local titleLbl = Instance.new("TextLabel")
		titleLbl.Size = UDim2.new(1,-20,0,20)
		titleLbl.Position = UDim2.new(0,10,0,8)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = title
		titleLbl.TextColor3 = theme.TextMain
		titleLbl.TextSize = 14
		titleLbl.Font = Enum.Font.GothamBold
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left
		titleLbl.Parent = card
		local msgLbl = Instance.new("TextLabel")
		msgLbl.Size = UDim2.new(1,-20,0,30)
		msgLbl.Position = UDim2.new(0,10,0,28)
		msgLbl.BackgroundTransparency = 1
		msgLbl.Text = message
		msgLbl.TextColor3 = theme.TextSub
		msgLbl.TextSize = 12
		msgLbl.Font = Enum.Font.Gotham
		msgLbl.TextXAlignment = Enum.TextXAlignment.Left
		msgLbl.TextYAlignment = Enum.TextYAlignment.Top
		msgLbl.TextWrapped = true
		msgLbl.Parent = card
		local progBg = Instance.new("Frame")
		progBg.Size = UDim2.new(1,-20,0,3)
		progBg.Position = UDim2.new(0,10,1,-10)
		progBg.BackgroundColor3 = Color3.fromRGB(50,50,50)
		progBg.BorderSizePixel = 0
		progBg.Parent = card
		local progCorner = Instance.new("UICorner")
		progCorner.CornerRadius = UDim.new(1,0)
		progCorner.Parent = progBg
		local progBar = Instance.new("Frame")
		progBar.Size = UDim2.new(0,0,1,0)
		progBar.BackgroundColor3 = accentColor
		progBar.BorderSizePixel = 0
		progBar.Parent = progBg
		local progBarCorner = Instance.new("UICorner")
		progBarCorner.CornerRadius = UDim.new(1,0)
		progBarCorner.Parent = progBar
		table.insert(self.NotificationQueue, card)
		TweenService:Create(card, TI_Fast, {Position = UDim2.new(1,-310,1,-100-(#self.NotificationQueue*90))}):Play()
		TweenService:Create(progBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1,0,1,0)}):Play()
		task.delay(duration, function()
			TweenService:Create(card, TI_Fast, {Position = UDim2.new(1,320,card.Position.Y.Scale,card.Position.Y.Offset)}):Play()
			task.wait(0.2)
			sg:Destroy()
			for i,v in pairs(self.NotificationQueue) do if v == card then table.remove(self.NotificationQueue, i) break end end
		end)
	end)
end
function VortexLibrary:CreateDebugTab(windowObj)
	local debugTab = windowObj:CreateTab("🔧 Debug")
	local errorFrame = Instance.new("Frame")
	errorFrame.Size = UDim2.new(1,-10,0,100)
	errorFrame.BackgroundColor3 = Themes[self.CurrentTheme].Element
	errorFrame.BorderSizePixel = 0
	errorFrame.Parent = debugTab.ScrollFrame
	local errorCorner = Instance.new("UICorner")
	errorCorner.CornerRadius = UDim.new(0,4)
	errorCorner.Parent = errorFrame
	local errorScroll = Instance.new("ScrollingFrame")
	errorScroll.Size = UDim2.new(1,-10,1,-10)
	errorScroll.Position = UDim2.new(0,5,0,5)
	errorScroll.BackgroundTransparency = 1
	errorScroll.BorderSizePixel = 0
	errorScroll.ScrollBarThickness = 3
	errorScroll.Parent = errorFrame
	local errorLayout = Instance.new("UIListLayout")
	errorLayout.Padding = UDim.new(0,2)
	errorLayout.Parent = errorScroll
	errorLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		errorScroll.CanvasSize = UDim2.new(0,0,0,errorLayout.AbsoluteContentSize.Y+5)
	end)
	debugTab._logError = function(msg)
		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1,-5,0,20)
		lbl.BackgroundTransparency = 1
		lbl.Text = "[HATA] "..msg
		lbl.TextColor3 = Color3.fromRGB(255,80,80)
		lbl.TextSize = 11
		lbl.Font = Enum.Font.Code
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.TextWrapped = true
		lbl.Parent = errorScroll
	end
	debugTab:CreateSection("Sistem Bilgisi")
	debugTab:CreateButton("📊 Sistem Bilgisi", function()
		local player = Players.LocalPlayer
		local char = player.Character
		local hum = char and char:FindFirstChild("Humanoid")
		print("=== SİSTEM BİLGİSİ ===")
		print("Oyuncu:", player.Name)
		print("UserId:", player.UserId)
		print("Memory:", math.floor(collectgarbage("count")).." KB")
		if hum then
			print("WalkSpeed:", hum.WalkSpeed)
			print("JumpPower:", hum.JumpPower)
		end
		local fps = 0
		local lastTime = tick()
		local conn
		conn = RunService.Heartbeat:Connect(function()
			fps = math.floor(1/(tick()-lastTime))
			lastTime = tick()
			conn:Disconnect()
			print("FPS:", fps)
		end)
	end)
	debugTab:CreateButton("🧹 GUI Temizle", function()
		for _,v in pairs(CoreGui:GetChildren()) do
			if v.Name == "VortexLibrary" or v.Name == "UILibrary" or v.Name == "VortexWindow" then
				v:Destroy()
			end
		end
		VortexLibrary:Notify("Temizlendi", "Tüm GUI'ler silindi", 2, "Success")
	end)
	debugTab:CreateButton("📢 Notify Test", function()
		VortexLibrary:Notify("Bilgi", "Bu bir Info bildirimi", 2, "Info")
		task.wait(0.5)
		VortexLibrary:Notify("Başarılı", "Bu bir Success bildirimi", 2, "Success")
		task.wait(0.5)
		VortexLibrary:Notify("Uyarı", "Bu bir Warning bildirimi", 2, "Warning")
		task.wait(0.5)
		VortexLibrary:Notify("Hata", "Bu bir Error bildirimi", 2, "Error")
	end)
	debugTab:CreateButton("🌐 Tema Turu", function()
		local themes = {"Dark","Aqua","Purple","Midnight","Light"}
		for _,t in ipairs(themes) do
			VortexLibrary:SetTheme(t)
			VortexLibrary:Notify("Tema", t.." teması uygulandı", 1.5, "Info")
			task.wait(1.5)
		end
		VortexLibrary:SetTheme("Dark")
	end)
end
function VortexLibrary:CreateWindow(title, size)
	local theme = Themes[self.CurrentTheme]
	local sg = Instance.new("ScreenGui")
	sg.Name = "VortexLibrary"
	sg.ResetOnSpawn = false
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	local win = Instance.new("Frame")
	win.Name = "Window"
	win.Size = UDim2.new(0,0,0,0)
	win.Position = UDim2.new(0.5,-250,0.5,-200)
	win.BackgroundColor3 = theme.Background
	win.BackgroundTransparency = 1
	win.BorderSizePixel = 0
	win.Parent = sg
	local winCorner = Instance.new("UICorner")
	winCorner.CornerRadius = UDim.new(0,6)
	winCorner.Parent = win
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1,0,0,30)
	titleBar.BackgroundColor3 = theme.TitleBar
	titleBar.BorderSizePixel = 0
	titleBar.Parent = win
	local titleLbl = Instance.new("TextLabel")
	titleLbl.Name = "Title"
	titleLbl.Size = UDim2.new(1,-100,1,0)
	titleLbl.Position = UDim2.new(0,10,0,0)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title or "Vortex Library"
	titleLbl.TextColor3 = theme.TextMain
	titleLbl.TextSize = 14
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.Parent = titleBar
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0,25,0,25)
	closeBtn.Position = UDim2.new(1,-30,0,2.5)
	closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
	closeBtn.BorderSizePixel = 0
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
	closeBtn.TextSize = 14
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.Parent = titleBar
	local closeBtnCorner = Instance.new("UICorner")
	closeBtnCorner.CornerRadius = UDim.new(0,4)
	closeBtnCorner.Parent = closeBtn
	closeBtn.MouseButton1Click:Connect(function()
		TweenService:Create(win, TI_Back, {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()
		task.wait(0.4)
		sg:Destroy()
	end)
	local minimized = false
	local originalSize = size or UDim2.new(0,500,0,400)
	local minBtn = Instance.new("TextButton")
	minBtn.Size = UDim2.new(0,25,0,25)
	minBtn.Position = UDim2.new(1,-60,0,2.5)
	minBtn.BackgroundColor3 = Color3.fromRGB(200,150,50)
	minBtn.BorderSizePixel = 0
	minBtn.Text = "–"
	minBtn.TextColor3 = Color3.fromRGB(255,255,255)
	minBtn.TextSize = 14
	minBtn.Font = Enum.Font.GothamBold
	minBtn.Parent = titleBar
	local minBtnCorner = Instance.new("UICorner")
	minBtnCorner.CornerRadius = UDim.new(0,4)
	minBtnCorner.Parent = minBtn
	local fullscreen = false
	local maxBtn = Instance.new("TextButton")
	maxBtn.Size = UDim2.new(0,25,0,25)
	maxBtn.Position = UDim2.new(1,-90,0,2.5)
	maxBtn.BackgroundColor3 = Color3.fromRGB(50,150,200)
	maxBtn.BorderSizePixel = 0
	maxBtn.Text = "⊡"
	maxBtn.TextColor3 = Color3.fromRGB(255,255,255)
	maxBtn.TextSize = 14
	maxBtn.Font = Enum.Font.GothamBold
	maxBtn.Parent = titleBar
	local maxBtnCorner = Instance.new("UICorner")
	maxBtnCorner.CornerRadius = UDim.new(0,4)
	maxBtnCorner.Parent = maxBtn
	local tabContainer = Instance.new("Frame")
	tabContainer.Name = "TabContainer"
	tabContainer.Size = UDim2.new(1,-10,0,30)
	tabContainer.Position = UDim2.new(0,5,0,35)
	tabContainer.BackgroundTransparency = 1
	tabContainer.Parent = win
	local tabLayout = Instance.new("UIListLayout")
	tabLayout.FillDirection = Enum.FillDirection.Horizontal
	tabLayout.Padding = UDim.new(0,5)
	tabLayout.Parent = tabContainer
	local contentContainer = Instance.new("Frame")
	contentContainer.Name = "ContentContainer"
	contentContainer.Size = UDim2.new(1,-10,1,-75)
	contentContainer.Position = UDim2.new(0,5,0,70)
	contentContainer.BackgroundColor3 = theme.Content
	contentContainer.BorderSizePixel = 0
	contentContainer.Parent = win
	local contentCorner = Instance.new("UICorner")
	contentCorner.CornerRadius = UDim.new(0,4)
	contentCorner.Parent = contentContainer
	local dragging, dragInput, mousePos, framePos = false, nil, nil, nil
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
			local clampedX = math.clamp(framePos.X.Offset + delta.X, 0, vpSize.X - winSize.X)
			local clampedY = math.clamp(framePos.Y.Offset + delta.Y, 0, vpSize.Y - winSize.Y)
			win.Position = UDim2.new(0, clampedX, 0, clampedY)
		end
	end)
	minBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			TweenService:Create(win, TI_Default, {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 30)}):Play()
			tabContainer.Visible = false
			contentContainer.Visible = false
		else
			TweenService:Create(win, TI_Default, {Size = originalSize}):Play()
			tabContainer.Visible = true
			contentContainer.Visible = true
		end
	end)
	maxBtn.MouseButton1Click:Connect(function()
		fullscreen = not fullscreen
		if fullscreen then
			local vpSize = workspace.CurrentCamera.ViewportSize
			TweenService:Create(win, TI_Default, {Size = UDim2.new(0, vpSize.X, 0, vpSize.Y), Position = UDim2.new(0,0,0,0)}):Play()
		else
			TweenService:Create(win, TI_Default, {Size = originalSize, Position = UDim2.new(0.5, -originalSize.X.Offset/2, 0.5, -originalSize.Y.Offset/2)}):Play()
		end
	end)
	sg.Parent = CoreGui
	TweenService:Create(win, TI_Back, {Size = originalSize, BackgroundTransparency = 0}):Play()
	local winObj = {}
	winObj.Tabs = {}
	winObj.CurrentTab = nil
	winObj.Window = win
	winObj.TitleBar = titleBar
	winObj.TitleLabel = titleLbl
	winObj.ContentContainer = contentContainer
	table.insert(VortexLibrary.Windows, winObj)
	table.insert(VortexLibrary.ThemeListeners, function(t)
		TweenService:Create(win, TI_Default, {BackgroundColor3 = t.Background}):Play()
		TweenService:Create(titleBar, TI_Default, {BackgroundColor3 = t.TitleBar}):Play()
		TweenService:Create(titleLbl, TI_Default, {TextColor3 = t.TextMain}):Play()
		TweenService:Create(contentContainer, TI_Default, {BackgroundColor3 = t.Content}):Play()
	end)
	function winObj:CreateTab(name)
		local theme = Themes[VortexLibrary.CurrentTheme]
		local tabBtn = Instance.new("TextButton")
		tabBtn.Name = name
		tabBtn.Size = UDim2.new(0,100,1,0)
		tabBtn.BackgroundColor3 = theme.TabInactive
		tabBtn.BorderSizePixel = 0
		tabBtn.Text = name
		tabBtn.TextColor3 = theme.TextSub
		tabBtn.TextSize = 12
		tabBtn.Font = Enum.Font.Gotham
		tabBtn.Parent = tabContainer
		local tabCorner = Instance.new("UICorner")
		tabCorner.CornerRadius = UDim.new(0,4)
		tabCorner.Parent = tabBtn
		local tabContent = Instance.new("Frame")
		tabContent.Name = name.."Content"
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
		tabObj.LayoutOrder = 0
		table.insert(VortexLibrary.ThemeListeners, function(t)
			TweenService:Create(scrollFrame, TI_Default, {ScrollBarImageColor3 = t.ScrollBar}):Play()
			if winObj.CurrentTab == tabObj then
				TweenService:Create(tabBtn, TI_Default, {BackgroundColor3 = t.TabActive, TextColor3 = t.TextMain}):Play()
			else
				TweenService:Create(tabBtn, TI_Default, {BackgroundColor3 = t.TabInactive, TextColor3 = t.TextSub}):Play()
			end
		end)
		function tabObj:CreateSection(text)
			tabObj.LayoutOrder = tabObj.LayoutOrder + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local section = Instance.new("Frame")
			section.Size = UDim2.new(1,-10,0,25)
			section.BackgroundTransparency = 1
			section.LayoutOrder = tabObj.LayoutOrder
			section.Parent = scrollFrame
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1,0,0,20)
			lbl.BackgroundTransparency = 1
			lbl.Text = text
			lbl.TextColor3 = theme.Accent
			lbl.TextSize = 13
			lbl.Font = Enum.Font.GothamBold
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = section
			local line = Instance.new("Frame")
			line.Size = UDim2.new(1,0,0,1)
			line.Position = UDim2.new(0,0,1,-2)
			line.BackgroundColor3 = theme.Accent
			line.BorderSizePixel = 0
			line.Parent = section
			table.insert(VortexLibrary.ThemeListeners, function(t)
				lbl.TextColor3 = t.Accent
				line.BackgroundColor3 = t.Accent
			end)
			return section
		end
		function tabObj:CreateLabel(text)
			tabObj.LayoutOrder = tabObj.LayoutOrder + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1,-10,0,25)
			lbl.BackgroundTransparency = 1
			lbl.Text = text
			lbl.TextColor3 = theme.TextSub
			lbl.TextSize = 12
			lbl.Font = Enum.Font.GothamItalic
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.TextWrapped = true
			lbl.LayoutOrder = tabObj.LayoutOrder
			lbl.Parent = scrollFrame
			table.insert(VortexLibrary.ThemeListeners, function(t)
				lbl.TextColor3 = t.TextSub
			end)
			return lbl
		end
		function tabObj:CreateButton(text, callback)
			tabObj.LayoutOrder = tabObj.LayoutOrder + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local btn = Instance.new("TextButton")
			btn.Name = "Button"
			btn.Size = UDim2.new(1,-10,0,35)
			btn.BackgroundColor3 = theme.Element
			btn.BorderSizePixel = 0
			btn.Text = text or "Button"
			btn.TextColor3 = theme.TextMain
			btn.TextSize = 13
			btn.Font = Enum.Font.Gotham
			btn.LayoutOrder = tabObj.LayoutOrder
			btn.Parent = scrollFrame
			local btnCorner = Instance.new("UICorner")
			btnCorner.CornerRadius = UDim.new(0,4)
			btnCorner.Parent = btn
			btn.MouseEnter:Connect(function()
				TweenService:Create(btn, TI_Fast, {BackgroundColor3 = theme.ElementHover}):Play()
			end)
			btn.MouseLeave:Connect(function()
				TweenService:Create(btn, TI_Fast, {BackgroundColor3 = theme.Element}):Play()
			end)
			btn.MouseButton1Click:Connect(function()
				TweenService:Create(btn, TI_Fast, {BackgroundColor3 = theme.Accent}):Play()
				task.wait(0.1)
				TweenService:Create(btn, TI_Fast, {BackgroundColor3 = theme.Element}):Play()
				if callback then pcall(callback) end
			end)
			table.insert(VortexLibrary.ThemeListeners, function(t)
				btn.BackgroundColor3 = t.Element
				btn.TextColor3 = t.TextMain
			end)
			return btn
		end
		function tabObj:CreateToggle(text, default, callback)
			tabObj.LayoutOrder = tabObj.LayoutOrder + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local toggled = default or false
			local toggleFrame = Instance.new("Frame")
			toggleFrame.Name = "Toggle"
			toggleFrame.Size = UDim2.new(1,-10,0,35)
			toggleFrame.BackgroundColor3 = theme.Element
			toggleFrame.BorderSizePixel = 0
			toggleFrame.LayoutOrder = tabObj.LayoutOrder
			toggleFrame.Parent = scrollFrame
			local toggleCorner = Instance.new("UICorner")
			toggleCorner.CornerRadius = UDim.new(0,4)
			toggleCorner.Parent = toggleFrame
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1,-60,1,0)
			lbl.Position = UDim2.new(0,10,0,0)
			lbl.BackgroundTransparency = 1
			lbl.Text = text or "Toggle"
			lbl.TextColor3 = theme.TextMain
			lbl.TextSize = 13
			lbl.Font = Enum.Font.Gotham
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = toggleFrame
			local switchBg = Instance.new("Frame")
			switchBg.Size = UDim2.new(0,40,0,20)
			switchBg.Position = UDim2.new(1,-50,0.5,-10)
			switchBg.BackgroundColor3 = toggled and theme.Accent or theme.ToggleOff
			switchBg.BorderSizePixel = 0
			switchBg.Parent = toggleFrame
			local switchCorner = Instance.new("UICorner")
			switchCorner.CornerRadius = UDim.new(1,0)
			switchCorner.Parent = switchBg
			local knob = Instance.new("Frame")
			knob.Size = UDim2.new(0,16,0,16)
			knob.Position = toggled and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
			knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
			knob.BorderSizePixel = 0
			knob.Parent = switchBg
			local knobCorner = Instance.new("UICorner")
			knobCorner.CornerRadius = UDim.new(1,0)
			knobCorner.Parent = knob
			local toggleBtn = Instance.new("TextButton")
			toggleBtn.Size = UDim2.new(1,0,1,0)
			toggleBtn.BackgroundTransparency = 1
			toggleBtn.Text = ""
			toggleBtn.Parent = toggleFrame
			local toggleObj = {Value = toggled}
			function toggleObj:Set(val)
				toggled = val
				self.Value = val
				TweenService:Create(switchBg, TI_Default, {BackgroundColor3 = toggled and theme.Accent or theme.ToggleOff}):Play()
				TweenService:Create(knob, TI_Default, {Position = toggled and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)}):Play()
			end
			toggleBtn.MouseButton1Click:Connect(function()
				toggled = not toggled
				toggleObj.Value = toggled
				TweenService:Create(switchBg, TI_Default, {BackgroundColor3 = toggled and theme.Accent or theme.ToggleOff}):Play()
				TweenService:Create(knob, TI_Default, {Position = toggled and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)}):Play()
				if callback then pcall(function() callback(toggled) end) end
			end)
			table.insert(VortexLibrary.ThemeListeners, function(t)
				toggleFrame.BackgroundColor3 = t.Element
				lbl.TextColor3 = t.TextMain
				switchBg.BackgroundColor3 = toggled and t.Accent or t.ToggleOff
			end)
			return toggleObj
		end
		function tabObj:CreateSlider(text, min, max, default, callback)
			tabObj.LayoutOrder = tabObj.LayoutOrder + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local value = default or min
			local sliderFrame = Instance.new("Frame")
			sliderFrame.Name = "Slider"
			sliderFrame.Size = UDim2.new(1,-10,0,50)
			sliderFrame.BackgroundColor3 = theme.Element
			sliderFrame.BorderSizePixel = 0
			sliderFrame.LayoutOrder = tabObj.LayoutOrder
			sliderFrame.Parent = scrollFrame
			local sliderCorner = Instance.new("UICorner")
			sliderCorner.CornerRadius = UDim.new(0,4)
			sliderCorner.Parent = sliderFrame
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(0.7,0,0,20)
			lbl.Position = UDim2.new(0,10,0,5)
			lbl.BackgroundTransparency = 1
			lbl.Text = text or "Slider"
			lbl.TextColor3 = theme.TextMain
			lbl.TextSize = 13
			lbl.Font = Enum.Font.Gotham
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = sliderFrame
			local valueLbl = Instance.new("TextLabel")
			valueLbl.Size = UDim2.new(0.3,-10,0,20)
			valueLbl.Position = UDim2.new(0.7,0,0,5)
			valueLbl.BackgroundTransparency = 1
			valueLbl.Text = tostring(value)
			valueLbl.TextColor3 = theme.Accent
			valueLbl.TextSize = 13
			valueLbl.Font = Enum.Font.GothamBold
			valueLbl.TextXAlignment = Enum.TextXAlignment.Right
			valueLbl.Parent = sliderFrame
			local sliderBg = Instance.new("Frame")
			sliderBg.Size = UDim2.new(1,-20,0,6)
			sliderBg.Position = UDim2.new(0,10,1,-15)
			sliderBg.BackgroundColor3 = Color3.fromRGB(50,50,50)
			sliderBg.BorderSizePixel = 0
			sliderBg.Parent = sliderFrame
			local sliderBgCorner = Instance.new("UICorner")
			sliderBgCorner.CornerRadius = UDim.new(1,0)
			sliderBgCorner.Parent = sliderBg
			local sliderFill = Instance.new("Frame")
			sliderFill.Size = UDim2.new((value-min)/(max-min),0,1,0)
			sliderFill.BackgroundColor3 = theme.Accent
			sliderFill.BorderSizePixel = 0
			sliderFill.Parent = sliderBg
			local sliderFillCorner = Instance.new("UICorner")
			sliderFillCorner.CornerRadius = UDim.new(1,0)
			sliderFillCorner.Parent = sliderFill
			local sliderBtn = Instance.new("TextButton")
			sliderBtn.Size = UDim2.new(1,0,1,0)
			sliderBtn.BackgroundTransparency = 1
			sliderBtn.Text = ""
			sliderBtn.Parent = sliderFrame
			local dragging = false
			local sliderObj = {Value = value}
			function sliderObj:Set(val)
				value = math.clamp(val, min, max)
				self.Value = value
				valueLbl.Text = tostring(value)
				TweenService:Create(sliderFill, TI_Fast, {Size = UDim2.new((value-min)/(max-min),0,1,0)}):Play()
			end
			sliderBtn.MouseButton1Down:Connect(function() dragging = true end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local mousePos = UserInputService:GetMouseLocation().X
					local sliderPos = sliderBg.AbsolutePosition.X
					local sliderSize = sliderBg.AbsoluteSize.X
					local relative = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
					value = math.floor(min + (max - min) * relative)
					sliderObj.Value = value
					valueLbl.Text = tostring(value)
					TweenService:Create(sliderFill, TI_Fast, {Size = UDim2.new(relative,0,1,0)}):Play()
					if callback then pcall(function() callback(value) end) end
				end
			end)
			table.insert(VortexLibrary.ThemeListeners, function(t)
				sliderFrame.BackgroundColor3 = t.Element
				lbl.TextColor3 = t.TextMain
				valueLbl.TextColor3 = t.Accent
				sliderFill.BackgroundColor3 = t.Accent
			end)
			return sliderObj
		end
		function tabObj:CreateTextbox(labelText, placeholder, callback)
			tabObj.LayoutOrder = tabObj.LayoutOrder + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local textboxFrame = Instance.new("Frame")
			textboxFrame.Name = "Textbox"
			textboxFrame.Size = UDim2.new(1,-10,0,35)
			textboxFrame.BackgroundColor3 = theme.Element
			textboxFrame.BorderSizePixel = 0
			textboxFrame.LayoutOrder = tabObj.LayoutOrder
			textboxFrame.Parent = scrollFrame
			local textboxCorner = Instance.new("UICorner")
			textboxCorner.CornerRadius = UDim.new(0,4)
			textboxCorner.Parent = textboxFrame
			local stroke = Instance.new("UIStroke")
			stroke.Color = theme.Element
			stroke.Thickness = 2
			stroke.Parent = textboxFrame
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(0.3,0,1,0)
			lbl.Position = UDim2.new(0,10,0,0)
			lbl.BackgroundTransparency = 1
			lbl.Text = labelText or "Input"
			lbl.TextColor3 = theme.TextMain
			lbl.TextSize = 13
			lbl.Font = Enum.Font.Gotham
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = textboxFrame
			local textbox = Instance.new("TextBox")
			textbox.Size = UDim2.new(0.7,-20,1,0)
			textbox.Position = UDim2.new(0.3,0,0,0)
			textbox.BackgroundTransparency = 1
			textbox.PlaceholderText = placeholder or "Metin girin..."
			textbox.PlaceholderColor3 = theme.TextSub
			textbox.Text = ""
			textbox.TextColor3 = theme.TextMain
			textbox.TextSize = 13
			textbox.Font = Enum.Font.Gotham
			textbox.TextXAlignment = Enum.TextXAlignment.Left
			textbox.ClearTextOnFocus = false
			textbox.Parent = textboxFrame
			local textboxObj = {Value = ""}
			function textboxObj:Set(txt)
				textbox.Text = txt
				self.Value = txt
			end
			textbox.Focused:Connect(function()
				TweenService:Create(stroke, TI_Fast, {Color = theme.Accent}):Play()
			end)
			textbox.FocusLost:Connect(function()
				TweenService:Create(stroke, TI_Fast, {Color = theme.Element}):Play()
				textboxObj.Value = textbox.Text
				if callback and textbox.Text ~= "" then pcall(function() callback(textbox.Text) end) end
			end)
			table.insert(VortexLibrary.ThemeListeners, function(t)
				textboxFrame.BackgroundColor3 = t.Element
				stroke.Color = t.Element
				lbl.TextColor3 = t.TextMain
				textbox.TextColor3 = t.TextMain
				textbox.PlaceholderColor3 = t.TextSub
			end)
			return textboxObj
		end
		function tabObj:CreateDropdown(text, options, default, callback)
			tabObj.LayoutOrder = tabObj.LayoutOrder + 1
			local theme = Themes[VortexLibrary.CurrentTheme]
			local isOpen = false
			local selected = default or (options[1] or "Seçiniz")
			local dropFrame = Instance.new("Frame")
			dropFrame.Name = "Dropdown"
			dropFrame.Size = UDim2.new(1,-10,0,35)
			dropFrame.BackgroundColor3 = theme.Element
			dropFrame.BorderSizePixel = 0
			dropFrame.LayoutOrder = tabObj.LayoutOrder
			dropFrame.ClipsDescendants = true
			dropFrame.Parent = scrollFrame
			local dropCorner = Instance.new("UICorner")
			dropCorner.CornerRadius = UDim.new(0,4)
			dropCorner.Parent = dropFrame
			local headerBtn = Instance.new("TextButton")
			headerBtn.Size = UDim2.new(1,0,0,35)
			headerBtn.BackgroundTransparency = 1
			headerBtn.Text = ""
			headerBtn.Parent = dropFrame
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(0.5,-10,0,35)
			lbl.Position = UDim2.new(0,10,0,0)
			lbl.BackgroundTransparency = 1
			lbl.Text = text or "Dropdown"
			lbl.TextColor3 = theme.TextMain
			lbl.TextSize = 13
			lbl.Font = Enum.Font.Gotham
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = dropFrame
			local selectedLbl = Instance.new("TextLabel")
			selectedLbl.Size = UDim2.new(0.5,-30,0,35)
			selectedLbl.Position = UDim2.new(0.5,0,0,0)
			selectedLbl.BackgroundTransparency = 1
			selectedLbl.Text = selected
			selectedLbl.TextColor3 = theme.Accent
			selectedLbl.TextSize = 13
			selectedLbl.Font = Enum.Font.GothamBold
			selectedLbl.TextXAlignment = Enum.TextXAlignment.Right
			selectedLbl.Parent = dropFrame
			local arrow = Instance.new("TextLabel")
			arrow.Size = UDim2.new(0,20,0,35)
			arrow.Position = UDim2.new(1,-25,0,0)
			arrow.BackgroundTransparency = 1
			arrow.Text = "▼"
			arrow.TextColor3 = theme.TextSub
			arrow.TextSize = 10
			arrow.Font = Enum.Font.Gotham
			arrow.Parent = dropFrame
			local optContainer = Instance.new("Frame")
			optContainer.Size = UDim2.new(1,0,0,#options*30)
			optContainer.Position = UDim2.new(0,0,0,35)
			optContainer.BackgroundTransparency = 1
			optContainer.Parent = dropFrame
			local optLayout = Instance.new("UIListLayout")
			optLayout.Padding = UDim.new(0,2)
			optLayout.Parent = optContainer
			local dropObj = {Value = selected}
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
					optBtn.TextSize = 12
					optBtn.Font = Enum.Font.Gotham
					optBtn.Parent = optContainer
					local optCorner = Instance.new("UICorner")
					optCorner.CornerRadius = UDim.new(0,3)
					optCorner.Parent = optBtn
					optBtn.MouseEnter:Connect(function()
						TweenService:Create(optBtn, TI_Fast, {BackgroundColor3 = theme.ElementHover}):Play()
					end)
					optBtn.MouseLeave:Connect(function()
						TweenService:Create(optBtn, TI_Fast, {BackgroundColor3 = theme.Content}):Play()
					end)
					optBtn.MouseButton1Click:Connect(function()
						selected = opt
						dropObj.Value = opt
						selectedLbl.Text = opt
						isOpen = false
						TweenService:Create(dropFrame, TI_Default, {Size = UDim2.new(1,-10,0,35)}):Play()
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
				optBtn.TextSize = 12
				optBtn.Font = Enum.Font.Gotham
				optBtn.Parent = optContainer
				local optCorner = Instance.new("UICorner")
				optCorner.CornerRadius = UDim.new(0,3)
				optCorner.Parent = optBtn
				optBtn.MouseEnter:Connect(function()
					TweenService:Create(optBtn, TI_Fast, {BackgroundColor3 = theme.ElementHover}):Play()
				end)
				optBtn.MouseLeave:Connect(function()
					TweenService:Create(optBtn, TI_Fast, {BackgroundColor3 = theme.Content}):Play()
				end)
				optBtn.MouseButton1Click:Connect(function()
					selected = opt
					dropObj.Value = opt
					selectedLbl.Text = opt
					isOpen = false
					TweenService:Create(dropFrame, TI_Default, {Size = UDim2.new(1,-10,0,35)}):Play()
					if callback then pcall(function() callback(opt) end) end
				end)
			end
			headerBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				local targetSize = isOpen and UDim2.new(1,-10,0,35+#options*30+5) or UDim2.new(1,-10,0,35)
				TweenService:Create(dropFrame, TI_Default, {Size = targetSize}):Play()
			end)
			table.insert(VortexLibrary.ThemeListeners, function(t)
				dropFrame.BackgroundColor3 = t.Element
				lbl.TextColor3 = t.TextMain
				selectedLbl.TextColor3 = t.Accent
				arrow.TextColor3 = t.TextSub
			end)
			return dropObj
		end
		tabBtn.MouseButton1Click:Connect(function()
			for _,tab in pairs(winObj.Tabs) do
				tab.Content.Visible = false
				TweenService:Create(tab.Button, TI_Default, {BackgroundColor3 = theme.TabInactive, TextColor3 = theme.TextSub}):Play()
			end
			tabContent.Visible = true
			TweenService:Create(tabBtn, TI_Default, {BackgroundColor3 = theme.TabActive, TextColor3 = theme.TextMain}):Play()
			winObj.CurrentTab = tabObj
		end)
		table.insert(winObj.Tabs, tabObj)
		if #winObj.Tabs == 1 then
			tabContent.Visible = true
			tabBtn.BackgroundColor3 = theme.TabActive
			tabBtn.TextColor3 = theme.TextMain
			winObj.CurrentTab = tabObj
		end
		return tabObj
	end
	return winObj
end
_G.Vortex = VortexLibrary
return VortexLibrary
