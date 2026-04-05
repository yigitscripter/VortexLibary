-- ╔══════════════════════════════════════════════════════════════════╗
-- ║           VORTEX ENGINE v3.0 - Creative UI Engine               ║
-- ║     Unlimited UI Creation System - No Design Limitations         ║
-- ╚══════════════════════════════════════════════════════════════════╝

local VortexEngine = {}
VortexEngine.__index = VortexEngine
VortexEngine.Version = "3.0.0"

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- ═══════════════════════════════════════════════════════════════════
--  CORE SYSTEM
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine.new(parent)
	local self = setmetatable({}, VortexEngine)
	self.ScreenGui = Instance.new("ScreenGui")
	self.ScreenGui.Name = "VortexEngine"
	self.ScreenGui.ResetOnSpawn = false
	self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	self.ScreenGui.Parent = parent or Players.LocalPlayer:WaitForChild("PlayerGui")
	self.Elements = {}
	self.Animations = {}
	self.Connections = {}
	return self
end

-- ═══════════════════════════════════════════════════════════════════
--  CUSTOM ELEMENT CREATOR (FREEDOM MODE)
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:CreateCustomElement(config)
	config = config or {}
	local element = Instance.new(config.Type or "Frame")
	element.Name = config.Name or "CustomElement"
	element.Size = config.Size or UDim2.new(0, 100, 0, 100)
	element.Position = config.Position or UDim2.new(0, 0, 0, 0)
	element.AnchorPoint = config.AnchorPoint or Vector2.new(0, 0)
	element.BackgroundColor3 = config.BackgroundColor3 or Color3.fromRGB(255, 255, 255)
	element.BackgroundTransparency = config.BackgroundTransparency or 0
	element.BorderSizePixel = config.BorderSizePixel or 0
	element.ZIndex = config.ZIndex or 1
	element.Rotation = config.Rotation or 0
	
	if config.Type == "ImageLabel" or config.Type == "ImageButton" then
		element.Image = config.Image or ""
		element.ImageColor3 = config.ImageColor3 or Color3.fromRGB(255, 255, 255)
		element.ImageTransparency = config.ImageTransparency or 0
		element.ScaleType = config.ScaleType or Enum.ScaleType.Stretch
	end
	
	if config.Type == "TextLabel" or config.Type == "TextButton" then
		element.Text = config.Text or ""
		element.TextColor3 = config.TextColor3 or Color3.fromRGB(255, 255, 255)
		element.TextSize = config.TextSize or 14
		element.Font = config.Font or Enum.Font.Gotham
		element.TextXAlignment = config.TextXAlignment or Enum.TextXAlignment.Center
		element.TextYAlignment = config.TextYAlignment or Enum.TextYAlignment.Center
		element.TextWrapped = config.TextWrapped or false
	end
	
	if config.UICorner then
		local corner = Instance.new("UICorner")
		corner.CornerRadius = config.UICorner
		corner.Parent = element
	end
	
	if config.UIStroke then
		local stroke = Instance.new("UIStroke")
		stroke.Color = config.UIStroke.Color or Color3.fromRGB(255, 255, 255)
		stroke.Thickness = config.UIStroke.Thickness or 1
		stroke.Transparency = config.UIStroke.Transparency or 0
		stroke.Parent = element
	end
	
	if config.UIGradient then
		local gradient = Instance.new("UIGradient")
		gradient.Color = config.UIGradient.Color or ColorSequence.new(Color3.fromRGB(255, 255, 255))
		gradient.Rotation = config.UIGradient.Rotation or 0
		gradient.Transparency = config.UIGradient.Transparency or NumberSequence.new(0)
		gradient.Offset = config.UIGradient.Offset or Vector2.new(0, 0)
		gradient.Parent = element
	end
	
	element.Parent = config.Parent or self.ScreenGui
	
	table.insert(self.Elements, element)
	return element
end

