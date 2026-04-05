-- ╔══════════════════════════════════════════════════════════════════╗
-- ║           VORTEX ENGINE v3.0 - ULTIMATE UI CREATIVE ENGINE      ║
-- ║           Tam Özgürlük | Sınırsız Tasarım | Her Şeyi Yap       ║
-- ╚══════════════════════════════════════════════════════════════════╝

local VortexEngine = {}
VortexEngine.__index = VortexEngine
VortexEngine.Version = "3.0.0"
VortexEngine.Instances = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- ═══════════════════════════════════════════════════════════════════
--  CORE SYSTEM - Temel Motor
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine.new()
	local self = setmetatable({}, VortexEngine)
	self.ScreenGui = Instance.new("ScreenGui")
	self.ScreenGui.Name = "VortexEngine_" .. tick()
	self.ScreenGui.ResetOnSpawn = false
	self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	self.ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	self.Elements = {}
	self.Animations = {}
	table.insert(VortexEngine.Instances, self)
	return self
end

-- ═══════════════════════════════════════════════════════════════════
--  SHAPE ENGINE - Her Şekli Oluştur
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:CreateShape(config)
	config = config or {}
	local shape = Instance.new(config.Type or "Frame")
	shape.Name = config.Name or "Shape"
	shape.Size = config.Size or UDim2.new(0, 100, 0, 100)
	shape.Position = config.Position or UDim2.new(0, 0, 0, 0)
	shape.AnchorPoint = config.AnchorPoint or Vector2.new(0, 0)
	shape.BackgroundColor3 = config.Color or Color3.fromRGB(255, 255, 255)
	shape.BackgroundTransparency = config.Transparency or 0
	shape.BorderSizePixel = config.BorderSize or 0
	shape.Rotation = config.Rotation or 0
	shape.ZIndex = config.ZIndex or 1
	shape.ClipsDescendants = config.ClipChildren or false
	
	if config.Corner then
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(config.Corner.Scale or 0, config.Corner.Offset or 0)
		corner.Parent = shape
	end
	
	if config.Stroke then
		local stroke = Instance.new("UIStroke")
		stroke.Color = config.Stroke.Color or Color3.fromRGB(255, 255, 255)
		stroke.Thickness = config.Stroke.Thickness or 1
		stroke.Transparency = config.Stroke.Transparency or 0
		stroke.ApplyStrokeMode = config.Stroke.Mode or Enum.ApplyStrokeMode.Border
		stroke.Parent = shape
	end
	
	if config.Gradient then
		local gradient = Instance.new("UIGradient")
		gradient.Color = config.Gradient.Colors or ColorSequence.new(Color3.fromRGB(255,255,255))
		gradient.Rotation = config.Gradient.Rotation or 0
		gradient.Transparency = config.Gradient.Transparency or NumberSequence.new(0)
		gradient.Offset = config.Gradient.Offset or Vector2.new(0, 0)
		gradient.Parent = shape
	end
	
	if config.Image and shape:IsA("ImageLabel") then
		shape.Image = config.Image
		shape.ImageColor3 = config.ImageColor or Color3.fromRGB(255, 255, 255)
		shape.ImageTransparency = config.ImageTransparency or 0
		shape.ScaleType = config.ScaleType or Enum.ScaleType.Stretch
	end
	
	if config.Text and (shape:IsA("TextLabel") or shape:IsA("TextButton")) then
		shape.Text = config.Text
		shape.TextColor3 = config.TextColor or Color3.fromRGB(255, 255, 255)
		shape.TextSize = config.TextSize or 14
		shape.Font = config.Font or Enum.Font.Gotham
		shape.TextXAlignment = config.TextXAlign or Enum.TextXAlignment.Center
		shape.TextYAlignment = config.TextYAlign or Enum.TextYAlignment.Center
		shape.TextWrapped = config.TextWrap or false
		shape.TextScaled = config.TextScaled or false
	end
	
	shape.Parent = config.Parent or self.ScreenGui
	
	local element = {
		Instance = shape,
		Config = config,
		Children = {},
		Animations = {},
		Events = {}
	}
	
	table.insert(self.Elements, element)
	return element
end

-- ═══════════════════════════════════════════════════════════════════
--  CUSTOM ELEMENT - Tamamen Özel Eleman
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:CreateCustomElement(config)
	return self:CreateShape(config)
end

-- ═══════════════════════════════════════════════════════════════════
--  ANIMATION ENGINE - Güçlü Animasyon Sistemi
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:Animate(element, properties, duration, style, direction, repeatCount, reverses, delayTime)
	local instance = type(element) == "table" and element.Instance or element
	duration = duration or 0.3
	style = style or Enum.EasingStyle.Quad
	direction = direction or Enum.EasingDirection.Out
	repeatCount = repeatCount or 0
	reverses = reverses or false
	delayTime = delayTime or 0
	
	local tweenInfo = TweenInfo.new(duration, style, direction, repeatCount, reverses, delayTime)
	local tween = TweenService:Create(instance, tweenInfo, properties)
	tween:Play()
	
	if type(element) == "table" then
		table.insert(element.Animations, tween)
	end
	
	return tween
