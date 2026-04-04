local UILibrary = {}

function UILibrary:CreateWindow(Title, Size)
	-- ScreenGui oluştur
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "UILibrary"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	-- Ana pencere frame'i
	local Window = Instance.new("Frame")
	Window.Name = "Window"
	Window.Size = Size or UDim2.new(0, 500, 0, 400)
	Window.Position = UDim2.new(0.5, -250, 0.5, -200)
	Window.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Window.BorderSizePixel = 0
	Window.Parent = ScreenGui
	
	-- Başlık çubuğu
	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Size = UDim2.new(1, 0, 0, 30)
	TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	TitleBar.BorderSizePixel = 0
	TitleBar.Parent = Window
	
	-- Başlık metni
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "Title"
	TitleLabel.Size = UDim2.new(1, -10, 1, 0)
	TitleLabel.Position = UDim2.new(0, 10, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = Title or "UI Library"
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.TextSize = 14
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = TitleBar
	
	-- UICorner ekle
	local WindowCorner = Instance.new("UICorner")
	WindowCorner.CornerRadius = UDim.new(0, 6)
	WindowCorner.Parent = Window
	
	-- Tab container
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
	
	-- Content container
	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Size = UDim2.new(1, -10, 1, -75)
	ContentContainer.Position = UDim2.new(0, 5, 0, 70)
	ContentContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	ContentContainer.BorderSizePixel = 0
	ContentContainer.Parent = Window
	
	local ContentCorner = Instance.new("UICorner")
	ContentCorner.CornerRadius = UDim.new(0, 4)
	ContentCorner.Parent = ContentContainer
	
	-- ScreenGui'yi player'a ekle
	ScreenGui.Parent = game:GetService("CoreGui")
	
	-- Window objesi
	local WindowObject = {}
	WindowObject.Tabs = {}
	WindowObject.CurrentTab = nil
	
	function WindowObject:CreateTab(Name)
		-- Tab button
		local TabButton = Instance.new("TextButton")
		TabButton.Name = Name
		TabButton.Size = UDim2.new(0, 100, 1, 0)
		TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		TabButton.BorderSizePixel = 0
		TabButton.Text = Name
		TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
		TabButton.TextSize = 12
		TabButton.Font = Enum.Font.Gotham
		TabButton.Parent = TabContainer
		
		local TabCorner = Instance.new("UICorner")
		TabCorner.CornerRadius = UDim.new(0, 4)
		TabCorner.Parent = TabButton
		
		-- Tab content
		local TabContent = Instance.new("Frame")
		TabContent.Name = Name .. "Content"
		TabContent.Size = UDim2.new(1, 0, 1, 0)
		TabContent.BackgroundTransparency = 1
		TabContent.Visible = false
		TabContent.Parent = ContentContainer
		
		-- ScrollingFrame for tab content
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
		
		-- Auto-resize ScrollingFrame
		ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
		end)
		
		-- Tab objesi
		local TabObject = {}
		TabObject.Button = TabButton
		TabObject.Content = TabContent
		TabObject.ScrollFrame = ScrollFrame
		TabObject.Name = Name
		
		function TabObject:CreateButton(Text, Callback)
			local Button = Instance.new("TextButton")
			Button.Name = "Button"
			Button.Size = UDim2.new(1, -10, 0, 35)
			Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			Button.BorderSizePixel = 0
			Button.Text = Text or "Button"
			Button.TextColor3 = Color3.fromRGB(255, 255, 255)
			Button.TextSize = 13
			Button.Font = Enum.Font.Gotham
			Button.Parent = ScrollFrame
			
			local ButtonCorner = Instance.new("UICorner")
			ButtonCorner.CornerRadius = UDim.new(0, 4)
			ButtonCorner.Parent = Button
			
			-- Hover effect
			Button.MouseEnter:Connect(function()
				Button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
			end)
			
			Button.MouseLeave:Connect(function()
				Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			end)
			
			-- Click event
			Button.MouseButton1Click:Connect(function()
				if Callback then
					Callback()
				end
			end)
			
			return Button
		end
		
		-- Tab'ı aktif et
		TabButton.MouseButton1Click:Connect(function()
			for _, tab in pairs(WindowObject.Tabs) do
				tab.Content.Visible = false
				tab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
			end
			
			TabContent.Visible = true
			TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			WindowObject.CurrentTab = TabObject
		end)
		
		table.insert(WindowObject.Tabs, TabObject)
		
		-- İlk tab ise otomatik aktif et
		if #WindowObject.Tabs == 1 then
			TabContent.Visible = true
			TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			WindowObject.CurrentTab = TabObject
		end
		
		return TabObject
	end
	
	return WindowObject
end

return UILibrary