-- ═══════════════════════════════════════════════════════════════════
--  ANIMATION ENGINE
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:Tween(element, duration, properties, easingStyle, easingDirection, callback)
	easingStyle = easingStyle or Enum.EasingStyle.Quad
	easingDirection = easingDirection or Enum.EasingDirection.Out
	local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
	local tween = TweenService:Create(element, tweenInfo, properties)
	tween:Play()
	if callback then
		tween.Completed:Connect(callback)
	end
	return tween
end

function VortexEngine:ChainTween(element, tweenData)
	local function playNext(index)
		if index > #tweenData then return end
		local data = tweenData[index]
		local tween = self:Tween(
			element,
			data.Duration or 0.3,
			data.Properties,
			data.EasingStyle,
			data.EasingDirection,
			function()
				if data.Callback then data.Callback() end
				playNext(index + 1)
			end
		)
	end
	playNext(1)
end

function VortexEngine:LoopTween(element, duration, properties, easingStyle, easingDirection)
	easingStyle = easingStyle or Enum.EasingStyle.Sine
	easingDirection = easingDirection or Enum.EasingDirection.InOut
	local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection, -1, true)
	local tween = TweenService:Create(element, tweenInfo, properties)
	tween:Play()
	table.insert(self.Animations, tween)
	return tween
end

function VortexEngine:PulseEffect(element, minSize, maxSize, duration)
	duration = duration or 1
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
	local tween = TweenService:Create(element, tweenInfo, {Size = maxSize})
	tween:Play()
	table.insert(self.Animations, tween)
	return tween
end

function VortexEngine:GlowEffect(element, minTransparency, maxTransparency, duration)
	duration = duration or 1.5
	local glow = element:FindFirstChildOfClass("ImageLabel") or self:CreateCustomElement({
		Type = "ImageLabel",
		Parent = element,
		Size = UDim2.new(1.5, 0, 1.5, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = "rbxassetid://6031097225",
		ImageColor3 = element.BackgroundColor3,
		ImageTransparency = minTransparency,
		ZIndex = element.ZIndex - 1
	})
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
	local tween = TweenService:Create(glow, tweenInfo, {ImageTransparency = maxTransparency})
	tween:Play()
	table.insert(self.Animations, tween)
	return glow
end

function VortexEngine:RotateLoop(element, duration, degrees)
	duration = duration or 2
	degrees = degrees or 360
	local startRotation = element.Rotation
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false)
	local tween = TweenService:Create(element, tweenInfo, {Rotation = startRotation + degrees})
	tween:Play()
	table.insert(self.Animations, tween)
	return tween
end

function VortexEngine:HoverEffect(element, hoverProperties, normalProperties, duration)
	duration = duration or 0.2
	element.MouseEnter:Connect(function()
		self:Tween(element, duration, hoverProperties)
	end)
	element.MouseLeave:Connect(function()
		self:Tween(element, duration, normalProperties)
	end)
end

function VortexEngine:ClickEffect(element, clickProperties, normalProperties, duration)
	duration = duration or 0.15
	element.MouseButton1Down:Connect(function()
		self:Tween(element, duration, clickProperties)
	end)
	element.MouseButton1Up:Connect(function()
		self:Tween(element, duration, normalProperties)
	end)
end

function VortexEngine:RippleEffect(element, color)
	color = color or Color3.fromRGB(255, 255, 255)
	element.MouseButton1Click:Connect(function()
		local ripple = self:CreateCustomElement({
			Type = "Frame",
			Parent = element,
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = color,
			BackgroundTransparency = 0.5,
			UICorner = UDim.new(1, 0),
			ZIndex = element.ZIndex + 1
		})
		self:Tween(ripple, 0.5, {
			Size = UDim2.new(2, 0, 2, 0),
			BackgroundTransparency = 1
		}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
			ripple:Destroy()
		end)
	end)
end