end

function VortexEngine:AnimateChain(element, animations)
	local instance = type(element) == "table" and element.Instance or element
	local currentIndex = 1
	
	local function playNext()
		if currentIndex > #animations then return end
		local anim = animations[currentIndex]
		local tween = self:Animate(
			instance,
			anim.Properties,
			anim.Duration,
			anim.Style,
			anim.Direction,
			anim.Repeat,
			anim.Reverses,
			anim.Delay
		)
		currentIndex = currentIndex + 1
		tween.Completed:Connect(playNext)
	end
	
	playNext()
end

function VortexEngine:Pulse(element, scale, duration)
	local instance = type(element) == "table" and element.Instance or element
	scale = scale or 1.1
	duration = duration or 0.5
	
	self:Animate(instance, {Size = instance.Size * scale}, duration/2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	task.wait(duration/2)
	self:Animate(instance, {Size = instance.Size / scale}, duration/2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
end

function VortexEngine:PulseLoop(element, scale, duration)
	local instance = type(element) == "table" and element.Instance or element
	scale = scale or 1.1
	duration = duration or 1
	
	local originalSize = instance.Size
	self:Animate(instance, {Size = originalSize * scale}, duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
end

function VortexEngine:Rotate(element, speed)
	local instance = type(element) == "table" and element.Instance or element
	speed = speed or 1
	
	local connection
	connection = RunService.RenderStepped:Connect(function(dt)
		if not instance or not instance.Parent then
			connection:Disconnect()
			return
		end
		instance.Rotation = instance.Rotation + (speed * dt * 60)
	end)
	
	return connection
end

function VortexEngine:Glow(element, intensity, range, color)
	local instance = type(element) == "table" and element.Instance or element
	intensity = intensity or 2
	range = range or 20
	color = color or Color3.fromRGB(255, 255, 255)
	
	local glow = Instance.new("ImageLabel")
	glow.Name = "Glow"
	glow.Size = UDim2.new(1, range*2, 1, range*2)
	glow.Position = UDim2.new(0.5, -range, 0.5, -range)
	glow.AnchorPoint = Vector2.new(0.5, 0.5)
	glow.BackgroundTransparency = 1
	glow.Image = "rbxassetid://6031097225"
	glow.ImageColor3 = color
	glow.ImageTransparency = 1 - (intensity / 10)
	glow.ZIndex = instance.ZIndex - 1
	glow.Parent = instance
	
	return glow
end

function VortexEngine:FadeIn(element, duration)
	local instance = type(element) == "table" and element.Instance or element
	duration = duration or 0.5
	instance.BackgroundTransparency = 1
	self:Animate(instance, {BackgroundTransparency = 0}, duration)
end

function VortexEngine:FadeOut(element, duration)
	local instance = type(element) == "table" and element.Instance or element
	duration = duration or 0.5
	self:Animate(instance, {BackgroundTransparency = 1}, duration)
end

function VortexEngine:Shake(element, intensity, duration)
	local instance = type(element) == "table" and element.Instance or element
	intensity = intensity or 5
	duration = duration or 0.5
	
	local originalPos = instance.Position
	local startTime = tick()
	
	local connection
	connection = RunService.RenderStepped:Connect(function()
		if tick() - startTime >= duration then
			instance.Position = originalPos
			connection:Disconnect()
			return
		end
		
		local offsetX = math.random(-intensity, intensity)
		local offsetY = math.random(-intensity, intensity)
		instance.Position = UDim2.new(
			originalPos.X.Scale, originalPos.X.Offset + offsetX,
			originalPos.Y.Scale, originalPos.Y.Offset + offsetY
		)
	end)
end

-- ═══════════════════════════════════════════════════════════════════
--  INTERACTION SYSTEM - Etkileşim Motoru
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:MakeInteractive(element, config)
	local instance = type(element) == "table" and element.Instance or element
	config = config or {}
	
	if not instance:IsA("GuiButton") then
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(1, 0, 1, 0)
		button.BackgroundTransparency = 1
		button.Text = ""
		button.ZIndex = instance.ZIndex + 1
		button.Parent = instance
		instance = button
	end
	
	if config.HoverEffect then
		instance.MouseEnter:Connect(function()
			if config.HoverEffect.Scale then
				self:Animate(instance.Parent, {Size = instance.Parent.Size * config.HoverEffect.Scale}, 0.2)
			end
			if config.HoverEffect.Color then
				self:Animate(instance.Parent, {BackgroundColor3 = config.HoverEffect.Color}, 0.2)
			end
			if config.HoverEffect.Transparency then
				self:Animate(instance.Parent, {BackgroundTransparency = config.HoverEffect.Transparency}, 0.2)
			end
			if config.OnHover then
				pcall(config.OnHover)
			end
		end)
		
		instance.MouseLeave:Connect(function()
			if config.HoverEffect.Scale then
				self:Animate(instance.Parent, {Size = instance.Parent.Size / config.HoverEffect.Scale}, 0.2)
			end
			if config.HoverEffect.OriginalColor then
				self:Animate(instance.Parent, {BackgroundColor3 = config.HoverEffect.OriginalColor}, 0.2)
			end
			if config.HoverEffect.OriginalTransparency then
				self:Animate(instance.Parent, {BackgroundTransparency = config.HoverEffect.OriginalTransparency}, 0.2)
			end
			if config.OnLeave then
				pcall(config.OnLeave)
			end
		end)
	end
	
	if config.ClickEffect then
		instance.MouseButton1Click:Connect(function()
			if config.ClickEffect.Shake then
				self:Shake(instance.Parent, config.ClickEffect.Shake.Intensity, config.ClickEffect.Shake.Duration)
			end
			if config.ClickEffect.Flash then
				local original = instance.Parent.BackgroundColor3
				self:Animate(instance.Parent, {BackgroundColor3 = config.ClickEffect.Flash}, 0.1)
				task.wait(0.1)
				self:Animate(instance.Parent, {BackgroundColor3 = original}, 0.1)
			end
			if config.ClickEffect.Ripple then
				self:CreateRipple(instance.Parent, config.ClickEffect.Ripple)
			end
			if config.OnClick then
				pcall(config.OnClick)
			end
		end)
	end
	
	return instance
end

function VortexEngine:CreateRipple(element, color)
	local instance = type(element) == "table" and element.Instance or element
	color = color or Color3.fromRGB(255, 255, 255)
	
	local ripple = Instance.new("Frame")
	ripple.Size = UDim2.new(0, 0, 0, 0)
	ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
	ripple.AnchorPoint = Vector2.new(0.5, 0.5)
	ripple.BackgroundColor3 = color
	ripple.BackgroundTransparency = 0.5
	ripple.BorderSizePixel = 0
	ripple.ZIndex = instance.ZIndex + 10
	ripple.Parent = instance
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = ripple
	
	local maxSize = math.max(instance.AbsoluteSize.X, instance.AbsoluteSize.Y) * 2
	
	self:Animate(ripple, {
		Size = UDim2.new(0, maxSize, 0, maxSize),
		BackgroundTransparency = 1
	}, 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	task.delay(0.6, function()
		ripple:Destroy()
	end)
end

function VortexEngine:MakeDraggable(element, handle)
	local instance = type(element) == "table" and element.Instance or element
	handle = handle or instance
	
	local dragging = false
	local dragInput, mousePos, framePos
	
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = input.Position
			framePos = instance.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			instance.Position = UDim2.new(
				framePos.X.Scale,
				framePos.X.Offset + delta.X,
				framePos.Y.Scale,
				framePos.Y.Offset + delta.Y
			)
		end
	end)
end

-- ═══════════════════════════════════════════════════════════════════
--  LAYOUT ENGINE - Otomatik Düzenleme
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:CreateLayout(parent, layoutType, config)
	local instance = type(parent) == "table" and parent.Instance or parent
	config = config or {}
	
	local layout
	
	if layoutType == "List" then
		layout = Instance.new("UIListLayout")
		layout.FillDirection = config.Direction or Enum.FillDirection.Vertical
		layout.HorizontalAlignment = config.HAlign or Enum.HorizontalAlignment.Center
		layout.VerticalAlignment = config.VAlign or Enum.VerticalAlignment.Top
		layout.Padding = config.Padding or UDim.new(0, 5)
		layout.SortOrder = config.SortOrder or Enum.SortOrder.LayoutOrder
	elseif layoutType == "Grid" then
		layout = Instance.new("UIGridLayout")
		layout.CellSize = config.CellSize or UDim2.new(0, 100, 0, 100)
		layout.CellPadding = config.CellPadding or UDim2.new(0, 5, 0, 5)
		layout.FillDirection = config.Direction or Enum.FillDirection.Horizontal
		layout.HorizontalAlignment = config.HAlign or Enum.HorizontalAlignment.Center
		layout.VerticalAlignment = config.VAlign or Enum.VerticalAlignment.Top
		layout.SortOrder = config.SortOrder or Enum.SortOrder.LayoutOrder
	elseif layoutType == "Table" then
		layout = Instance.new("UITableLayout")
		layout.FillDirection = config.Direction or Enum.FillDirection.Horizontal
		layout.Padding = config.Padding or UDim2.new(0, 5, 0, 5)
	elseif layoutType == "Page" then
		layout = Instance.new("UIPageLayout")
		layout.Animated = config.Animated ~= false
		layout.Circular = config.Circular or false
		layout.EasingDirection = config.EasingDirection or Enum.EasingDirection.Out
		layout.EasingStyle = config.EasingStyle or Enum.EasingStyle.Quad
		layout.TweenTime = config.TweenTime or 0.5
	end
	
	if layout then
		layout.Parent = instance
	end
	
	return layout
end

function VortexEngine:CreatePadding(parent, config)
	local instance = type(parent) == "table" and parent.Instance or parent
	config = config or {}
	
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = config.Top or UDim.new(0, 0)
	padding.PaddingBottom = config.Bottom or UDim.new(0, 0)
	padding.PaddingLeft = config.Left or UDim.new(0, 0)
	padding.PaddingRight = config.Right or UDim.new(0, 0)
	padding.Parent = instance
	
	return padding
end

function VortexEngine:CreateAspectRatio(parent, ratio)
	local instance = type(parent) == "table" and parent.Instance or parent
	
	local aspect = Instance.new("UIAspectRatioConstraint")
	aspect.AspectRatio = ratio or 1
	aspect.Parent = instance
	
	return aspect
end

-- ═══════════════════════════════════════════════════════════════════
--  PARTICLE SYSTEM - Parçacık Efektleri
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:CreateParticles(parent, config)
	local instance = type(parent) == "table" and parent.Instance or parent
	config = config or {}
	
	local count = config.Count or 20
	local minSize = config.MinSize or 2
	local maxSize = config.MaxSize or 5
	local color = config.Color or Color3.fromRGB(255, 255, 255)
	local speed = config.Speed or 1
	local lifetime = config.Lifetime or 5
	
	for i = 1, count do
		local particle = Instance.new("Frame")
		particle.Size = UDim2.new(0, math.random(minSize, maxSize), 0, math.random(minSize, maxSize))
		particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
		particle.BackgroundColor3 = color
		particle.BackgroundTransparency = math.random(30, 70) / 100
		particle.BorderSizePixel = 0
		particle.Parent = instance
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = particle
		
		task.spawn(function()
			while particle and particle.Parent do
				local duration = math.random(20, 40) / (10 * speed)
				self:Animate(particle, {
					Position = UDim2.new(math.random(), 0, math.random(), 0),
					BackgroundTransparency = math.random(30, 90) / 100
				}, duration, Enum.EasingStyle.Linear)
				task.wait(duration)
			end
		end)
		
		if lifetime > 0 then
			task.delay(lifetime, function()
				if particle then particle:Destroy() end
			end)
		end
	end
end

-- ═══════════════════════════════════════════════════════════════════
--  SPRITE ANIMATION - GIF Benzeri Animasyon
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:CreateSpriteAnimation(parent, config)
	local instance = type(parent) == "table" and parent.Instance or parent
	config = config or {}
	
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = config.Size or UDim2.new(1, 0, 1, 0)
	imageLabel.Position = config.Position or UDim2.new(0, 0, 0, 0)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Parent = instance
	
	local frames = config.Frames or {}
	local fps = config.FPS or 10
	local loop = config.Loop ~= false
	local currentFrame = 1
	
	local function animate()
		while true do
			if currentFrame > #frames then
				if not loop then break end
				currentFrame = 1
			end
			
			imageLabel.Image = frames[currentFrame]
			currentFrame = currentFrame + 1
			task.wait(1 / fps)
		end
	end
	
	task.spawn(animate)
	
	return imageLabel
end

-- ═══════════════════════════════════════════════════════════════════
--  COMPONENT LIBRARY - Hazır Bileşenler
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:Button(config)
	config = config or {}
	
	local button = self:CreateShape({
		Type = "TextButton",
		Name = config.Name or "Button",
		Size = config.Size or UDim2.new(0, 150, 0, 40),
		Position = config.Position or UDim2.new(0, 0, 0, 0),
		Color = config.Color or Color3.fromRGB(60, 60, 60),
		Text = config.Text or "Button",
		TextColor = config.TextColor or Color3.fromRGB(255, 255, 255),
		TextSize = config.TextSize or 14,
		Font = config.Font or Enum.Font.GothamBold,
		Corner = config.Corner or {Scale = 0, Offset = 8},
		Stroke = config.Stroke,
		Gradient = config.Gradient,
		Parent = config.Parent or self.ScreenGui
	})
	
	self:MakeInteractive(button, {
		HoverEffect = {
			Scale = 1.05,
			Color = config.HoverColor or Color3.fromRGB(80, 80, 80),
			OriginalColor = config.Color or Color3.fromRGB(60, 60, 60)
		},
		ClickEffect = {
			Flash = config.ClickColor or Color3.fromRGB(120, 120, 120),
			Ripple = config.RippleColor or Color3.fromRGB(255, 255, 255)
		},
		OnClick = config.OnClick
	})
	
	return button
end

function VortexEngine:Toggle(config)
	config = config or {}
	
	local container = self:CreateShape({
		Type = "Frame",
		Name = config.Name or "Toggle",
		Size = config.Size or UDim2.new(0, 200, 0, 40),
		Position = config.Position or UDim2.new(0, 0, 0, 0),
		Color = config.BackgroundColor or Color3.fromRGB(40, 40, 40),
		Corner = {Scale = 0, Offset = 8},
		Parent = config.Parent or self.ScreenGui
	})
	
	local label = self:CreateShape({
		Type = "TextLabel",
		Size = UDim2.new(1, -60, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		Color = Color3.fromRGB(40, 40, 40),
		Transparency = 1,
		Text = config.Text or "Toggle",
		TextColor = config.TextColor or Color3.fromRGB(255, 255, 255),
		TextSize = config.TextSize or 13,
		TextXAlign = Enum.TextXAlignment.Left,
		Parent = container.Instance
	})
	
	local track = self:CreateShape({
		Type = "Frame",
		Size = UDim2.new(0, 40, 0, 20),
		Position = UDim2.new(1, -45, 0.5, -10),
		Color = config.OffColor or Color3.fromRGB(60, 60, 60),
		Corner = {Scale = 1, Offset = 0},
		Parent = container.Instance
	})
	
	local knob = self:CreateShape({
		Type = "Frame",
		Size = UDim2.new(0, 16, 0, 16),
		Position = UDim2.new(0, 2, 0.5, -8),
		Color = Color3.fromRGB(255, 255, 255),
		Corner = {Scale = 1, Offset = 0},
		Parent = track.Instance
	})
	
	local toggled = config.Default or false
	
	if toggled then
		track.Instance.BackgroundColor3 = config.OnColor or Color3.fromRGB(100, 200, 100)
		knob.Instance.Position = UDim2.new(1, -18, 0.5, -8)
	end
	
	local toggleObj = {
		Container = container,
		Value = toggled,
		OnChange = config.OnChange
	}
	
	function toggleObj:Set(value)
		self.Value = value
		if value then
			VortexEngine:Animate(track.Instance, {BackgroundColor3 = config.OnColor or Color3.fromRGB(100, 200, 100)}, 0.2)
			VortexEngine:Animate(knob.Instance, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
		else
			VortexEngine:Animate(track.Instance, {BackgroundColor3 = config.OffColor or Color3.fromRGB(60, 60, 60)}, 0.2)
			VortexEngine:Animate(knob.Instance, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
		end
		if self.OnChange then
			pcall(function() self.OnChange(value) end)
		end
	end
	
	self:MakeInteractive(container, {
		OnClick = function()
			toggleObj:Set(not toggleObj.Value)
		end
	})
	
	return toggleObj
end

function VortexEngine:Slider(config)
	config = config or {}
	
	local container = self:CreateShape({
		Type = "Frame",
		Name = config.Name or "Slider",
		Size = config.Size or UDim2.new(0, 250, 0, 50),
		Position = config.Position or UDim2.new(0, 0, 0, 0),
		Color = config.BackgroundColor or Color3.fromRGB(40, 40, 40),
		Corner = {Scale = 0, Offset = 8},
		Parent = config.Parent or self.ScreenGui
	})
	
	local label = self:CreateShape({
		Type = "TextLabel",
		Size = UDim2.new(0.7, 0, 0, 18),
		Position = UDim2.new(0, 10, 0, 6),
		Color = Color3.fromRGB(40, 40, 40),
		Transparency = 1,
		Text = config.Text or "Slider",
		TextColor = config.TextColor or Color3.fromRGB(255, 255, 255),
		TextSize = 12,
		TextXAlign = Enum.TextXAlignment.Left,
		Parent = container.Instance
	})
	
	local min = config.Min or 0
	local max = config.Max or 100
	local value = config.Default or min
	
	local valueLabel = self:CreateShape({
		Type = "TextLabel",
		Size = UDim2.new(0.3, -10, 0, 18),
		Position = UDim2.new(0.7, 0, 0, 6),
		Color = Color3.fromRGB(40, 40, 40),
		Transparency = 1,
		Text = tostring(value),
		TextColor = config.AccentColor or Color3.fromRGB(100, 200, 255),
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		TextXAlign = Enum.TextXAlignment.Right,
		Parent = container.Instance
	})
	
	local trackBg = self:CreateShape({
		Type = "Frame",
		Size = UDim2.new(1, -20, 0, 6),
		Position = UDim2.new(0, 10, 1, -14),
		Color = Color3.fromRGB(30, 30, 30),
		Corner = {Scale = 1, Offset = 0},
		Parent = container.Instance
	})
	
	local fill = self:CreateShape({
		Type = "Frame",
		Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
		Color = config.AccentColor or Color3.fromRGB(100, 200, 255),
		Corner = {Scale = 1, Offset = 0},
		Parent = trackBg.Instance
	})
	
	local knob = self:CreateShape({
		Type = "Frame",
		Size = UDim2.new(0, 12, 0, 12),
		Position = UDim2.new((value - min) / (max - min), -6, 0.5, -6),
		Color = Color3.fromRGB(255, 255, 255),
		Corner = {Scale = 1, Offset = 0},
		Parent = trackBg.Instance
	})
	
	local dragging = false
	
	local sliderObj = {
		Container = container,
		Value = value,
		OnChange = config.OnChange
	}
	
	function sliderObj:Set(val)
		val = math.clamp(val, min, max)
		self.Value = val
		valueLabel.Instance.Text = tostring(math.floor(val))
		local relative = (val - min) / (max - min)
		fill.Instance.Size = UDim2.new(relative, 0, 1, 0)
		knob.Instance.Position = UDim2.new(relative, -6, 0.5, -6)
		if self.OnChange then
			pcall(function() self.OnChange(val) end)
		end
	end
	
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 1, 0)
	button.BackgroundTransparency = 1
	button.Text = ""
	button.Parent = container.Instance
	
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
			local trackPos = trackBg.Instance.AbsolutePosition.X
			local trackSize = trackBg.Instance.AbsoluteSize.X
			local relative = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
			local newValue = min + (relative * (max - min))
			sliderObj:Set(newValue)
		end
	end)
	
	return sliderObj
end

function VortexEngine:Input(config)
	config = config or {}
	
	local container = self:CreateShape({
		Type = "Frame",
		Name = config.Name or "Input",
		Size = config.Size or UDim2.new(0, 250, 0, 40),
		Position = config.Position or UDim2.new(0, 0, 0, 0),
		Color = config.BackgroundColor or Color3.fromRGB(40, 40, 40),
		Corner = {Scale = 0, Offset = 8},
		Parent = config.Parent or self.ScreenGui
	})
	
	local textBox = self:CreateShape({
		Type = "TextBox",
		Size = UDim2.new(1, -20, 1, -10),
		Position = UDim2.new(0, 10, 0, 5),
		Color = Color3.fromRGB(40, 40, 40),
		Transparency = 1,
		Text = config.Default or "",
		TextColor = config.TextColor or Color3.fromRGB(255, 255, 255),
		TextSize = config.TextSize or 13,
		TextXAlign = Enum.TextXAlignment.Left,
		Parent = container.Instance
	})
	
	textBox.Instance.PlaceholderText = config.Placeholder or "Enter text..."
	textBox.Instance.PlaceholderColor3 = config.PlaceholderColor or Color3.fromRGB(150, 150, 150)
	textBox.Instance.ClearTextOnFocus = config.ClearOnFocus or false
	
	if config.OnChange then
		textBox.Instance:GetPropertyChangedSignal("Text"):Connect(function()
			pcall(function() config.OnChange(textBox.Instance.Text) end)
		end)
	end
	
	if config.OnSubmit then
		textBox.Instance.FocusLost:Connect(function(enterPressed)
			if enterPressed then
				pcall(function() config.OnSubmit(textBox.Instance.Text) end)
			end
		end)
	end
	
	return {Container = container, TextBox = textBox}
end

function VortexEngine:Image(config)
	config = config or {}
	
	local image = self:CreateShape({
		Type = "ImageLabel",
		Name = config.Name or "Image",
		Size = config.Size or UDim2.new(0, 100, 0, 100),
		Position = config.Position or UDim2.new(0, 0, 0, 0),
		Color = config.Color or Color3.fromRGB(255, 255, 255),
		Transparency = config.Transparency or 0,
		Image = config.Image or "",
		ImageColor = config.ImageColor,
		ImageTransparency = config.ImageTransparency,
		ScaleType = config.ScaleType,
		Corner = config.Corner,
		Parent = config.Parent or self.ScreenGui
	})
	
	return image
end

-- ═══════════════════════════════════════════════════════════════════
--  ADVANCED SHAPES - Özel Şekiller
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:Circle(config)
	config = config or {}
	config.Corner = {Scale = 1, Offset = 0}
	return self:CreateShape(config)
end

function VortexEngine:Ring(config)
	config = config or {}
	
	local outer = self:Circle({
		Size = config.Size or UDim2.new(0, 100, 0, 100),
		Position = config.Position or UDim2.new(0, 0, 0, 0),
		Color = config.Color or Color3.fromRGB(255, 255, 255),
		Transparency = config.Transparency or 0,
		Parent = config.Parent or self.ScreenGui
	})
	
	local thickness = config.Thickness or 10
	local innerSize = outer.Instance.AbsoluteSize.X - (thickness * 2)
	
	local inner = self:Circle({
		Size = UDim2.new(0, innerSize, 0, innerSize),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Color = config.InnerColor or Color3.fromRGB(0, 0, 0),
		Transparency = config.InnerTransparency or 0,
		Parent = outer.Instance
	})
	
	return {Outer = outer, Inner = inner}
end

function VortexEngine:Triangle(config)
	config = config or {}
	
	local container = self:CreateShape({
		Type = "Frame",
		Size = config.Size or UDim2.new(0, 100, 0, 100),
		Position = config.Position or UDim2.new(0, 0, 0, 0),
		Transparency = 1,
		Parent = config.Parent or self.ScreenGui
	})
	
	local image = self:CreateShape({
		Type = "ImageLabel",
		Size = UDim2.new(1, 0, 1, 0),
		Image = "rbxassetid://6977053839",
		ImageColor = config.Color or Color3.fromRGB(255, 255, 255),
		ImageTransparency = config.Transparency or 0,
		Rotation = config.Rotation or 0,
		Parent = container.Instance
	})
	
	return container
end

function VortexEngine:Polygon(config)
	config = config or {}
	
	local sides = config.Sides or 6
	local radius = config.Radius or 50
	local center = config.Position or UDim2.new(0, 100, 0, 100)
	local color = config.Color or Color3.fromRGB(255, 255, 255)
	local parent = config.Parent or self.ScreenGui
	
	local container = self:CreateShape({
		Type = "Frame",
		Size = UDim2.new(0, radius * 2, 0, radius * 2),
		Position = center,
		Transparency = 1,
		Parent = parent
	})
	
	for i = 1, sides do
		local angle = (i / sides) * math.pi * 2
		local x = math.cos(angle) * radius
		local y = math.sin(angle) * radius
		
		local point = self:CreateShape({
			Type = "Frame",
			Size = UDim2.new(0, 8, 0, 8),
			Position = UDim2.new(0.5, x - 4, 0.5, y - 4),
			Color = color,
			Corner = {Scale = 1, Offset = 0},
			Parent = container.Instance
		})
	end
	
	return container
end

function VortexEngine:Star(config)
	config = config or {}
	
	local container = self:CreateShape({
		Type = "Frame",
		Size = config.Size or UDim2.new(0, 100, 0, 100),
		Position = config.Position or UDim2.new(0, 0, 0, 0),
		Transparency = 1,
		Parent = config.Parent or self.ScreenGui
	})
	
	local image = self:CreateShape({
		Type = "ImageLabel",
		Size = UDim2.new(1, 0, 1, 0),
		Image = "rbxassetid://6031097225",
		ImageColor = config.Color or Color3.fromRGB(255, 255, 0),
		ImageTransparency = config.Transparency or 0,
		Parent = container.Instance
	})
	
	return container
end

-- ═══════════════════════════════════════════════════════════════════
--  DRAWING SYSTEM - Serbest Çizim
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:DrawLine(from, to, config)
	config = config or {}
	
	local distance = (to - from).Magnitude
	local midpoint = (from + to) / 2
	local angle = math.deg(math.atan2(to.Y - from.Y, to.X - from.X))
	
	local line = self:CreateShape({
		Type = "Frame",
		Size = UDim2.new(0, distance, 0, config.Thickness or 2),
		Position = UDim2.new(0, midpoint.X, 0, midpoint.Y),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Color = config.Color or Color3.fromRGB(255, 255, 255),
		Rotation = angle,
		Parent = config.Parent or self.ScreenGui
	})
	
	return line
end

function VortexEngine:DrawPath(points, config)
	config = config or {}
	local lines = {}
	
	for i = 1, #points - 1 do
		local line = self:DrawLine(points[i], points[i + 1], config)
		table.insert(lines, line)
	end
	
	if config.ClosePath then
		local line = self:DrawLine(points[#points], points[1], config)
		table.insert(lines, line)
	end
	
	return lines
end

function VortexEngine:DrawGrid(config)
	config = config or {}
	
	local container = self:CreateShape({
		Type = "Frame",
		Size = config.Size or UDim2.new(1, 0, 1, 0),
		Position = config.Position or UDim2.new(0, 0, 0, 0),
		Transparency = 1,
		Parent = config.Parent or self.ScreenGui
	})
	
	local cellSize = config.CellSize or 50
	local color = config.Color or Color3.fromRGB(100, 100, 100)
	local thickness = config.Thickness or 1
	
	local width = container.Instance.AbsoluteSize.X
	local height = container.Instance.AbsoluteSize.Y
	
	for x = 0, width, cellSize do
		self:CreateShape({
			Type = "Frame",
			Size = UDim2.new(0, thickness, 1, 0),
			Position = UDim2.new(0, x, 0, 0),
			Color = color,
			Parent = container.Instance
		})
	end
	
	for y = 0, height, cellSize do
		self:CreateShape({
			Type = "Frame",
			Size = UDim2.new(1, 0, 0, thickness),
			Position = UDim2.new(0, 0, 0, y),
			Color = color,
			Parent = container.Instance
		})
	end
	
	return container
end

-- ═══════════════════════════════════════════════════════════════════
--  3D DEPTH SYSTEM - Derinlik İllüzyonu
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:Create3DLayer(config)
	config = config or {}
	
	local layers = {}
	local depth = config.Depth or 5
	
	for i = 1, depth do
		local scale = 1 - (i * 0.05)
		local transparency = (i - 1) * 0.15
		
		local layer = self:CreateShape({
			Type = config.Type or "Frame",
			Size = (config.Size or UDim2.new(0, 200, 0, 200)) * scale,
			Position = config.Position or UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Color = config.Color or Color3.fromRGB(100, 100, 255),
			Transparency = transparency,
			ZIndex = depth - i,
			Corner = config.Corner,
			Parent = config.Parent or self.ScreenGui
		})
		
		table.insert(layers, layer)
	end
	
	return layers
end

function VortexEngine:CreateParallax(elements, intensity)
	intensity = intensity or 0.1
	
	local mouse = Players.LocalPlayer:GetMouse()
	
	RunService.RenderStepped:Connect(function()
		local mouseX = mouse.X
		local mouseY = mouse.Y
		local screenX = workspace.CurrentCamera.ViewportSize.X / 2
		local screenY = workspace.CurrentCamera.ViewportSize.Y / 2
		
		local offsetX = (mouseX - screenX) * intensity
		local offsetY = (mouseY - screenY) * intensity
		
		for i, element in ipairs(elements) do
			local instance = type(element) == "table" and element.Instance or element
			local depth = i * 0.2
			
			self:Animate(instance, {
				Position = UDim2.new(
					instance.Position.X.Scale,
					instance.Position.X.Offset + (offsetX * depth),
					instance.Position.Y.Scale,
					instance.Position.Y.Offset + (offsetY * depth)
				)
			}, 0.1, Enum.EasingStyle.Linear)
		end
	end)
end

-- ═══════════════════════════════════════════════════════════════════
--  UTILITY FUNCTIONS - Yardımcı Fonksiyonlar
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:Clone(element)
	local instance = type(element) == "table" and element.Instance or element
	local clone = instance:Clone()
	clone.Parent = instance.Parent
	return {Instance = clone, Config = element.Config or {}}
end

function VortexEngine:Destroy(element)
	local instance = type(element) == "table" and element.Instance or element
	if instance then
		instance:Destroy()
	end
end

function VortexEngine:Hide(element, animated)
	local instance = type(element) == "table" and element.Instance or element
	if animated then
		self:FadeOut(instance, 0.3)
		task.wait(0.3)
	end
	instance.Visible = false
end

function VortexEngine:Show(element, animated)
	local instance = type(element) == "table" and element.Instance or element
	instance.Visible = true
	if animated then
		self:FadeIn(instance, 0.3)
	end
end

function VortexEngine:SetZIndex(element, zIndex)
	local instance = type(element) == "table" and element.Instance or element
	instance.ZIndex = zIndex
	for _, child in ipairs(instance:GetDescendants()) do
		if child:IsA("GuiObject") then
			child.ZIndex = zIndex
		end
	end
end

function VortexEngine:GetCenter(element)
	local instance = type(element) == "table" and element.Instance or element
	local pos = instance.AbsolutePosition
	local size = instance.AbsoluteSize
	return Vector2.new(pos.X + size.X / 2, pos.Y + size.Y / 2)
end

function VortexEngine:GetDistance(element1, element2)
	local center1 = self:GetCenter(element1)
	local center2 = self:GetCenter(element2)
	return (center2 - center1).Magnitude
end

function VortexEngine:IsOverlapping(element1, element2)
	local inst1 = type(element1) == "table" and element1.Instance or element1
	local inst2 = type(element2) == "table" and element2.Instance or element2
	
	local pos1 = inst1.AbsolutePosition
	local size1 = inst1.AbsoluteSize
	local pos2 = inst2.AbsolutePosition
	local size2 = inst2.AbsoluteSize
	
	return not (pos1.X + size1.X < pos2.X or pos2.X + size2.X < pos1.X or
	            pos1.Y + size1.Y < pos2.Y or pos2.Y + size2.Y < pos1.Y)
end

-- ═══════════════════════════════════════════════════════════════════
--  NOTIFICATION SYSTEM - Bildirim Sistemi
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:Notify(config)
	config = config or {}
	
	local notification = self:CreateShape({
		Type = "Frame",
		Size = UDim2.new(0, 300, 0, 80),
		Position = UDim2.new(1, 10, 1, -90),
		Color = config.BackgroundColor or Color3.fromRGB(30, 30, 30),
		Corner = {Scale = 0, Offset = 10},
		Stroke = {
			Color = config.AccentColor or Color3.fromRGB(100, 200, 255),
			Thickness = 2
		},
		Parent = self.ScreenGui
	})
	
	local title = self:CreateShape({
		Type = "TextLabel",
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 10, 0, 10),
		Transparency = 1,
		Text = config.Title or "Notification",
		TextColor = Color3.fromRGB(255, 255, 255),
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		TextXAlign = Enum.TextXAlignment.Left,
		Parent = notification.Instance
	})
	
	local message = self:CreateShape({
		Type = "TextLabel",
		Size = UDim2.new(1, -20, 0, 30),
		Position = UDim2.new(0, 10, 0, 35),
		Transparency = 1,
		Text = config.Message or "",
		TextColor = Color3.fromRGB(200, 200, 200),
		TextSize = 12,
		TextXAlign = Enum.TextXAlignment.Left,
		TextYAlign = Enum.TextYAlignment.Top,
		TextWrap = true,
		Parent = notification.Instance
	})
	
	self:Animate(notification.Instance, {Position = UDim2.new(1, -310, 1, -90)}, 0.3, Enum.EasingStyle.Back)
	
	local duration = config.Duration or 3
	task.delay(duration, function()
		self:Animate(notification.Instance, {Position = UDim2.new(1, 10, 1, -90)}, 0.3, Enum.EasingStyle.Back)
		task.wait(0.3)
		notification.Instance:Destroy()
	end)
	
	return notification
end

-- ═══════════════════════════════════════════════════════════════════
--  CLEANUP - Temizlik
-- ═══════════════════════════════════════════════════════════════════

function VortexEngine:DestroyAll()
	if self.ScreenGui then
		self.ScreenGui:Destroy()
	end
	self.Elements = {}
	self.Animations = {}
end

_G.VortexEngine = VortexEngine
return VortexEngine
