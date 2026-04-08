--[[
    VortexLib — Standalone Reusable Roblox GUI Library
    ────────────────────────────────────────────────────
    Quick-start:
        local VortexLib = loadstring(game:HttpGet("YOUR_RAW_URL"))()

        local win = VortexLib:CreateWindow({
            Title      = "My Script",
            Subtitle   = "v1.0",
            ToggleKey  = Enum.KeyCode.RightControl,
        })

        local tab = win:AddTab("Farm")
        tab:Header("Auto Farm", "Configure the farming loop.")
        tab:Section("SETTINGS")
        tab:Toggle("Enable Farm", false, function(v) print("farm", v) end)
        tab:Slider("Speed", {Min=16, Max=200, Default=16}, function(v) print("speed", v) end)
        tab:Button("Collect Now", function() print("collected") end)
        tab:Input("Item Name", "e.g. Apple", function(v) print("item", v) end)
        tab:Label("Status: Idle")
]]

-- ────────────────────────────────────────────────────────────────────────────
local VortexLib  = {}
VortexLib.__index = VortexLib

-- Services
local TS   = game:GetService("TweenService")
local UIS  = game:GetService("UserInputService")
local RS   = game:GetService("RunService")
local Players = game:GetService("Players")
local player  = Players.LocalPlayer

-- ── Default theme ────────────────────────────────────────────────────────────
VortexLib.DefaultTheme = {
    BG          = Color3.fromRGB(10,  10,  15),
    BGCard      = Color3.fromRGB(16,  16,  26),
    Accent      = Color3.fromRGB(139, 92,  246),
    Neon        = Color3.fromRGB(52,  211, 153),
    Blue        = Color3.fromRGB(96,  165, 250),
    BlueDeep    = Color3.fromRGB(59,  130, 246),
    GlassStroke = Color3.fromRGB(160, 150, 230),
    Text        = Color3.fromRGB(248, 250, 252),
    TextMuted   = Color3.fromRGB(148, 163, 184),
    Divider     = Color3.fromRGB(55,  55,  85),
}

-- ── Internal helpers ─────────────────────────────────────────────────────────
local function corner(r, p)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = p
    return c
end

local function uistroke(color, thick, trans, p)
    local s = Instance.new("UIStroke")
    s.Color = color; s.Thickness = thick; s.Transparency = trans
    s.Parent = p
    return s
end

local function newFrame(parent, size, pos, color, trans, zi)
    local f = Instance.new("Frame")
    f.Size = size or UDim2.new(1,0,1,0)
    if pos   then f.Position = pos end
    if color then f.BackgroundColor3 = color end
    f.BackgroundTransparency = trans or 1
    f.BorderSizePixel = 0
    if zi then f.ZIndex = zi end
    f.Parent = parent
    return f
end

local function newText(class, parent, text, size, color, font, xa, ya)
    local l = Instance.new(class)
    l.BackgroundTransparency = 1
    l.Text = text or ""
    l.TextSize = size or 14
    l.TextColor3 = color
    l.Font = font or Enum.Font.GothamMedium
    l.TextXAlignment = xa or Enum.TextXAlignment.Left
    if ya then l.TextYAlignment = ya end
    l.Parent = parent
    return l
end

local function easeTween(obj, t, props)
    TS:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quad), props):Play()
end