-- ═══════════════════════════════════════════════════════════════════
--  COMPONENT SYSTEM
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:CreateButton(config)
	config = config or {}
	local button = self:CreateCustomElement({
		Type = "TextButton",
		Name = config.Name or "Button",
		Size = config.Size or UDim2.new(0, 150, 0, 40),
		Position = config.Position or UDim2.new(0, 0, 0, 0),
		AnchorPoint = config.AnchorPoint,
		BackgroundColor3 = config.BackgroundColor3 or Color3.fromRGB(60, 60, 60),
		Text = config.Text or "Button",
		TextColor3 = config.TextColor3 or Color3.fromRGB(255, 255, 255),
		TextSize = config.TextSize or 14,
		Font = config.Font or Enum.Font.GothamBold,
		UICorner = config.UICorner or UDim.new(0, 8),
		UIStroke = config.UIStroke,
		UIGradient = config.UIGradient,
		Parent = config.Parent,
		ZIndex = config.ZIndex
	})
	
	if config.HoverEffect ~= false then
		self:HoverEffect(button, 
			{BackgroundColor3 = config.HoverColor or Color3.fromRGB(80, 80, 80)},
			{BackgroundColor3 = config.BackgroundColor3 or Color3.fromRGB(60, 60, 60)},
			0.2
		)
	end
	
	if config.ClickEffect ~= false then
		self:ClickEffect(button,
			{Size = (config.Size or UDim2.new(0, 150, 0, 40)) - UDim2.new(0, 4, 0, 4)},
			{Size = config.Size or UDim2.new(0, 150, 0, 40)},
			0.1
		)
	end
	
	if config.RippleEffect then
		self:RippleEffect(button, config.RippleColor)
	end
	
	if config.OnClick then
		button.MouseButton1Click:Connect(config.OnClick)
	end
	
	return button
end

