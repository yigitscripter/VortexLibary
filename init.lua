-- VortexLibrary - Gelişmiş Roblox UI Kütüphanesi
local UILibrary = {}

-- Servisler
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Tween ayarları
local TweenInfo_Default = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Tema sistemi
local Themes = {
	Dark = {
		Background = Color3.fromRGB(30, 30, 30),
		TitleBar = Color3.fromRGB(20, 20, 20),
		TabButton = Color3.fromRGB(40, 40, 40),
		TabButtonActive = Color3.fromRGB(60, 60, 60),
		ContentBackground = Color3.fromRGB(25, 25, 25),
		ButtonBackground = Color3.fromRGB(45, 45, 45),
		ButtonHover = Color3.fromRGB(55, 55, 55),
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(200, 200, 200),
		Accent = Color3.fromRGB(100, 100, 255),
		NotificationBackground = Color3.fromRGB(35, 35, 35)
	},
	Light = {
		Background = Color3.fromRGB(240, 240, 240),
		TitleBar = Color3.fromRGB(220, 220, 220),
		TabButton = Color3.fromRGB(200, 200, 200),
		TabButtonActive = Color3.fromRGB(180, 180, 180),
		ContentBackground = Color3.fromRGB(230, 230, 230),
		ButtonBackground = Color3.fromRGB(210, 210, 210),
		ButtonHover = Color3.fromRGB(190, 190, 190),
		TextPrimary = Color3.fromRGB(20, 20, 20),
		TextSecondary = Color3.fromRGB(60, 60, 60),
		Accent = Color3.fromRGB(70, 130, 255),
		NotificationBackground = Color3.fromRGB(250, 250, 250)
	},
	Aqua = {
		Background = Color3.fromRGB(15, 35, 45),
		TitleBar = Color3.fromRGB(10, 25, 35),
		TabButton = Color3.fromRGB(20, 45, 60),
		TabButtonActive = Color3.fromRGB(30, 65, 85),
		ContentBackground = Color3.fromRGB(18, 40, 50),
		ButtonBackground = Color3.fromRGB(25, 55, 70),
		ButtonHover = Color3.fromRGB(35, 75, 95),
		TextPrimary = Color3.fromRGB(200, 240, 255),
		TextSecondary = Color3.fromRGB(150, 200, 220),
		Accent = Color3.fromRGB(0, 200, 255),
		NotificationBackground = Color3.fromRGB(20, 45, 60)
	},
	Purple = {
		Background = Color3.fromRGB(35, 20, 45),
		TitleBar = Color3.fromRGB(25, 15, 35),
		TabButton = Color3.fromRGB(50, 30, 65),
		TabButtonActive = Color3.fromRGB(70, 45, 90),
		ContentBackground = Color3.fromRGB(40, 25, 50),
		ButtonBackground = Color3.fromRGB(60, 40, 75),
		ButtonHover = Color3.fromRGB(80, 55, 100),
		TextPrimary = Color3.fromRGB(240, 220, 255),
		TextSecondary = Color3.fromRGB(200, 180, 220),
		Accent = Color3.fromRGB(180, 100, 255),
		NotificationBackground = Color3.fromRGB(45, 30, 60)
	},
	Midnight = {
		Background = Color3.fromRGB(10, 10, 20),
		TitleBar = Color3.fromRGB(5, 5, 15),
		TabButton = Color3.fromRGB(15, 15, 30),
		TabButtonActive = Color3.fromRGB(25, 25, 45),
		ContentBackground = Color3.fromRGB(12, 12, 22),
		ButtonBackground = Color3.fromRGB(20, 20, 35),
		ButtonHover = Color3.fromRGB(30, 30, 50),
		TextPrimary = Color3.fromRGB(220, 220, 240),
		TextSecondary = Color3.fromRGB(160, 160, 180),
		Accent = Color3.fromRGB(100, 150, 255),
		NotificationBackground = Color3.fromRGB(15, 15, 25)
	}
}

UILibrary.CurrentTheme = "Dark"
UILibrary.Windows = {}
UILibrary.NotificationQueue = {}

