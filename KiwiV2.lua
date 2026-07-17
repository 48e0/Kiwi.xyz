local KiwiLibrary = {}
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CG = game:GetService("CoreGui")

local s, r = pcall(function() return loadstring(game:HttpGet("https://raw.githubusercontent.com/KaiStudio0/Icons/refs/heads/main/Icons.lua"))() end)
local Icons = s and r or {}

local C = {
    Bg = Color3.fromRGB(15, 15, 15),
    Side = Color3.fromRGB(22, 22, 22),
    Elem = Color3.fromRGB(30, 30, 30),
    Acc = Color3.fromRGB(46, 204, 113),
    Txt = Color3.fromRGB(240, 240, 240),
    Dim = Color3.fromRGB(140, 140, 140)
}

local function Rnd(p, r) Instance.new("UICorner", p).CornerRadius = UDim.new(0, r or 4) end

local function Drag(top, obj)
    local drag, dragStart, startPos
    top.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag, dragStart, startPos = true, i.Position, obj.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

function KiwiLibrary:CreateWindow()
    for _, g in pairs(CG:GetChildren()) do if g.Name == "KiwiUI" then g:Destroy() end end

    local GUI = Instance.new("ScreenGui", CG)
    GUI.Name = "KiwiUI"

    local Main = Instance.new("Frame", GUI)
    Main.BackgroundColor3, Main.Position, Main.Size = C.Bg, UDim2.new(0.5, -300, 0.5, -200), UDim2.new(0, 600, 0, 400)
    Main.ClipsDescendants = true
    Rnd(Main, 6)

    local Top = Instance.new("Frame", Main)
    Top.BackgroundTransparency, Top.Size = 1, UDim2.new(1, 0, 0, 40)
    Drag(Top, Main)

    local Title = Instance.new("TextLabel", Top)
    Title.BackgroundTransparency, Title.Position, Title.Size = 1, UDim2.new(0, 15, 0, 0), UDim2.new(0, 200, 1, 0)
    Title.Font, Title.RichText, Title.Text, Title.TextSize, Title.TextXAlignment = Enum.Font.GothamBold, true, "<font color='#2ecc71'>Kiwi</font><font color='#8c8c8c'>.xyz</font>", 15, Enum.TextXAlignment.Left

    local MinIcon = Instance.new("TextButton", GUI)
    MinIcon.BackgroundColor3, MinIcon.Size, MinIcon.Position, MinIcon.Visible = C.Bg, UDim2.new(0, 45, 0, 45), UDim2.new(0.5, -22, 0, 20), false
    MinIcon.Font, MinIcon.Text, MinIcon.TextColor3, MinIcon.TextSize = Enum.Font.GothamBold, "K", C.Acc, 24
    Rnd(MinIcon, 8)
    local MinStr = Instance.new("UIStroke", MinIcon)
    MinStr.Color, MinStr.Thickness, MinStr.ApplyStrokeMode = C.Acc, 2, Enum.ApplyStrokeMode.Border
    Drag(MinIcon, MinIcon)

    local MinBtn = Instance.new("TextButton", Top)
    MinBtn.BackgroundTransparency, MinBtn.Position, MinBtn.Size = 1, UDim2.new(1, -35, 0, 10), UDim2.new(0, 20, 0, 20)
    MinBtn.Font, MinBtn.Text, MinBtn.TextColor3, MinBtn.TextSize = Enum.Font.GothamBold, "-", C.Dim, 24
    MinBtn.Activated:Connect(function() Main.Visible, MinIcon.Visible = false, true end)
    MinIcon.Activated:Connect(function() Main.Visible, MinIcon.Visible = true, false end)

    local Side = Instance.new("Frame", Main)
    Side.BackgroundColor3, Side.Position, Side.Size, Side.BorderSizePixel = C.Side, UDim2.new(0, 0, 0, 40), UDim2.new(0, 140, 1, -40), 0

    local Tabs = Instance.new("ScrollingFrame", Side)
    Tabs.BackgroundTransparency, Tabs.Size, Tabs.ScrollBarThickness = 1, UDim2.new(1, 0, 1, -10), 0
    Instance.new("UIListLayout", Tabs).Padding = UDim.new(0, 2)

    local Cont = Instance.new("Frame", Main)
    Cont.BackgroundTransparency, Cont.Position, Cont.Size = 1, UDim2.new(0, 150, 0, 40), UDim2.new(1, -160, 1, -50)

    local W, curTab = {}, nil

    function W:CreateTab(name, icon)
        local TB = Instance.new("TextButton", Tabs)
        TB.BackgroundTransparency, TB.Size, TB.Font, TB.Text, TB.TextColor3, TB.TextSize, TB.TextXAlignment = 1, UDim2.new(1, 0, 0, 32), Enum.Font.Gotham, icon and Icons[icon] and "       "..name or "   "..name, C.Dim, 13, Enum.TextXAlignment.Left

        if icon and Icons[icon] then
            local Img = Instance.new("ImageLabel", TB)
            Img.BackgroundTransparency, Img.Position, Img.Size, Img.Image, Img.ImageColor3 = 1, UDim2.new(0, 8, 0.5, -8), UDim2.new(0, 16, 0, 16), Icons[icon], C.Dim
        end

        local TInd = Instance.new("Frame", TB)
        TInd.BackgroundColor3, TInd.Size, TInd.Position, TInd.AnchorPoint, TInd.BorderSizePixel = C.Acc, UDim2.new(0, 2, 0, 0), UDim2.new(0, 0, 0.5, 0), Vector2.new(0, 0.5), 0

        local TP = Instance.new("ScrollingFrame", Cont)
        TP.BackgroundTransparency, TP.Size, TP.ScrollBarThickness, TP.ScrollBarImageColor3, TP.Visible = 1, UDim2.new(1, 0, 1, 0), 1, C.Acc, false

        local LC, RC = Instance.new("Frame", TP), Instance.new("Frame", TP)
        LC.BackgroundTransparency, LC.Size = 1, UDim2.new(0.48, 0, 1, 0)
        RC.BackgroundTransparency, RC.Position, RC.Size = 1, UDim2.new(0.52, 0, 0, 0), UDim2.new(0.48, 0, 1, 0)
        Instance.new("UIListLayout", LC).Padding = UDim.new(0, 6)
        Instance.new("UIListLayout", RC).Padding = UDim.new(0, 6)

        TB.Activated:Connect(function()
            if curTab then
                curTab.B.TextColor3 = C.Dim
                TS:Create(curTab.I, TweenInfo.new(0.2), {Size = UDim2.new(0, 2, 0, 0)}):Play()
                curTab.P.Visible = false
                if curTab.B:FindFirstChild("ImageLabel") then curTab.B.ImageLabel.ImageColor3 = C.Dim end
            end
            curTab = {B = TB, I = TInd, P = TP}
            TB.TextColor3 = C.Txt
            TS:Create(TInd, TweenInfo.new(0.2), {Size = UDim2.new(0, 2, 0, 18)}):Play()
            TP.Visible = true
            if TB:FindFirstChild("ImageLabel") then TB.ImageLabel.ImageColor3 = C.Acc end
        end)

        if not curTab then
            TB.TextColor3 = C.Txt; TInd.Size = UDim2.new(0, 2, 0, 18); TP.Visible = true
            if TB:FindFirstChild("ImageLabel") then TB.ImageLabel.ImageColor3 = C.Acc end
            curTab = {B = TB, I = TInd, P = TP}
        end

        local T = {}
        local function GC(s) return s == "Right" and RC or LC end

        function T:CreateLabel(txt, side)
            local L = Instance.new("TextLabel", GC(side))
            L.BackgroundTransparency, L.Size, L.Font, L.Text, L.TextColor3, L.TextSize, L.TextXAlignment = 1, UDim2.new(1, 0, 0, 25), Enum.Font.Gotham, txt, C.Txt, 13, Enum.TextXAlignment.Left
        end

        function T:CreateButton(txt, cb, side)
            local B = Instance.new("TextButton", GC(side))
            B.BackgroundColor3, B.Size, B.Font, B.Text, B.TextColor3, B.TextSize = C.Elem, UDim2.new(1, 0, 0, 32), Enum.Font.Gotham, txt, C.Txt, 13
            Rnd(B)
            B.Activated:Connect(function() TS:Create(B, TweenInfo.new(0.1), {BackgroundColor3 = C.Acc}):Play(); task.wait(0.1); TS:Create(B, TweenInfo.new(0.1), {BackgroundColor3 = C.Elem}):Play(); pcall(cb) end)
        end

        function T:CreateToggle(txt, def, cb, side)
            local st = def or false
            local B = Instance.new("TextButton", GC(side))
            B.BackgroundColor3, B.Size, B.Text = C.Elem, UDim2.new(1, 0, 0, 32), ""
            Rnd(B)
            local L = Instance.new("TextLabel", B)
            L.BackgroundTransparency, L.Position, L.Size, L.Font, L.Text, L.TextColor3, L.TextSize, L.TextXAlignment = 1, UDim2.new(0, 10, 0, 0), UDim2.new(1, -40, 1, 0), Enum.Font.Gotham, txt, C.Txt, 13, Enum.TextXAlignment.Left
            local Box = Instance.new("Frame", B)
            Box.BackgroundColor3, Box.Position, Box.Size = st and C.Acc or C.Bg, UDim2.new(1, -26, 0.5, -8), UDim2.new(0, 16, 0, 16)
            Rnd(Box)
            B.Activated:Connect(function() st = not st; TS:Create(Box, TweenInfo.new(0.15), {BackgroundColor3 = st and C.Acc or C.Bg}):Play(); pcall(cb, st) end)
        end

        function T:CreateSlider(txt, mn, mx, def, cb, side)
            local val = def or mn
            local F = Instance.new("Frame", GC(side))
            F.BackgroundColor3, F.Size = C.Elem, UDim2.new(1, 0, 0, 45)
            Rnd(F)
            local L1 = Instance.new("TextLabel", F)
            L1.BackgroundTransparency, L1.Position, L1.Size, L1.Font, L1.Text, L1.TextColor3, L1.TextSize, L1.TextXAlignment = 1, UDim2.new(0, 10, 0, 4), UDim2.new(0.5, 0, 0, 15), Enum.Font.Gotham, txt, C.Txt, 12, Enum.TextXAlignment.Left
            local L2 = Instance.new("TextLabel", F)
            L2.BackgroundTransparency, L2.Position, L2.Size, L2.Font, L2.Text, L2.TextColor3, L2.TextSize, L2.TextXAlignment = 1, UDim2.new(0.5, -10, 0, 4), UDim2.new(0.5, 0, 0, 15), Enum.Font.Gotham, tostring(val), C.Dim, 12, Enum.TextXAlignment.Right
            local Bg = Instance.new("TextButton", F)
            Bg.BackgroundColor3, Bg.Position, Bg.Size, Bg.Text = C.Bg, UDim2.new(0, 10, 0, 25), UDim2.new(1, -20, 0, 6), ""
            Rnd(Bg, 6)
            local Fill = Instance.new("Frame", Bg)
            Fill.BackgroundColor3, Fill.Size = C.Acc, UDim2.new((val-mn)/(mx-mn), 0, 1, 0)
            Rnd(Fill, 6)
            local d = false
            local function U(i)
                local rel = math.clamp((i.Position.X - Bg.AbsolutePosition.X) / Bg.AbsoluteSize.X, 0, 1)
                val = math.floor(mn + ((mx - mn) * rel)); L2.Text = tostring(val)
                TS:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(rel, 0, 1, 0)}):Play(); pcall(cb, val)
            end
            Bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; U(i) end end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
            UIS.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then U(i) end end)
        end

        function T:CreateDropdown(txt, opts, cb, side)
            local F = Instance.new("Frame", GC(side))
            F.BackgroundColor3, F.ClipsDescendants, F.Size = C.Elem, true, UDim2.new(1, 0, 0, 32)
            Rnd(F)
            local B = Instance.new("TextButton", F)
            B.BackgroundTransparency, B.Size, B.Font, B.Text, B.TextColor3, B.TextSize, B.TextXAlignment = 1, UDim2.new(1, 0, 0, 32), Enum.Font.Gotham, "  "..txt, C.Txt, 13, Enum.TextXAlignment.Left
            local o = false
            B.Activated:Connect(function() o = not o; TS:Create(F, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, o and (32 + (#opts * 25) + 5) or 32)}):Play() end)
            local Y = 32
            for _, opt in ipairs(opts) do
                local OB = Instance.new("TextButton", F)
                OB.BackgroundTransparency, OB.Position, OB.Size, OB.Font, OB.Text, OB.TextColor3, OB.TextSize, OB.TextXAlignment = 1, UDim2.new(0, 0, 0, Y), UDim2.new(1, 0, 0, 25), Enum.Font.Gotham, "  - "..opt, C.Dim, 12, Enum.TextXAlignment.Left
                OB.Activated:Connect(function() o = false; B.Text = "  "..txt..": "..opt; TS:Create(F, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 32)}):Play(); pcall(cb, opt) end)
                Y = Y + 25
            end
        end

        function T:CreateTextbox(txt, ph, cb, side)
            local F = Instance.new("Frame", GC(side))
            F.BackgroundColor3, F.Size = C.Elem, UDim2.new(1, 0, 0, 45)
            Rnd(F)
            local L = Instance.new("TextLabel", F)
            L.BackgroundTransparency, L.Position, L.Size, L.Font, L.Text, L.TextColor3, L.TextSize, L.TextXAlignment = 1, UDim2.new(0, 10, 0, 4), UDim2.new(1, -20, 0, 15), Enum.Font.Gotham, txt, C.Txt, 12, Enum.TextXAlignment.Left
            local Box = Instance.new("TextBox", F)
            Box.BackgroundColor3, Box.Position, Box.Size, Box.Font, Box.PlaceholderText, Box.Text, Box.TextColor3, Box.TextSize = C.Bg, UDim2.new(0, 10, 0, 22), UDim2.new(1, -20, 0, 18), Enum.Font.Gotham, ph, "", C.Txt, 11
            Rnd(Box, 4)
            Box.FocusLost:Connect(function() pcall(cb, Box.Text) end)
        end

        function T:CreateKeybind(txt, def, cb, side)
            local key = def
            local F = Instance.new("Frame", GC(side))
            F.BackgroundColor3, F.Size = C.Elem, UDim2.new(1, 0, 0, 32)
            Rnd(F)
            local L = Instance.new("TextLabel", F)
            L.BackgroundTransparency, L.Position, L.Size, L.Font, L.Text, L.TextColor3, L.TextSize, L.TextXAlignment = 1, UDim2.new(0, 10, 0, 0), UDim2.new(1, -70, 1, 0), Enum.Font.Gotham, txt, C.Txt, 13, Enum.TextXAlignment.Left
            local B = Instance.new("TextButton", F)
            B.BackgroundColor3, B.Position, B.Size, B.Font, B.Text, B.TextColor3, B.TextSize = C.Bg, UDim2.new(1, -60, 0.5, -10), UDim2.new(0, 50, 0, 20), Enum.Font.Gotham, key.Name, C.Acc, 12
            Rnd(B)
            local w = false
            B.Activated:Connect(function() B.Text = "..."; w = true end)
            UIS.InputBegan:Connect(function(i, gpe)
                if w and i.UserInputType == Enum.UserInputType.Keyboard then key = i.KeyCode; B.Text = key.Name; w = false
                elseif not gpe and i.KeyCode == key and not w then pcall(cb) end
            end)
        end

        function T:CreateColorPicker(txt, def, cb, side)
            local clr = def or Color3.fromRGB(255, 255, 255)
            local F = Instance.new("Frame", GC(side))
            F.BackgroundColor3, F.ClipsDescendants, F.Size = C.Elem, true, UDim2.new(1, 0, 0, 32)
            Rnd(F)
            local B = Instance.new("TextButton", F)
            B.BackgroundTransparency, B.Size, B.Text = 1, UDim2.new(1, 0, 0, 32), ""
            local L = Instance.new("TextLabel", B)
            L.BackgroundTransparency, L.Position, L.Size, L.Font, L.Text, L.TextColor3, L.TextSize, L.TextXAlignment = 1, UDim2.new(0, 10, 0, 0), UDim2.new(1, -40, 1, 0), Enum.Font.Gotham, txt, C.Txt, 13, Enum.TextXAlignment.Left
            local D = Instance.new("Frame", B)
            D.BackgroundColor3, D.Position, D.Size = clr, UDim2.new(1, -30, 0.5, -8), UDim2.new(0, 20, 0, 16)
            Rnd(D)
            local o = false
            B.Activated:Connect(function() o = not o; TS:Create(F, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, o and 80 or 32)}):Play() end)
            local function CMS(y, c)
                local Bg = Instance.new("TextButton", F)
                Bg.BackgroundColor3, Bg.Position, Bg.Size, Bg.Text = C.Bg, UDim2.new(0, 10, 0, y), UDim2.new(1, -20, 0, 8), ""
                Rnd(Bg)
                local Fill = Instance.new("Frame", Bg)
                Fill.BackgroundColor3, Fill.Size = c, UDim2.new(1, 0, 1, 0)
                Rnd(Fill)
                return Bg, Fill
            end
            local RBg, RFill = CMS(38, Color3.fromRGB(255, 80, 80))
            local GBg, GFill = CMS(52, Color3.fromRGB(80, 255, 80))
            local BBg, BFill = CMS(66, Color3.fromRGB(80, 80, 255))
            local function BCS(bg, fill)
                local d = false
                local function UC(i)
                    fill.Size = UDim2.new(math.clamp((i.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1), 0, 1, 0)
                    clr = Color3.fromRGB(RFill.Size.X.Scale*255, GFill.Size.X.Scale*255, BFill.Size.X.Scale*255)
                    D.BackgroundColor3 = clr; pcall(cb, clr)
                end
                bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; UC(i) end end)
                UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
                UIS.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then UC(i) end end)
            end
            BCS(RBg, RFill); BCS(GBg, GFill); BCS(BBg, BFill)
        end

        return T
    end
    return W
end
return KiwiLibrary