function VortexEngine:CreateToggle(config)
	config = config or {}
	local toggled = config.Default or false
	
	local container = self:CreateCustomElement({
		Type = "Frame",
		Name = config.Name or "Toggle",
		Size = config.Size or UDim2.new(0, 200, 0, 40),
		Position = config.Position or UDim2.new(0, 0, 0, 0),
		AnchorPoint = config.AnchorPoint,
		BackgroundColor3 = config.BackgroundColor3 or Color3.fromRGB(40, 40, 40),
		UICorner = config.UICorner or UDim.new(0, 8),
		Parent = config.Parent,
		ZIndex = config.ZIndex
	})
	
	local label = self:CreateCustomElement({
		Type = "TextLabel",
		Parent = container,
		Size = UDim2.new(1, -60, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1,
		Text = config.Text or "Toggle",
		TextColor3 = config.TextColor3 or Color3.fromRGB(255, 255, 255),
		TextSize = config.TextSize or 14,
		Font = config.Font or Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = container.ZIndex + 1
	})
	
	local track = self:CreateCustomElement({
		Type = "Frame",
		Parent = container,
		Size = UDim2.new(0, 44, 0, 24),
		Position = UDim2.new(1, -50, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = toggled and (config.ActiveColor or Color3.fromRGB(0, 200, 100)) or (config.InactiveColor or Color3.fromRGB(80, 80, 80)),
		UICorner = UDim.new(1, 0),
		ZIndex = container.ZIndex + 1
	})
	
	local knob = self:CreateCustomElement({
		Type = "Frame",
		Parent = track,
		Size = UDim2.new(0, 18, 0, 18),
		Position = toggled and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		UICorner = UDim.new(1, 0),
		ZIndex = track.ZIndex + 1
	})
	
	local button = self:CreateCustomElement({
		Type = "TextButton",
		Parent = container,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = container.ZIndex + 2
	})
	
	button.MouseButton1Click:Connect(function()
		toggled = not toggled
		self:Tween(track, 0.2, {BackgroundColor3 = toggled and (config.ActiveColor or Color3.fromRGB(0, 200, 100)) or (config.InactiveColor or Color3.fromRGB(80, 80, 80))})
		self:Tween(knob, 0.2, {Position = toggled and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)})
		if config.OnToggle then
			pcall(function() config.OnToggle(toggled) end)
		end
	end)
	
	return {Container = container, Value = toggled, SetValue = function(val)
		toggled = val
		track.BackgroundColor3 = toggled and (config.ActiveColor or Color3.fromRGB(0, 200, 100)) or (config.InactiveColor or Color3.fromRGB(80, 80, 80))
		knob.Position = toggled and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
	end}
end

function VortexEngine:CreateSlider(config)
	config = config or {}
	local min = config.Min or 0
	local max = config.Max or 100
	local value = config.Default or min
	
	local container = self:CreateCustomElement({
		Type = "Frame",
		Name = config.Name or "Slider",
		Size = config.Size or UDim2.new(0, 250, 0, 60),
		Position = config.Position or UDim2.new(0, 0, 0, 0),
		AnchorPoint = config.AnchorPoint,
		BackgroundColor3 = config.BackgroundColor3 or Color3.fromRGB(40, 40, 40),
		UICorner = config.UICorner or UDim.new(0, 8),
		Parent = config.Parent,
		ZIndex = config.ZIndex
	})
	
	local label = self:CreateCustomElement({
		Type = "TextLabel",
		Parent = container,
		Size = UDim2.new(0.6, 0, 0, 20),
		Position = UDim2.new(0, 10, 0, 8),
		BackgroundTransparency = 1,
		Text = config.Text or "Slider",
		TextColor3 = config.TextColor3 or Color3.fromRGB(255, 255, 255),
		TextSize = config.TextSize or 13,
		Font = config.Font or Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = container.ZIndex + 1
	})
	
	local valueLabel = self:CreateCustomElement({
		Type = "TextLabel",
		Parent = container,
		Size = UDim2.new(0.4, -10, 0, 20),
		Position = UDim2.new(0.6, 0, 0, 8),
		BackgroundTransparency = 1,
		Text = tostring(value),
		TextColor3 = config.AccentColor or Color3.fromRGB(100, 150, 255),
		TextSize = 13,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Right,
		ZIndex = container.ZIndex + 1
	})
	
	local trackBg = self:CreateCustomElement({
		Type = "Frame",
		Parent = container,
		Size = UDim2.new(1, -20, 0, 8),
		Position = UDim2.new(0, 10, 1, -18),
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		UICorner = UDim.new(1, 0),
		ZIndex = container.ZIndex + 1
	})
	
	local fill = self:CreateCustomElement({
		Type = "Frame",
		Parent = trackBg,
		Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
		BackgroundColor3 = config.AccentColor or Color3.fromRGB(100, 150, 255),
		UICorner = UDim.new(1, 0),
		ZIndex = trackBg.ZIndex + 1
	})
	
	local knob = self:CreateCustomElement({
		Type = "Frame",
		Parent = trackBg,
		Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new((value - min) / (max - min), -7, 0.5, -7),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		UICorner = UDim.new(1, 0),
		ZIndex = trackBg.ZIndex + 2
	})
	
	local dragging = false
	local button = self:CreateCustomElement({
		Type = "TextButton",
		Parent = container,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = container.ZIndex + 3
	})
	
	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mousePos = UserInputService:GetMouseLocation().X
			local trackPos = trackBg.AbsolutePosition.X
			local trackSize = trackBg.AbsoluteSize.X
			local relative = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
			value = math.floor(min + (max - min) * relative)
			valueLabel.Text = tostring(value)
			fill.Size = UDim2.new(relative, 0, 1, 0)
			knob.Position = UDim2.new(relative, -7, 0.5, -7)
			if config.OnChange then
				pcall(function() config.OnChange(value) end)
			end
		end
	end)
	
	return {Container = container, Value = value, SetValue = function(val)
		value = math.clamp(val, min, max)
		valueLabel.Text = tostring(value)
		local relative = (value - min) / (max - min)
		fill.Size = UDim2.new(relative, 0, 1, 0)
		knob.Position = UDim2.new(relative, -7, 0.5, -7)
	end}
end