-- ── CreateWindow ─────────────────────────────────────────────────────────────
function VortexLib:CreateWindow(opts)
    opts = opts or {}
    local C         = opts.Theme or self.DefaultTheme
    local title     = opts.Title or "VortexLib"
    local subtitle  = opts.Subtitle or ""
    local toggleKey = opts.ToggleKey or Enum.KeyCode.RightControl
    local W, H      = opts.Width or 688, opts.Height or 460
    local COL_SIDE   = opts.SidebarWidth or 76
    local COL_VORTEX  = opts.VortexPanel and 312 or 0

    -- ── ScreenGui ──────────────────────────────────────────────────
    local sg = Instance.new("ScreenGui")
    sg.Name           = opts.GuiName or ("VL_"..title)
    sg.ResetOnSpawn   = false
    sg.DisplayOrder   = opts.DisplayOrder or 50
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.IgnoreGuiInset = true
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(sg) end
        sg.Parent = game:GetService("CoreGui")
    end)
    if not sg.Parent then sg.Parent = player.PlayerGui end

    -- Cursor overlay (full-screen, above everything)
    local cursorOverlay = newFrame(sg)
    cursorOverlay.ZIndex = 500; cursorOverlay.Active = false
    cursorOverlay.Selectable = false; cursorOverlay.ClipsDescendants = false
    pcall(function() cursorOverlay.Interactable = false end)

    -- ── Main frame ─────────────────────────────────────────────────
    local main = newFrame(sg,
        UDim2.fromOffset(W, H),
        UDim2.new(0.5, -W/2, 0.5, -H/2),
        C.BG, 0.2, 2)
    main.ClipsDescendants = true
    corner(16, main)
    uistroke(C.GlassStroke, 1, 0.55, main)

    local glassGrad = Instance.new("UIGradient")
    glassGrad.Rotation = 128
    glassGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.86),
        NumberSequenceKeypoint.new(0.45, 0.93),
        NumberSequenceKeypoint.new(1, 0.88),
    })
    glassGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.Accent),
        ColorSequenceKeypoint.new(0.5, C.BG),
        ColorSequenceKeypoint.new(1, C.Blue or C.Accent),
    })
    glassGrad.Parent = main

    -- ── Drag ───────────────────────────────────────────────────────
    do
        local drag, dragStart, startPos
        main.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                drag = true; dragStart = inp.Position; startPos = main.Position
            end
        end)
        UIS.InputChanged:Connect(function(inp)
            if drag and inp.UserInputType == Enum.UserInputType.MouseMovement then
                local d = inp.Position - dragStart
                main.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
        UIS.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
        end)
    end

    -- ── TopBar ─────────────────────────────────────────────────────
    local topbar = newFrame(main, UDim2.new(1,0,0,48), UDim2.new(0,0,0,0), C.BGCard, 0.25, 10)
    corner(16, topbar)

    local logoLbl = newText("TextLabel", topbar, title, 14, C.Text, Enum.Font.GothamBold)
    logoLbl.Size = UDim2.new(0, 200, 0, 30)
    logoLbl.Position = UDim2.new(0, 14, 0.5, -15)
    logoLbl.ZIndex = 11

    if subtitle ~= "" then
        local subLbl = newText("TextLabel", topbar, subtitle, 11, C.TextMuted)
        subLbl.Size = UDim2.new(0, 120, 0, 14)
        subLbl.Position = UDim2.new(0, 14 + logoLbl.TextBounds.X + 8, 0.5, -7)
        subLbl.ZIndex = 11
    end

    local function makeHeaderBtn(txt, color, xOff)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 32, 0, 32)
        b.Position = UDim2.new(1, xOff, 0.5, -16)
        b.BackgroundColor3 = C.BG; b.BackgroundTransparency = 0.4
        b.Text = txt; b.TextColor3 = color; b.TextSize = 18
        b.Font = Enum.Font.GothamMedium; b.AutoButtonColor = false
        b.BorderSizePixel = 0; b.ZIndex = 11
        corner(8, b); b.Parent = topbar
        b.MouseEnter:Connect(function() easeTween(b, 0.1, {BackgroundTransparency=0.1}) end)
        b.MouseLeave:Connect(function() easeTween(b, 0.1, {BackgroundTransparency=0.4}) end)
        return b
    end
    local closeBtn = makeHeaderBtn("×", Color3.fromRGB(248,113,113), -40)
    local minBtn   = makeHeaderBtn("−", C.Neon, -78)

    -- ── Body ───────────────────────────────────────────────────────
    local body = newFrame(main, UDim2.new(1,-24,1,-60), UDim2.new(0,12,0,52), C.BG, 1, 3)

    -- ── InnerCard ──────────────────────────────────────────────────
    local inner = newFrame(body, UDim2.new(1,0,1,0), nil, C.BGCard, 0.35, 4)
    corner(14, inner)
    local innerStroke = uistroke(C.GlassStroke, 1, 0.72, inner)

    -- ── Sidebar ────────────────────────────────────────────────────
    local sidebar = newFrame(inner, UDim2.new(0, COL_SIDE, 1, 0), nil, nil, 1, 5)
    do
        local sl = Instance.new("UIListLayout")
        sl.FillDirection = Enum.FillDirection.Vertical
        sl.HorizontalAlignment = Enum.HorizontalAlignment.Center
        sl.VerticalAlignment = Enum.VerticalAlignment.Top
        sl.Padding = UDim.new(0, 5)
        sl.SortOrder = Enum.SortOrder.LayoutOrder
        sl.Parent = sidebar
        local sp = Instance.new("UIPadding"); sp.PaddingTop = UDim.new(0,10); sp.Parent = sidebar
    end

    -- Sidebar divider
    local sdiv = newFrame(inner, UDim2.new(0,1,1,0), UDim2.new(0, COL_SIDE, 0,0), C.Divider, 0.4, 5)

    -- ── Vortex decoration panel (optional) ────────────────────────
    local vortexDots, vortexRings, vortexCore, vortexPanel = {}, {}, nil, nil
    local function lerpC3(a,b,t) return Color3.new(a.R+(b.R-a.R)*t,a.G+(b.G-a.G)*t,a.B+(b.B-a.B)*t) end
    if COL_VORTEX > 0 then
        vortexPanel = newFrame(inner, UDim2.new(0,COL_VORTEX,1,0), UDim2.new(0,COL_SIDE,0,0), Color3.fromRGB(6,8,18), 0.35, 5)
        vortexPanel.ClipsDescendants = true
        local vg = Instance.new("UIGradient"); vg.Rotation = 92
        vg.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,C.Blue),ColorSequenceKeypoint.new(0.35,C.BG),ColorSequenceKeypoint.new(0.65,C.Accent),ColorSequenceKeypoint.new(1,C.Blue)})
        vg.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.55),NumberSequenceKeypoint.new(0.5,0.78),NumberSequenceKeypoint.new(1,0.6)})
        vg.Parent = vortexPanel
        local vvig = newFrame(vortexPanel, nil, nil, C.BG, 0.15, 4)
        local vigG = Instance.new("UIGradient"); vigG.Color = ColorSequence.new(Color3.new(1,1,1))
        vigG.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.88),NumberSequenceKeypoint.new(0.45,0.96),NumberSequenceKeypoint.new(1,0.82)}); vigG.Parent = vvig
        newFrame(inner, UDim2.new(0,1,1,0), UDim2.new(0,COL_SIDE+COL_VORTEX,0,0), C.Divider, 0.4, 5)
        local function addRing(sz,tr,sT,z)
            local f = newFrame(vortexPanel, UDim2.fromOffset(sz,sz), nil, C.Accent, tr, z)
            f.AnchorPoint = Vector2.new(0.5,0.5); f.Position = UDim2.new(0.5,0,0.5,0)
            corner(math.floor(sz/2), f)
            if sT < 1 then uistroke(C.Blue, 2, sT, f) end
            table.insert(vortexRings, f); return f
        end
        addRing(118,0.94,0.55,9); addRing(78,0.88,0.45,10); vortexCore = addRing(48,0.55,0.25,11)
        local hot = newFrame(vortexPanel, UDim2.fromOffset(16,16), nil, C.Text, 0.2, 12)
        hot.AnchorPoint = Vector2.new(0.5,0.5); hot.Position = UDim2.new(0.5,0,0.5,0); corner(8, hot)
        table.insert(vortexRings, hot)
        local ARMS, PTS, LAYERS = 6, 46, 2; local di = 0
        for layer = 1, LAYERS do
            local ls = (layer==1) and 1 or -0.72; local lsc = (layer==1) and 1 or 0.78
            for arm = 0, ARMS-1 do
                for j = 1, PTS do
                    di = di+1; local d = newFrame(vortexPanel)
                    local u = j/PTS; local sz2 = math.floor(2.5+u*u*5.5)
                    if layer==2 then sz2 = math.max(2,sz2-1) end
                    d.Size = UDim2.fromOffset(sz2,sz2); d.AnchorPoint = Vector2.new(0.5,0.5)
                    d.ZIndex = layer==1 and 7 or 6; corner(math.ceil(sz2/2), d)
                    local g = Instance.new("UIGradient"); g.Rotation = 40
                    g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,C.Accent),ColorSequenceKeypoint.new(0.5,C.Blue),ColorSequenceKeypoint.new(1,C.Neon)})
                    g.Parent = d
                    vortexDots[di] = {frame=d,arm=arm,j=j,jMax=PTS,layer=layer,layerSpin=ls,layerScale=lsc}
                end
            end
        end
    end

    -- ── Right panel ────────────────────────────────────────────────
    local rightPanel = newFrame(inner,
        UDim2.new(1, -(COL_SIDE+COL_VORTEX), 1, 0),
        UDim2.new(0, COL_SIDE+COL_VORTEX, 0, 0),
        nil, 1, 5)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,-16,1,-12)
    scroll.Position = UDim2.new(0,8,0,6)
    scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3; scroll.ScrollBarImageColor3 = C.Accent
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.ZIndex = 6; scroll.Parent = rightPanel

    -- ── Glass strength helper ──────────────────────────────────────
    local mainStroke = main:FindFirstChildOfClass("UIStroke")
    local function setGlass(s)
        s = math.clamp(s, 0, 1)
        main.BackgroundTransparency       = 0.02 + s*0.88
        inner.BackgroundTransparency      = 0.04 + s*0.78
        topbar.BackgroundTransparency     = 0.06 + s*0.62
        innerStroke.Transparency          = 0.35 + s*0.55
        if mainStroke then mainStroke.Transparency = 0.35 + s*0.45 end
    end

    local function pointOverHub(screen)
        if not main.Visible then return false end
        local ap = main.AbsolutePosition; local sz = main.AbsoluteSize
        if sz.X < 2 or sz.Y < 2 then return false end
        return screen.X>=ap.X and screen.X<ap.X+sz.X and screen.Y>=ap.Y and screen.Y<ap.Y+sz.Y
    end

    -- ── Minimize / Close / Keybind ─────────────────────────────────
    local minimized    = false
    local expandedSize = main.Size

    local function doMinimize()
        minimized = true
        easeTween(main, 0.25, {Size=UDim2.new(0,0,0,H), BackgroundTransparency=0.8})
        task.delay(0.27, function()
            pcall(function()
                main.Visible = false
                main.Size = expandedSize
                main.BackgroundTransparency = 0.2
            end)
        end)
    end

    local function doExpand()
        minimized = false
        main.Size = UDim2.new(0,0,0,H)
        main.BackgroundTransparency = 0.8
        main.Visible = true
        easeTween(main, 0.3, {Size=expandedSize, BackgroundTransparency=0.2})
    end

    minBtn.MouseButton1Click:Connect(function()
        if minimized then doExpand() else doMinimize() end
    end)
    closeBtn.MouseButton1Click:Connect(function()
        main:Destroy(); sg:Destroy()
    end)
    UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == toggleKey then
            if minimized then doExpand() else doMinimize() end
        end
    end)

    -- ── Window object ──────────────────────────────────────────────
    local win = {}
    win._sg         = sg
    win._main       = main
    win._topbar     = topbar
    win._sidebar    = sidebar
    win._scroll     = scroll
    win._C          = C
    win._tabs       = {}
    win._pages      = {}
    win._current    = 1
    win._setGlass   = setGlass

    -- SetTitle
    function win:SetTitle(t) logoLbl.Text = t end

    -- SetGlass (0 = opaque, 1 = fully transparent)
    function win:SetGlass(s) setGlass(s) end

    -- Destroy
    function win:Destroy() main:Destroy(); sg:Destroy() end

    -- ── AddTab ────────────────────────────────────────────────────
    function win:AddTab(name)
        local C2  = self._C
        local idx = #self._tabs + 1

        -- Tab button
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 62, 0, 42)
        btn.BackgroundColor3 = C2.Accent
        btn.BackgroundTransparency = idx == 1 and 0.15 or 0.55
        btn.Text = name; btn.TextSize = 13; btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold; btn.AutoButtonColor = false
        btn.BorderSizePixel = 0; btn.LayoutOrder = idx; btn.Parent = self._sidebar
        corner(10, btn)
        local bstk = Instance.new("UIStroke")
        bstk.Color = Color3.new(0,0,0); bstk.Thickness = 1.5
        bstk.Transparency = idx==1 and 0.3 or 1; bstk.Enabled = (idx==1)
        bstk.Parent = btn

        -- Tab page
        local page = newFrame(self._scroll, UDim2.new(1,-12,0,0), UDim2.new(0,0,0,0))
        page.Name = "Page_"..name
        page.AutomaticSize = Enum.AutomaticSize.Y
        page.Visible = (idx == 1)
        local pl = Instance.new("UIListLayout")
        pl.Padding = UDim.new(0, 10)
        pl.SortOrder = Enum.SortOrder.LayoutOrder
        pl.Parent = page

        table.insert(self._tabs, btn)
        table.insert(self._pages, page)

        -- Switch tab
        btn.MouseButton1Click:Connect(function()
            if self._current == idx then return end
            for j, b in ipairs(self._tabs) do
                local on = (j == idx)
                easeTween(b, 0.15, {BackgroundTransparency = on and 0.15 or 0.55})
                local s = b:FindFirstChildOfClass("UIStroke")
                if s then s.Enabled = on; s.Transparency = on and 0.3 or 1 end
                self._pages[j].Visible = on
            end
            self._current = idx
        end)
        btn.MouseEnter:Connect(function()
            if self._current ~= idx then easeTween(btn,0.1,{BackgroundTransparency=0.35}) end
        end)
        btn.MouseLeave:Connect(function()
            if self._current ~= idx then easeTween(btn,0.1,{BackgroundTransparency=0.55}) end
        end)

        -- ── Tab component API ───────────────────────────────────
        local tab  = {}
        local lo   = 0
        local function nextLo() lo = lo + 1; return lo end

        local function makeRow(text, desc)
            local row = newFrame(page,
                UDim2.new(1,0,0,desc and 54 or 40),
                nil, C2.BG, 0.65)
            row.LayoutOrder = nextLo()
            corner(10, row)
            uistroke(C2.Divider, 1, 0.5, row)
            local lbl = newText("TextLabel", row, text, 14, C2.Text, Enum.Font.GothamMedium)
            lbl.Size = UDim2.new(1,-20,0,20)
            lbl.Position = UDim2.new(0,12,0,10)
            if desc then
                local dl = newText("TextLabel", row, desc, 12, C2.TextMuted)
                dl.Size = UDim2.new(1,-20,0,16)
                dl.Position = UDim2.new(0,12,0,30)
            end
            return row
        end

        -- Header ──────────────────────────────────────────────────
        function tab:Header(htitle, hsubtitle)
            local h = newFrame(page, UDim2.new(1,0,0,0))
            h.AutomaticSize = Enum.AutomaticSize.Y
            h.LayoutOrder = nextLo()
            local t2 = newText("TextLabel", h, htitle, 17, C2.Text, Enum.Font.GothamBold)
            t2.Size = UDim2.new(1,0,0,22)
            if hsubtitle then
                local s2 = newText("TextLabel", h, hsubtitle, 13, C2.TextMuted)
                s2.Size = UDim2.new(1,0,0,36); s2.Position = UDim2.new(0,0,0,24)
                s2.TextYAlignment = Enum.TextYAlignment.Top; s2.TextWrapped = true
            end
        end

        -- Section label ───────────────────────────────────────────
        function tab:Section(text)
            local lo2 = nextLo()
            local sb = Instance.new("TextButton")
            sb.Size = UDim2.new(1,0,0,20); sb.BackgroundTransparency = 1
            sb.Text = "▼  "..text; sb.TextColor3 = C2.TextMuted
            sb.Font = Enum.Font.GothamBold; sb.TextSize = 10
            sb.TextXAlignment = Enum.TextXAlignment.Left
            sb.LayoutOrder = lo2; sb.AutoButtonColor = false
            sb.BorderSizePixel = 0; sb:SetAttribute("_sec", true); sb.Parent = page
            sb.MouseEnter:Connect(function() sb.TextColor3 = C2.Text end)
            sb.MouseLeave:Connect(function() sb.TextColor3 = C2.TextMuted end)
            local collapsed = false
            sb.MouseButton1Click:Connect(function()
                collapsed = not collapsed
                sb.Text = (collapsed and "►  " or "▼  ")..text
                local nextSecLo = math.huge
                for _, c in ipairs(page:GetChildren()) do
                    if c:IsA("GuiObject") and c:GetAttribute("_sec") and c.LayoutOrder > lo2 and c.LayoutOrder < nextSecLo then
                        nextSecLo = c.LayoutOrder
                    end
                end
                for _, c in ipairs(page:GetChildren()) do
                    if c:IsA("GuiObject") then
                        local clo = c.LayoutOrder
                        if clo > lo2 and clo < nextSecLo then
                            c.Visible = not collapsed
                        end
                    end
                end
            end)
            return sb
        end

        -- Toggle ──────────────────────────────────────────────────
        function tab:Toggle(text, desc_or_def, def_or_cb, cb_opt)
            local desc, default, cb
            if type(desc_or_def) == "string" then
                desc = desc_or_def; default = def_or_cb; cb = cb_opt
            else
                desc = nil; default = desc_or_def; cb = def_or_cb
            end
            default = default or false
            local row = makeRow(text, desc)
            local sw  = Instance.new("TextButton")
            sw.Size = UDim2.new(0,48,0,26); sw.Position = UDim2.new(1,-58,0.5,-13)
            sw.BackgroundColor3 = C2.Accent; sw.BorderSizePixel = 0
            sw.Text = ""; sw.AutoButtonColor = false; sw.Parent = row; corner(13, sw)
            local knob = newFrame(sw, UDim2.fromOffset(20,20), nil, C2.Text, 0)
            corner(10, knob)
            local on = default
            local function paint(tween)
                local targetPos = on and UDim2.new(1,-23,0.5,-10) or UDim2.new(0,4,0.5,-10)
                local targetCol = on and C2.Neon or C2.Accent
                if tween then
                    easeTween(sw, 0.2, {BackgroundColor3 = targetCol})
                    easeTween(knob, 0.2, {Position = targetPos})
                else
                    sw.BackgroundColor3 = targetCol; knob.Position = targetPos
                end
            end
            paint(false)
            sw.MouseButton1Click:Connect(function()
                on = not on; paint(true); if cb then cb(on) end
            end)
            return {
                Get = function() return on end,
                Set = function(v) on = v; paint(true); if cb then cb(v) end end,
            }
        end

        -- Button ──────────────────────────────────────────────────
        function tab:Button(text, desc_or_cb, cb_opt)
            local desc, cb
            if type(desc_or_cb) == "string" then desc = desc_or_cb; cb = cb_opt
            else cb = desc_or_cb end
            local row = makeRow(text, desc)
            local b   = Instance.new("TextButton")
            b.Size = UDim2.new(0,80,0,26); b.Position = UDim2.new(1,-90,0.5,-13)
            b.BackgroundColor3 = C2.Accent; b.BackgroundTransparency = 0.3
            b.Text = "Run"; b.TextColor3 = C2.Text; b.TextSize = 12
            b.Font = Enum.Font.GothamMedium; b.AutoButtonColor = false
            b.BorderSizePixel = 0; b.Parent = row; corner(8, b)
            b.MouseButton1Click:Connect(function() if cb then cb() end end)
            b.MouseEnter:Connect(function() easeTween(b,0.1,{BackgroundTransparency=0.08}) end)
            b.MouseLeave:Connect(function() easeTween(b,0.1,{BackgroundTransparency=0.3}) end)
            return b
        end

        -- Slider ──────────────────────────────────────────────────
        function tab:Slider(text, sopts, cb)
            local mn  = sopts.Min or 0
            local mx  = sopts.Max or 100
            local def = sopts.Default or mn
            local rnd = sopts.Round ~= false
            local desc = sopts.Desc or ("Default: "..tostring(def))
            local row = makeRow(text, desc)
            row.Size = UDim2.new(1,0,0,66)
            local valLbl = newText("TextLabel", row, tostring(def), 12, C2.Neon, Enum.Font.GothamBold,
                Enum.TextXAlignment.Right)
            valLbl.Size = UDim2.new(0,44,0,18); valLbl.Position = UDim2.new(1,-54,0,8)
            local bg = newFrame(row, UDim2.new(1,-24,0,6), UDim2.new(0,12,0,50), C2.Divider, 0)
            corner(3, bg)
            local fill = newFrame(bg, UDim2.new(0,0,1,0), nil, C2.Accent, 0)
            corner(3, fill)
            local knob2 = Instance.new("TextButton")
            knob2.Size = UDim2.new(0,14,0,14); knob2.BackgroundColor3 = C2.Neon
            knob2.Text = ""; knob2.AutoButtonColor = false; knob2.BorderSizePixel = 0
            knob2.Parent = bg; corner(7, knob2)
            local range = (mx == mn) and 1 or (mx - mn)
            local val   = def
            local function applyT(t)
                t = math.clamp(t,0,1)
                local raw = mn + t*range
                val = rnd and math.floor(raw+0.5) or raw
                fill.Size = UDim2.new(t,0,1,0)
                knob2.Position = UDim2.new(t,-7,0.5,-7)
                valLbl.Text = tostring(val)
                if cb then cb(val) end
            end
            local t0 = math.clamp((def-mn)/range,0,1)
            fill.Size = UDim2.new(t0,0,1,0); knob2.Position = UDim2.new(t0,-7,0.5,-7)
            local dragging = false
            knob2.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
            end)
            UIS.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            UIS.InputChanged:Connect(function(inp)
                if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                    local a = bg.AbsolutePosition; local sz = math.max(bg.AbsoluteSize.X,1)
                    applyT((inp.Position.X - a.X)/sz)
                end
            end)
            return {
                Get = function() return val end,
                Set = function(v) applyT(math.clamp((v-mn)/range,0,1)) end,
            }
        end

        -- Dropdown ────────────────────────────────────────────────
        function tab:Dropdown(text, options, cb)
            local row = makeRow(text)
            local cur = options[1] or "---"
            local idx2 = 1
            local dBtn = Instance.new("TextButton")
            dBtn.Size = UDim2.new(0,120,0,26); dBtn.Position = UDim2.new(1,-130,0.5,-13)
            dBtn.BackgroundColor3 = C2.Accent; dBtn.BackgroundTransparency = 0.3
            dBtn.Text = cur; dBtn.TextColor3 = C2.Text; dBtn.TextSize = 12
            dBtn.Font = Enum.Font.GothamMedium; dBtn.AutoButtonColor = false
            dBtn.BorderSizePixel = 0; dBtn.Parent = row; corner(8, dBtn)
            uistroke(C2.Divider, 1, 0.4, dBtn)
            dBtn.MouseButton1Click:Connect(function()
                idx2 = (idx2 % #options) + 1
                cur = options[idx2]; dBtn.Text = cur
                if cb then cb(cur) end
            end)
            dBtn.MouseEnter:Connect(function() easeTween(dBtn,0.1,{BackgroundTransparency=0.1}) end)
            dBtn.MouseLeave:Connect(function() easeTween(dBtn,0.1,{BackgroundTransparency=0.3}) end)
            return {
                Get = function() return cur end,
                Set = function(v)
                    for j,o in ipairs(options) do
                        if o==v then idx2=j; cur=v; dBtn.Text=v; if cb then cb(v) end; break end
                    end
                end,
                Options = options,
            }
        end

        -- Input ───────────────────────────────────────────────────
        function tab:Input(text, placeholder, cb)
            local row = makeRow(text)
            local box = Instance.new("TextBox")
            box.Size = UDim2.new(0,140,0,26); box.Position = UDim2.new(1,-150,0.5,-13)
            box.BackgroundColor3 = C2.BG; box.BackgroundTransparency = 0.3
            box.Text = ""; box.PlaceholderText = placeholder or "Enter value..."
            box.TextColor3 = C2.Text; box.PlaceholderColor3 = C2.TextMuted
            box.TextSize = 12; box.Font = Enum.Font.GothamMedium
            box.ClearTextOnFocus = false; box.BorderSizePixel = 0; box.Parent = row
            corner(8, box); uistroke(C2.Divider, 1, 0.4, box)
            box.FocusLost:Connect(function(enter)
                if enter and cb then cb(box.Text) end
            end)
            return {
                Get = function() return box.Text end,
                Set = function(v) box.Text = v end,
            }
        end

        -- Label ───────────────────────────────────────────────────
        function tab:Label(text, color)
            local lbl2 = newText("TextLabel", page, text, 13, color or C2.TextMuted)
            lbl2.Size = UDim2.new(1,0,0,22)
            lbl2.LayoutOrder = nextLo()
            return { Set = function(t) lbl2.Text = t end }
        end

        -- Separator ───────────────────────────────────────────────
        function tab:Separator()
            local sep = newFrame(page, UDim2.new(1,-12,0,1), UDim2.new(0,6,0,0), C2.Divider, 0.4)
            sep.LayoutOrder = nextLo()
        end

        return tab
    end -- AddTab

    return win
end -- CreateWindow

return VortexLib