-- Tema değiştirme fonksiyonu
function UILibrary:SetTheme(ThemeName)
	if not Themes[ThemeName] then
		warn("Tema bulunamadı: " .. ThemeName)
		return
	end
	self.CurrentTheme = ThemeName
	local theme = Themes[ThemeName]
	for _, windowData in pairs(self.Windows) do
		pcall(function()
			TweenService:Create(windowData.Window, TweenInfo_Default, {BackgroundColor3 = theme.Background}):Play()
			TweenService:Create(windowData.TitleBar, TweenInfo_Default, {BackgroundColor3 = theme.TitleBar}):Play()
			TweenService:Create(windowData.TitleLabel, TweenInfo_Default, {TextColor3 = theme.TextPrimary}):Play()
			TweenService:Create(windowData.ContentContainer, TweenInfo_Default, {BackgroundColor3 = theme.ContentBackground}):Play()
		end)
	end
end

-- Bildirim sistemi
function UILibrary:Notify(Title, Message, Duration)
	Duration = Duration or 3
	local theme = Themes[self.CurrentTheme]
	pcall(function()
		local NotificationGui = Instance.new("ScreenGui")
		NotificationGui.Name = "VortexNotification"
		NotificationGui.ResetOnSpawn = false
		NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		NotificationGui.Parent = game:GetService("CoreGui")
		local NotificationCard = Instance.new("Frame")
		NotificationCard.Size = UDim2.new(0, 300, 0, 80)
		NotificationCard.Position = UDim2.new(1, 320, 1, -100 - (#self.NotificationQueue * 90))
		NotificationCard.BackgroundColor3 = theme.NotificationBackground
		NotificationCard.BorderSizePixel = 0
		NotificationCard.Parent = NotificationGui
		local CardCorner = Instance.new("UICorner")
		CardCorner.CornerRadius = UDim.new(0, 6)
		CardCorner.Parent = NotificationCard
		local TitleLabel = Instance.new("TextLabel")
		TitleLabel.Size = UDim2.new(1, -20, 0, 20)
		TitleLabel.Position = UDim2.new(0, 10, 0, 8)
		TitleLabel.BackgroundTransparency = 1
		TitleLabel.Text = Title
		TitleLabel.TextColor3 = theme.TextPrimary
		TitleLabel.TextSize = 14
		TitleLabel.Font = Enum.Font.GothamBold
		TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
		TitleLabel.Parent = NotificationCard
		local MessageLabel = Instance.new("TextLabel")
		MessageLabel.Size = UDim2.new(1, -20, 0, 30)
		MessageLabel.Position = UDim2.new(0, 10, 0, 28)
		MessageLabel.BackgroundTransparency = 1
		MessageLabel.Text = Message
		MessageLabel.TextColor3 = theme.TextSecondary
		MessageLabel.TextSize = 12
		MessageLabel.Font = Enum.Font.Gotham
		MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
		MessageLabel.TextYAlignment = Enum.TextYAlignment.Top
		MessageLabel.TextWrapped = true
		MessageLabel.Parent = NotificationCard
		local ProgressBg = Instance.new("Frame")
		ProgressBg.Size = UDim2.new(1, -20, 0, 3)
		ProgressBg.Position = UDim2.new(0, 10, 1, -10)
		ProgressBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		ProgressBg.BorderSizePixel = 0
		ProgressBg.Parent = NotificationCard
		local ProgressCorner = Instance.new("UICorner")
		ProgressCorner.CornerRadius = UDim.new(1, 0)
		ProgressCorner.Parent = ProgressBg
		local ProgressBar = Instance.new("Frame")
		ProgressBar.Size = UDim2.new(0, 0, 1, 0)
		ProgressBar.BackgroundColor3 = theme.Accent
		ProgressBar.BorderSizePixel = 0
		ProgressBar.Parent = ProgressBg
		local ProgressBarCorner = Instance.new("UICorner")
		ProgressBarCorner.CornerRadius = UDim.new(1, 0)
		ProgressBarCorner.Parent = ProgressBar
		table.insert(self.NotificationQueue, NotificationCard)
		TweenService:Create(NotificationCard, TweenInfo_Default, {Position = UDim2.new(1, -310, 1, -100 - (#self.NotificationQueue * 90))}):Play()
		TweenService:Create(ProgressBar, TweenInfo.new(Duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}):Play()
		task.delay(Duration, function()
			TweenService:Create(NotificationCard, TweenInfo_Default, {Position = UDim2.new(1, 320, NotificationCard.Position.Y.Scale, NotificationCard.Position.Y.Offset)}):Play()
			task.wait(0.3)
			NotificationGui:Destroy()
			for i, card in pairs(self.NotificationQueue) do
				if card == NotificationCard then table.remove(self.NotificationQueue, i) break end
			end
		end)
	end)
end

function UILibrary:CreateWindow(Title, Size)
	local theme = Themes[self.CurrentTheme]
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "VortexLibrary"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	local Window = Instance.new("Frame")
	Window.Name = "Window"
	Window.Size = UDim2.new(0, 0, 0, 0)
	Window.Position = UDim2.new(0.5, -250, 0.5, -200)
	Window.BackgroundColor3 = theme.Background
	Window.BackgroundTransparency = 1
	Window.BorderSizePixel = 0
	Window.Parent = ScreenGui
	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Size = UDim2.new(1, 0, 0, 30)
	TitleBar.BackgroundColor3 = theme.TitleBar
	TitleBar.BorderSizePixel = 0
	TitleBar.Parent = Window
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "Title"
	TitleLabel.Size = UDim2.new(1, -10, 1, 0)
	TitleLabel.Position = UDim2.new(0, 10, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = Title or "Vortex Library"
	TitleLabel.TextColor3 = theme.TextPrimary
	TitleLabel.TextSize = 14
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = TitleBar
	local WindowCorner = Instance.new("UICorner")
	WindowCorner.CornerRadius = UDim.new(0, 6)
	WindowCorner.Parent = Window
	-- Drag sistemi
	local dragging, dragInput, mousePos, framePos = false, nil, nil, nil
	TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = input.Position
			framePos = Window.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	TitleBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			local viewportSize = workspace.CurrentCamera.ViewportSize
			local windowSize = Window.AbsoluteSize
			local clampedX = math.clamp(framePos.X.Offset + delta.X, 0, viewportSize.X - windowSize.X)
			local clampedY = math.clamp(framePos.Y.Offset + delta.Y, 0, viewportSize.Y - windowSize.Y)
			Window.Position = UDim2.new(0, clampedX, 0, clampedY)
		end
	end)
	local TabContainer = Instance.new("Frame")
	TabContainer.Name = "TabContainer"
	TabContainer.Size = UDim2.new(1, -10, 0, 30)
	TabContainer.Position = UDim2.new(0, 5, 0, 35)
	TabContainer.BackgroundTransparency = 1
	TabContainer.Parent = Window
	local TabLayout = Instance.new("UIListLayout")
	TabLayout.FillDirection = Enum.FillDirection.Horizontal
	TabLayout.Padding = UDim.new(0, 5)
	TabLayout.Parent = TabContainer
	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Size = UDim2.new(1, -10, 1, -75)
	ContentContainer.Position = UDim2.new(0, 5, 0, 70)
	ContentContainer.BackgroundColor3 = theme.ContentBackground
	ContentContainer.BorderSizePixel = 0
	ContentContainer.Parent = Window
	local ContentCorner = Instance.new("UICorner")
	ContentCorner.CornerRadius = UDim.new(0, 4)
	ContentCorner.Parent = ContentContainer
	ScreenGui.Parent = game:GetService("CoreGui")
	local targetSize = Size or UDim2.new(0, 500, 0, 400)
	TweenService:Create(Window, TweenInfo_Default, {Size = targetSize, BackgroundTransparency = 0}):Play()
	local WindowObject = {}
	WindowObject.Tabs = {}
	WindowObject.CurrentTab = nil
	table.insert(UILibrary.Windows, {Window = Window, TitleBar = TitleBar, TitleLabel = TitleLabel, ContentContainer = ContentContainer, Tabs = WindowObject.Tabs})
	function WindowObject:CreateTab(Name)
		local theme = Themes[UILibrary.CurrentTheme]
		local TabButton = Instance.new("TextButton")
		TabButton.Name = Name
		TabButton.Size = UDim2.new(0, 100, 1, 0)
		TabButton.BackgroundColor3 = theme.TabButton
		TabButton.BorderSizePixel = 0
		TabButton.Text = Name
		TabButton.TextColor3 = theme.TextSecondary
		TabButton.TextSize = 12
		TabButton.Font = Enum.Font.Gotham
		TabButton.Parent = TabContainer
		local TabCorner = Instance.new("UICorner")
		TabCorner.CornerRadius = UDim.new(0, 4)
		TabCorner.Parent = TabButton
		local TabContent = Instance.new("Frame")
		TabContent.Name = Name .. "Content"
		TabContent.Size = UDim2.new(1, 0, 1, 0)
		TabContent.BackgroundTransparency = 1
		TabContent.Visible = false
		TabContent.Parent = ContentContainer
		local ScrollFrame = Instance.new("ScrollingFrame")
		ScrollFrame.Size = UDim2.new(1, -10, 1, -10)
		ScrollFrame.Position = UDim2.new(0, 5, 0, 5)
		ScrollFrame.BackgroundTransparency = 1
		ScrollFrame.BorderSizePixel = 0
		ScrollFrame.ScrollBarThickness = 4
		ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
		ScrollFrame.Parent = TabContent
		local ContentLayout = Instance.new("UIListLayout")
		ContentLayout.Padding = UDim.new(0, 5)
		ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ContentLayout.Parent = ScrollFrame
		ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
		end)
		local TabObject = {}
		TabObject.Button = TabButton
		TabObject.Content = TabContent
		TabObject.ScrollFrame = ScrollFrame
		TabObject.Name = Name
		TabObject.LayoutOrder = 0
		-- CreateButton
		function TabObject:CreateButton(Text, Callback)
			local theme = Themes[UILibrary.CurrentTheme]
			TabObject.LayoutOrder = TabObject.LayoutOrder + 1
			local Button = Instance.new("TextButton")
			Button.Name = "Button"
			Button.Size = UDim2.new(1, -10, 0, 35)
			Button.BackgroundColor3 = theme.ButtonBackground
			Button.BorderSizePixel = 0
			Button.Text = Text or "Button"
			Button.TextColor3 = theme.TextPrimary
			Button.TextSize = 13
			Button.Font = Enum.Font.Gotham
			Button.LayoutOrder = TabObject.LayoutOrder
			Button.Parent = ScrollFrame
			local ButtonCorner = Instance.new("UICorner")
			ButtonCorner.CornerRadius = UDim.new(0, 4)
			ButtonCorner.Parent = Button
			Button.MouseEnter:Connect(function()
				TweenService:Create(Button, TweenInfo_Default, {BackgroundColor3 = theme.ButtonHover}):Play()
			end)
			Button.MouseLeave:Connect(function()
				TweenService:Create(Button, TweenInfo_Default, {BackgroundColor3 = theme.ButtonBackground}):Play()
			end)
			Button.MouseButton1Click:Connect(function()
				if Callback then pcall(Callback) end
			end)
			return Button
		end
		-- CreateToggle
		function TabObject:CreateToggle(Text, DefaultValue, Callback)
			local theme = Themes[UILibrary.CurrentTheme]
			TabObject.LayoutOrder = TabObject.LayoutOrder + 1
			local toggled = DefaultValue or false
			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Name = "Toggle"
			ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
			ToggleFrame.BackgroundColor3 = theme.ButtonBackground
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.LayoutOrder = TabObject.LayoutOrder
			ToggleFrame.Parent = ScrollFrame
			local ToggleCorner = Instance.new("UICorner")
			ToggleCorner.CornerRadius = UDim.new(0, 4)
			ToggleCorner.Parent = ToggleFrame
			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, -60, 1, 0)
			Label.Position = UDim2.new(0, 10, 0, 0)
			Label.BackgroundTransparency = 1
			Label.Text = Text or "Toggle"
			Label.TextColor3 = theme.TextPrimary
			Label.TextSize = 13
			Label.Font = Enum.Font.Gotham
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = ToggleFrame
			local SwitchBg = Instance.new("Frame")
			SwitchBg.Size = UDim2.new(0, 40, 0, 20)
			SwitchBg.Position = UDim2.new(1, -50, 0.5, -10)
			SwitchBg.BackgroundColor3 = toggled and theme.Accent or Color3.fromRGB(60, 60, 60)
			SwitchBg.BorderSizePixel = 0
			SwitchBg.Parent = ToggleFrame
			local SwitchCorner = Instance.new("UICorner")
			SwitchCorner.CornerRadius = UDim.new(1, 0)
			SwitchCorner.Parent = SwitchBg
			local SwitchCircle = Instance.new("Frame")
			SwitchCircle.Size = UDim2.new(0, 16, 0, 16)
			SwitchCircle.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
			SwitchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SwitchCircle.BorderSizePixel = 0
			SwitchCircle.Parent = SwitchBg
			local CircleCorner = Instance.new("UICorner")
			CircleCorner.CornerRadius = UDim.new(1, 0)
			CircleCorner.Parent = SwitchCircle
			local ToggleButton = Instance.new("TextButton")
			ToggleButton.Size = UDim2.new(1, 0, 1, 0)
			ToggleButton.BackgroundTransparency = 1
			ToggleButton.Text = ""
			ToggleButton.Parent = ToggleFrame
			ToggleButton.MouseButton1Click:Connect(function()
				toggled = not toggled
				TweenService:Create(SwitchBg, TweenInfo_Default, {BackgroundColor3 = toggled and theme.Accent or Color3.fromRGB(60, 60, 60)}):Play()
				TweenService:Create(SwitchCircle, TweenInfo_Default, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
				if Callback then pcall(function() Callback(toggled) end) end
			end)
			return ToggleFrame
		end
		-- CreateSlider
		function TabObject:CreateSlider(Text, Min, Max, Default, Callback)
			local theme = Themes[UILibrary.CurrentTheme]
			TabObject.LayoutOrder = TabObject.LayoutOrder + 1
			local value = Default or Min
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Name = "Slider"
			SliderFrame.Size = UDim2.new(1, -10, 0, 50)
			SliderFrame.BackgroundColor3 = theme.ButtonBackground
			SliderFrame.BorderSizePixel = 0
			SliderFrame.LayoutOrder = TabObject.LayoutOrder
			SliderFrame.Parent = ScrollFrame
			local SliderCorner = Instance.new("UICorner")
			SliderCorner.CornerRadius = UDim.new(0, 4)
			SliderCorner.Parent = SliderFrame
			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(0.7, 0, 0, 20)
			Label.Position = UDim2.new(0, 10, 0, 5)
			Label.BackgroundTransparency = 1
			Label.Text = Text or "Slider"
			Label.TextColor3 = theme.TextPrimary
			Label.TextSize = 13
			Label.Font = Enum.Font.Gotham
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = SliderFrame
			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Size = UDim2.new(0.3, -10, 0, 20)
			ValueLabel.Position = UDim2.new(0.7, 0, 0, 5)
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.Text = tostring(value)
			ValueLabel.TextColor3 = theme.Accent
			ValueLabel.TextSize = 13
			ValueLabel.Font = Enum.Font.GothamBold
			ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
			ValueLabel.Parent = SliderFrame
			local SliderBg = Instance.new("Frame")
			SliderBg.Size = UDim2.new(1, -20, 0, 6)
			SliderBg.Position = UDim2.new(0, 10, 1, -15)
			SliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			SliderBg.BorderSizePixel = 0
			SliderBg.Parent = SliderFrame
			local SliderBgCorner = Instance.new("UICorner")
			SliderBgCorner.CornerRadius = UDim.new(1, 0)
			SliderBgCorner.Parent = SliderBg
			local SliderFill = Instance.new("Frame")
			SliderFill.Size = UDim2.new((value - Min) / (Max - Min), 0, 1, 0)
			SliderFill.BackgroundColor3 = theme.Accent
			SliderFill.BorderSizePixel = 0
			SliderFill.Parent = SliderBg
			local SliderFillCorner = Instance.new("UICorner")
			SliderFillCorner.CornerRadius = UDim.new(1, 0)
			SliderFillCorner.Parent = SliderFill
			local SliderButton = Instance.new("TextButton")
			SliderButton.Size = UDim2.new(1, 0, 1, 0)
			SliderButton.BackgroundTransparency = 1
			SliderButton.Text = ""
			SliderButton.Parent = SliderFrame
			local dragging = false
			SliderButton.MouseButton1Down:Connect(function() dragging = true end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local mousePos = UserInputService:GetMouseLocation().X
					local sliderPos = SliderBg.AbsolutePosition.X
					local sliderSize = SliderBg.AbsoluteSize.X
					local relative = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
					value = math.floor(Min + (Max - Min) * relative)
					ValueLabel.Text = tostring(value)
					TweenService:Create(SliderFill, TweenInfo_Default, {Size = UDim2.new(relative, 0, 1, 0)}):Play()
					if Callback then pcall(function() Callback(value) end) end
				end
			end)
			return SliderFrame
		end
		-- CreateTextbox
		function TabObject:CreateTextbox(PlaceholderText, Callback)
			local theme = Themes[UILibrary.CurrentTheme]
			TabObject.LayoutOrder = TabObject.LayoutOrder + 1
			local TextboxFrame = Instance.new("Frame")
			TextboxFrame.Name = "Textbox"
			TextboxFrame.Size = UDim2.new(1, -10, 0, 35)
			TextboxFrame.BackgroundColor3 = theme.ButtonBackground
			TextboxFrame.BorderSizePixel = 0
			TextboxFrame.LayoutOrder = TabObject.LayoutOrder
			TextboxFrame.Parent = ScrollFrame
			local TextboxCorner = Instance.new("UICorner")
			TextboxCorner.CornerRadius = UDim.new(0, 4)
			TextboxCorner.Parent = TextboxFrame
			local Textbox = Instance.new("TextBox")
			Textbox.Size = UDim2.new(1, -20, 1, 0)
			Textbox.Position = UDim2.new(0, 10, 0, 0)
			Textbox.BackgroundTransparency = 1
			Textbox.PlaceholderText = PlaceholderText or "Metin girin..."
			Textbox.PlaceholderColor3 = theme.TextSecondary
			Textbox.Text = ""
			Textbox.TextColor3 = theme.TextPrimary
			Textbox.TextSize = 13
			Textbox.Font = Enum.Font.Gotham
			Textbox.TextXAlignment = Enum.TextXAlignment.Left
			Textbox.ClearTextOnFocus = false
			Textbox.Parent = TextboxFrame
			Textbox.FocusLost:Connect(function(enterPressed)
				if Callback and Textbox.Text ~= "" then pcall(function() Callback(Textbox.Text) end) end
			end)
			return TextboxFrame
		end
		-- CreateDropdown
		function TabObject:CreateDropdown(Text, Options, Callback)
			local theme = Themes[UILibrary.CurrentTheme]
			TabObject.LayoutOrder = TabObject.LayoutOrder + 1
			local isOpen = false
			local selectedOption = Options[1] or "Seçiniz"
			local DropdownFrame = Instance.new("Frame")
			DropdownFrame.Name = "Dropdown"
			DropdownFrame.Size = UDim2.new(1, -10, 0, 35)
			DropdownFrame.BackgroundColor3 = theme.ButtonBackground
			DropdownFrame.BorderSizePixel = 0
			DropdownFrame.LayoutOrder = TabObject.LayoutOrder
			DropdownFrame.ClipsDescendants = true
			DropdownFrame.Parent = ScrollFrame
			local DropdownCorner = Instance.new("UICorner")
			DropdownCorner.CornerRadius = UDim.new(0, 4)
			DropdownCorner.Parent = DropdownFrame
			local HeaderButton = Instance.new("TextButton")
			HeaderButton.Size = UDim2.new(1, 0, 0, 35)
			HeaderButton.BackgroundTransparency = 1
			HeaderButton.Text = ""
			HeaderButton.Parent = DropdownFrame
			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(0.5, -10, 0, 35)
			Label.Position = UDim2.new(0, 10, 0, 0)
			Label.BackgroundTransparency = 1
			Label.Text = Text or "Dropdown"
			Label.TextColor3 = theme.TextPrimary
			Label.TextSize = 13
			Label.Font = Enum.Font.Gotham
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = DropdownFrame
			local SelectedLabel = Instance.new("TextLabel")
			SelectedLabel.Size = UDim2.new(0.5, -20, 0, 35)
			SelectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
			SelectedLabel.BackgroundTransparency = 1
			SelectedLabel.Text = selectedOption
			SelectedLabel.TextColor3 = theme.Accent
			SelectedLabel.TextSize = 13
			SelectedLabel.Font = Enum.Font.GothamBold
			SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
			SelectedLabel.Parent = DropdownFrame
			local OptionsContainer = Instance.new("Frame")
			OptionsContainer.Size = UDim2.new(1, 0, 0, #Options * 30)
			OptionsContainer.Position = UDim2.new(0, 0, 0, 35)
			OptionsContainer.BackgroundTransparency = 1
			OptionsContainer.Parent = DropdownFrame
			local OptionsLayout = Instance.new("UIListLayout")
			OptionsLayout.Padding = UDim.new(0, 2)
			OptionsLayout.Parent = OptionsContainer
			for _, option in ipairs(Options) do
				local OptionButton = Instance.new("TextButton")
				OptionButton.Size = UDim2.new(1, -10, 0, 28)
				OptionButton.Position = UDim2.new(0, 5, 0, 0)
				OptionButton.BackgroundColor3 = theme.ContentBackground
				OptionButton.BorderSizePixel = 0
				OptionButton.Text = option
				OptionButton.TextColor3 = theme.TextPrimary
				OptionButton.TextSize = 12
				OptionButton.Font = Enum.Font.Gotham
				OptionButton.Parent = OptionsContainer
				local OptionCorner = Instance.new("UICorner")
				OptionCorner.CornerRadius = UDim.new(0, 3)
				OptionCorner.Parent = OptionButton
				OptionButton.MouseEnter:Connect(function()
					TweenService:Create(OptionButton, TweenInfo_Default, {BackgroundColor3 = theme.ButtonHover}):Play()
				end)
				OptionButton.MouseLeave:Connect(function()
					TweenService:Create(OptionButton, TweenInfo_Default, {BackgroundColor3 = theme.ContentBackground}):Play()
				end)
				OptionButton.MouseButton1Click:Connect(function()
					selectedOption = option
					SelectedLabel.Text = option
					isOpen = false
					TweenService:Create(DropdownFrame, TweenInfo_Default, {Size = UDim2.new(1, -10, 0, 35)}):Play()
					if Callback then pcall(function() Callback(option) end) end
				end)
			end
			HeaderButton.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				local targetSize = isOpen and UDim2.new(1, -10, 0, 35 + #Options * 30 + 5) or UDim2.new(1, -10, 0, 35)
				TweenService:Create(DropdownFrame, TweenInfo_Default, {Size = targetSize}):Play()
			end)
			return DropdownFrame
		end
		-- Tab aktivasyonu
		TabButton.MouseButton1Click:Connect(function()
			for _, tab in pairs(WindowObject.Tabs) do
				tab.Content.Visible = false
				TweenService:Create(tab.Button, TweenInfo_Default, {BackgroundColor3 = theme.TabButton, TextColor3 = theme.TextSecondary}):Play()
			end
			TabContent.Visible = true
			TweenService:Create(TabButton, TweenInfo_Default, {BackgroundColor3 = theme.TabButtonActive, TextColor3 = theme.TextPrimary}):Play()
			WindowObject.CurrentTab = TabObject
		end)
		table.insert(WindowObject.Tabs, TabObject)
		if #WindowObject.Tabs == 1 then
			TabContent.Visible = true
			TabButton.BackgroundColor3 = theme.TabButtonActive
			TabButton.TextColor3 = theme.TextPrimary
			WindowObject.CurrentTab = TabObject
		end
		return TabObject
	end
	return WindowObject
end

return UILibrary

-- ÖRNEK KULLANIM:
-- local Vortex = loadstring(game:HttpGet("https://raw.githubusercontent.com/yigitscripter/VortexLibary/refs/heads/main/init.lua"))()
-- Vortex:SetTheme("Aqua")
-- local Win = Vortex:CreateWindow("Test Penceresi", UDim2.new(0, 500, 0, 400))
-- local Tab = Win:CreateTab("Ana Sayfa")
-- Tab:CreateButton("Merhaba", function() print("Tıklandı!") end)
-- Tab:CreateToggle("God Mode", false, function(v) print("Toggle:", v) end)
-- Tab:CreateSlider("WalkSpeed", 16, 100, 16, function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end)
-- Tab:CreateTextbox("İsim gir...", function(t) print("Girilen:", t) end)
-- Tab:CreateDropdown("Takım Seç", {"Kırmızı","Mavi","Yeşil"}, function(s) print("Seçilen:", s) end)
-- Vortex:Notify("Başarılı", "Ayarlar kaydedildi.", 3)