function VortexEngine:CreateText(config)
	config = config or {}
	return self:CreateCustomElement({
		Type = "TextLabel",
		Name = config.Name or "Text",
		Size = config.Size or UDim2.new(0, 200, 0, 30),
		Position = config.Position or UDim2.new(0, 0, 0, 0),
		AnchorPoint = config.AnchorPoint,
		BackgroundColor3 = config.BackgroundColor3 or Color3.fromRGB(40, 40, 40),
		BackgroundTransparency = config.BackgroundTransparency or 0,
		Text = config.Text or "Text",
		TextColor3 = config.TextColor3 or Color3.fromRGB(255, 255, 255),
		TextSize = config.TextSize or 14,
		Font = config.Font or Enum.Font.Gotham,
		TextXAlignment = config.TextXAlignment,
		TextYAlignment = config.TextYAlignment,
		TextWrapped = config.TextWrapped,
		UICorner = config.UICorner,
		UIStroke = config.UIStroke,
		UIGradient = config.UIGradient,
		Parent = config.Parent,
		ZIndex = config.ZIndex
	})
end

function VortexEngine:CreateImage(config)
	config = config or {}
	return self:CreateCustomElement({
		Type = "ImageLabel",
		Name = config.Name or "Image",
		Size = config.Size or UDim2.new(0, 100, 0, 100),
		Position = config.Position or UDim2.new(0, 0, 0, 0),
		AnchorPoint = config.AnchorPoint,
		BackgroundTransparency = config.BackgroundTransparency or 1,
		Image = config.Image or "",
		ImageColor3 = config.ImageColor3 or Color3.fromRGB(255, 255, 255),
		ImageTransparency = config.ImageTransparency or 0,
		ScaleType = config.ScaleType or Enum.ScaleType.Stretch,
		UICorner = config.UICorner,
		UIStroke = config.UIStroke,
		Parent = config.Parent,
		ZIndex = config.ZIndex
	})
end

-- ═══════════════════════════════════════════════════════════════════
--  SPRITE ANIMATION SYSTEM (Fake GIF)
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:CreateSpriteAnimation(config)
	config = config or {}
	local imageLabel = self:CreateImage({
		Size = config.Size,
		Position = config.Position,
		AnchorPoint = config.AnchorPoint,
		Parent = config.Parent,
		ZIndex = config.ZIndex,
		BackgroundTransparency = 1
	})
	
	local frames = config.Frames or {}
	local fps = config.FPS or 10
	local loop = config.Loop ~= false
	local currentFrame = 1
	
	local connection
	connection = RunService.Heartbeat:Connect(function()
		wait(1 / fps)
		if frames[currentFrame] then
			imageLabel.Image = frames[currentFrame]
		end
		currentFrame = currentFrame + 1
		if currentFrame > #frames then
			if loop then
				currentFrame = 1
			else
				connection:Disconnect()
			end
		end
	end)
	
	table.insert(self.Connections, connection)
	return imageLabel
end

-- ═══════════════════════════════════════════════════════════════════
--  DRAG SYSTEM
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:MakeDraggable(element, dragHandle)
	dragHandle = dragHandle or element
	local dragging, dragInput, mousePos, framePos = false, nil, nil, nil
	
	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = input.Position
			framePos = element.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	dragHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			element.Position = UDim2.new(
				framePos.X.Scale,
				framePos.X.Offset + delta.X,
				framePos.Y.Scale,
				framePos.Y.Offset + delta.Y
			)
		end
	end)
end

-- ═══════════════════════════════════════════════════════════════════
--  UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:Destroy()
	for _, anim in pairs(self.Animations) do
		pcall(function() anim:Cancel() end)
	end
	for _, conn in pairs(self.Connections) do
		pcall(function() conn:Disconnect() end)
	end
	self.ScreenGui:Destroy()
end

function VortexEngine:ClearAnimations()
	for _, anim in pairs(self.Animations) do
		pcall(function() anim:Cancel() end)
	end
	self.Animations = {}
end

function VortexEngine:GetElement(name)
	for _, element in pairs(self.Elements) do
		if element.Name == name then
			return element
		end
	end
	return nil
end

_G.VortexEngine = VortexEngine
return VortexEngine
