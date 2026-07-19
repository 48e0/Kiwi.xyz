local KiwiLibrary = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Success, Result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/KaiStudio0/Icons/refs/heads/main/Icons.lua"))()
end)
local Icons = Success and Result or {}

-- ==========================================
-- NUEVO TEMA: AMATHYST (Gris Plomo y Morado)
-- ==========================================
local Theme = {
    Background = Color3.fromRGB(26, 26, 30),     -- Gris oscuro base
    Sidebar = Color3.fromRGB(20, 20, 23),        -- Gris más oscuro para el lateral
    ElementBg = Color3.fromRGB(35, 35, 42),      -- Gris medio para elementos
    ElementHover = Color3.fromRGB(45, 45, 55),   -- Gris claro para Hover
    Stroke = Color3.fromRGB(55, 55, 65),         -- Bordes sutiles
    Accent = Color3.fromRGB(157, 78, 221),       -- Morado Amatista Elegante (#9D4EDD)
    Text = Color3.fromRGB(250, 250, 250),        -- Blanco puro
    TextDim = Color3.fromRGB(160, 160, 175)      -- Gris azulado para texto secundario
}

local CustomFont = Enum.Font.Montserrat -- Fuente más elegante

local function ApplyCorner(Target, Radius)
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, Radius or 8) -- Bordes más curvos
    Corner.Parent = Target
end

local function ApplyStroke(Target, Color, Transparency)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color or Theme.Stroke
    Stroke.Transparency = Transparency or 0.3
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = Target
    return Stroke
end

local function MakeDraggable(DragArea, TargetObject)
    local IsDragging, DragInput, DragStart, StartPosition
    DragArea.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            IsDragging = true
            DragStart = Input.Position
            StartPosition = TargetObject.Position
            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then IsDragging = false end
            end)
        end
    end)
    DragArea.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            DragInput = Input
        end
    end)
    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and IsDragging then
            local Delta = Input.Position - DragStart
            TargetObject.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        end
    end)
end

function KiwiLibrary:CreateWindow(TitleName)
    local WindowName = TitleName or "Kiwi.xyz"

    for _, GUI in pairs(CoreGui:GetChildren()) do
        if GUI.Name == "KiwiUI_Amethyst" then GUI:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KiwiUI_Amethyst"
    ScreenGui.Parent = CoreGui

    local MainFrame = Instance.new("CanvasGroup")
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 480, 0, 320)
    MainFrame.GroupTransparency = 1
    ApplyCorner(MainFrame, 12)
    ApplyStroke(MainFrame, Theme.Stroke, 0)

    TweenService:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 680, 0, 450),
        GroupTransparency = 0
    }):Play()

    local Topbar = Instance.new("Frame")
    Topbar.Parent = MainFrame
    Topbar.BackgroundTransparency = 1
    Topbar.Size = UDim2.new(1, 0, 0, 50)
    MakeDraggable(Topbar, MainFrame)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = Topbar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 25, 0, 0)
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Font = Enum.Font.MontserratBold
    TitleLabel.RichText = true
    TitleLabel.Text = "<font color='#9D4EDD'>"..string.sub(WindowName, 1, 4).."</font><font color='#A0A0AF'>"..string.sub(WindowName, 5).."</font>"
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local MinimizeIcon = Instance.new("TextButton")
    MinimizeIcon.Parent = ScreenGui
    MinimizeIcon.BackgroundColor3 = Theme.Background
    MinimizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    MinimizeIcon.Position = UDim2.new(0.5, 0, 0, 50)
    MinimizeIcon.Size = UDim2.new(0, 0, 0, 0)
    MinimizeIcon.Visible = false
    MinimizeIcon.Font = Enum.Font.MontserratBold 
    MinimizeIcon.Text = string.sub(WindowName, 1, 1)
    MinimizeIcon.TextColor3 = Theme.Accent
    MinimizeIcon.TextSize = 24
    ApplyCorner(MinimizeIcon, 12)
    ApplyStroke(MinimizeIcon, Theme.Accent, 0)
    MakeDraggable(MinimizeIcon, MinimizeIcon)

    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = Topbar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -40, 0, 15)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Font = Enum.Font.MontserratMedium
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Theme.TextDim
    CloseButton.TextSize = 18

    CloseButton.Activated:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 500, 0, 350), GroupTransparency = 1
        }):Play()
        task.wait(0.4)
        ScreenGui:Destroy()
    end)

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Parent = Topbar
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -70, 0, 15)
    MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
    MinimizeButton.Font = Enum.Font.MontserratMedium
    MinimizeButton.Text = "—"
    MinimizeButton.TextColor3 = Theme.TextDim
    MinimizeButton.TextSize = 16

    MinimizeButton.Activated:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 500, 0, 350), GroupTransparency = 1
        }):Play()
        task.wait(0.4)
        MainFrame.Visible = false
        MinimizeIcon.Visible = true
        TweenService:Create(MinimizeIcon, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 50, 0, 50)
        }):Play()
    end)

    MinimizeIcon.Activated:Connect(function()
        TweenService:Create(MinimizeIcon, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.2)
        MinimizeIcon.Visible = false
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 680, 0, 450), GroupTransparency = 0
        }):Play()
    end)

    -- Diseño del Sidebar Separado
    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.Size = UDim2.new(0, 160, 1, -50)
    Sidebar.BorderSizePixel = 0
    
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 0, 0, 10)
    TabContainer.Size = UDim2.new(1, 0, 1, -20)
    TabContainer.ScrollBarThickness = 0

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabContainer
    TabListLayout.Padding = UDim.new(0, 6)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 175, 0, 50)
    ContentContainer.Size = UDim2.new(1, -190, 1, -65)

    local WindowObject = {}
    local CurrentTab = nil

    function WindowObject:CreateTab(TabName, IconName)
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Theme.Accent
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(0.85, 0, 0, 40)
        TabButton.Font = CustomFont
        TabButton.Text = (IconName and Icons[IconName]) and ("       " .. TabName) or ("   " .. TabName)
        TabButton.TextColor3 = Theme.TextDim
        TabButton.TextSize = 13
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        ApplyCorner(TabButton, 8)

        if IconName and Icons[IconName] then
            local TabIcon = Instance.new("ImageLabel")
            TabIcon.Parent = TabButton
            TabIcon.BackgroundTransparency = 1
            TabIcon.Position = UDim2.new(0, 12, 0.5, -8)
            TabIcon.Size = UDim2.new(0, 16, 0, 16)
            TabIcon.Image = Icons[IconName]
            TabIcon.ImageColor3 = Theme.TextDim
        end

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Parent = ContentContainer
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0) 
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y 
        TabPage.ScrollBarThickness = 2
        TabPage.ScrollBarImageColor3 = Theme.Accent
        TabPage.Visible = false

        local LeftColumn = Instance.new("Frame")
        LeftColumn.Parent = TabPage
        LeftColumn.BackgroundTransparency = 1
        LeftColumn.Size = UDim2.new(0.48, 0, 0, 0)
        LeftColumn.AutomaticSize = Enum.AutomaticSize.Y

        local RightColumn = Instance.new("Frame")
        RightColumn.Parent = TabPage
        RightColumn.BackgroundTransparency = 1
        RightColumn.Position = UDim2.new(0.52, 0, 0, 0)
        RightColumn.Size = UDim2.new(0.48, 0, 0, 0)
        RightColumn.AutomaticSize = Enum.AutomaticSize.Y

        Instance.new("UIListLayout", LeftColumn).Padding = UDim.new(0, 10)
        Instance.new("UIListLayout", RightColumn).Padding = UDim.new(0, 10)

        local function ActivateTab()
            if CurrentTab then
                TweenService:Create(CurrentTab.Button, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = Theme.TextDim}):Play()
                CurrentTab.Page.Visible = false
                if CurrentTab.Button:FindFirstChild("ImageLabel") then
                    TweenService:Create(CurrentTab.Button.ImageLabel, TweenInfo.new(0.3), {ImageColor3 = Theme.TextDim}):Play()
                end
            end

            CurrentTab = {Button = TabButton, Page = TabPage}
            -- Efecto "Píldora" Morada
            TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundTransparency = 0, TextColor3 = Theme.Text}):Play()
            TabPage.Visible = true

            if TabButton:FindFirstChild("ImageLabel") then
                TweenService:Create(TabButton.ImageLabel, TweenInfo.new(0.3), {ImageColor3 = Theme.Text}):Play()
            end
        end

        TabButton.Activated:Connect(ActivateTab)
        if not CurrentTab then ActivateTab() end

        local TabElements = {}
        local function GetTargetColumn(Side) return (Side == "Right") and RightColumn or LeftColumn end

        function TabElements:CreateSection(SectionTitle, Side)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Parent = GetTargetColumn(Side)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Size = UDim2.new(1, 0, 0, 35)

            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Parent = SectionFrame
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Position = UDim2.new(0, 0, 0, 10)
            SectionLabel.Size = UDim2.new(1, 0, 0, 20)
            SectionLabel.Font = Enum.Font.MontserratBold
            SectionLabel.Text = string.upper(SectionTitle)
            SectionLabel.TextColor3 = Theme.Accent
            SectionLabel.TextSize = 11
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left

            local SectionLine = Instance.new("Frame")
            SectionLine.Parent = SectionFrame
            SectionLine.BackgroundColor3 = Theme.Stroke
            SectionLine.BorderSizePixel = 0
            SectionLine.Position = UDim2.new(0, 0, 0, 32)
            SectionLine.Size = UDim2.new(1, 0, 0, 1)
        end

        function TabElements:CreateLabel(LabelText, Side)
            local Label = Instance.new("TextLabel")
            Label.Parent = GetTargetColumn(Side)
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.Font = CustomFont
            Label.Text = LabelText
            Label.TextColor3 = Theme.TextDim
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
        end

        function TabElements:CreateButton(ButtonText, Callback, Side)
            local Button = Instance.new("TextButton")
            Button.Parent = GetTargetColumn(Side)
            Button.BackgroundColor3 = Theme.ElementBg
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.Font = CustomFont
            Button.Text = ButtonText
            Button.TextColor3 = Theme.Text
            Button.TextSize = 13
            ApplyCorner(Button, 8)
            ApplyStroke(Button)

            Button.MouseEnter:Connect(function() TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementHover}):Play() end)
            Button.MouseLeave:Connect(function() TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementBg}):Play() end)

            Button.Activated:Connect(function()
                local ClickAnim = TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0.96, 0, 0, 36)})
                ClickAnim:Play(); ClickAnim.Completed:Wait()
                TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                pcall(Callback)
            end)
        end

        function TabElements:CreateToggle(ToggleText, DefaultState, Callback, Side)
            local CurrentState = DefaultState or false

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Parent = GetTargetColumn(Side)
            ToggleButton.BackgroundColor3 = Theme.ElementBg
            ToggleButton.Size = UDim2.new(1, 0, 0, 40)
            ToggleButton.Text = ""
            ApplyCorner(ToggleButton, 8)
            ApplyStroke(ToggleButton)

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Parent = ToggleButton
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Font = CustomFont
            ToggleLabel.Text = ToggleText
            ToggleLabel.TextColor3 = Theme.Text
            ToggleLabel.TextSize = 13
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

            -- Píldora de iOS/Android
            local ToggleBg = Instance.new("Frame")
            ToggleBg.Parent = ToggleButton
            ToggleBg.BackgroundColor3 = CurrentState and Theme.Accent or Theme.Background
            ToggleBg.Position = UDim2.new(1, -45, 0.5, -10)
            ToggleBg.Size = UDim2.new(0, 34, 0, 20)
            ApplyCorner(ToggleBg, 10)
            ApplyStroke(ToggleBg)

            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Parent = ToggleBg
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.Position = CurrentState and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            ToggleCircle.Size = UDim2.new(0, 14, 0, 14)
            ApplyCorner(ToggleCircle, 7)

            ToggleButton.Activated:Connect(function()
                CurrentState = not CurrentState
                TweenService:Create(ToggleBg, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                    BackgroundColor3 = CurrentState and Theme.Accent or Theme.Background
                }):Play()
                TweenService:Create(ToggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                    Position = CurrentState and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                }):Play()
                pcall(Callback, CurrentState)
            end)
        end

        function TabElements:CreateSlider(SliderText, MinValue, MaxValue, DefaultValue, Callback, Side)
            local CurrentValue = DefaultValue or MinValue

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = GetTargetColumn(Side)
            SliderFrame.BackgroundColor3 = Theme.ElementBg
            SliderFrame.Size = UDim2.new(1, 0, 0, 55)
            ApplyCorner(SliderFrame, 8)
            ApplyStroke(SliderFrame)

            local SliderTitle = Instance.new("TextLabel")
            SliderTitle.Parent = SliderFrame
            SliderTitle.BackgroundTransparency = 1
            SliderTitle.Position = UDim2.new(0, 15, 0, 8)
            SliderTitle.Size = UDim2.new(0.5, 0, 0, 15)
            SliderTitle.Font = CustomFont
            SliderTitle.Text = SliderText
            SliderTitle.TextColor3 = Theme.Text
            SliderTitle.TextSize = 13
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

            local ValueDisplay = Instance.new("TextLabel")
            ValueDisplay.Parent = SliderFrame
            ValueDisplay.BackgroundTransparency = 1
            ValueDisplay.Position = UDim2.new(0.5, -15, 0, 8)
            ValueDisplay.Size = UDim2.new(0.5, 0, 0, 15)
            ValueDisplay.Font = Enum.Font.MontserratBold
            ValueDisplay.Text = tostring(CurrentValue)
            ValueDisplay.TextColor3 = Theme.Accent
            ValueDisplay.TextSize = 13
            ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right

            -- Línea Fina Elegante
            local SliderTrack = Instance.new("TextButton")
            SliderTrack.Parent = SliderFrame
            SliderTrack.BackgroundColor3 = Theme.Background
            SliderTrack.Position = UDim2.new(0, 15, 0, 36)
            SliderTrack.Size = UDim2.new(1, -30, 0, 4)
            SliderTrack.Text = ""
            ApplyCorner(SliderTrack, 2)

            local SliderFill = Instance.new("Frame")
            SliderFill.Parent = SliderTrack
            SliderFill.BackgroundColor3 = Theme.Accent
            SliderFill.Size = UDim2.new((CurrentValue - MinValue) / (MaxValue - MinValue), 0, 1, 0)
            ApplyCorner(SliderFill, 2)

            -- Bolita del Slider
            local SliderKnob = Instance.new("Frame")
            SliderKnob.Parent = SliderFill
            SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
            SliderKnob.Position = UDim2.new(1, 0, 0.5, 0)
            SliderKnob.Size = UDim2.new(0, 12, 0, 12)
            ApplyCorner(SliderKnob, 6)

            local IsDragging = false

            local function UpdateSliderPosition(Input)
                local RelativePosition = math.clamp((Input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                CurrentValue = math.floor(MinValue + ((MaxValue - MinValue) * RelativePosition))
                ValueDisplay.Text = tostring(CurrentValue)
                TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(RelativePosition, 0, 1, 0)}):Play()
                pcall(Callback, CurrentValue)
            end

            SliderTrack.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    IsDragging = true; UpdateSliderPosition(Input)
                    TweenService:Create(SliderKnob, TweenInfo.new(0.2), {Size = UDim2.new(0, 16, 0, 16)}):Play()
                end
            end)
            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    IsDragging = false
                    TweenService:Create(SliderKnob, TweenInfo.new(0.2), {Size = UDim2.new(0, 12, 0, 12)}):Play()
                end
            end)
            UserInputService.InputChanged:Connect(function(Input)
                if IsDragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSliderPosition(Input)
                end
            end)
        end

        function TabElements:CreateDropdown(DropdownText, OptionsList, Callback, Side)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Parent = GetTargetColumn(Side)
            DropdownFrame.BackgroundColor3 = Theme.ElementBg
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            ApplyCorner(DropdownFrame, 8)
            ApplyStroke(DropdownFrame)

            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Parent = DropdownFrame
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Size = UDim2.new(1, 0, 0, 40)
            DropdownButton.Font = CustomFont
            DropdownButton.Text = "   " .. DropdownText
            DropdownButton.TextColor3 = Theme.Text
            DropdownButton.TextSize = 13
            DropdownButton.TextXAlignment = Enum.TextXAlignment.Left

            local Arrow = Instance.new("TextLabel")
            Arrow.Parent = DropdownButton
            Arrow.BackgroundTransparency = 1
            Arrow.Position = UDim2.new(1, -30, 0, 0)
            Arrow.Size = UDim2.new(0, 20, 1, 0)
            Arrow.Font = Enum.Font.MontserratBold
            Arrow.Text = "˅"
            Arrow.TextColor3 = Theme.Accent
            Arrow.TextSize = 14

            local IsOpen = false

            DropdownButton.Activated:Connect(function()
                IsOpen = not IsOpen
                Arrow.Text = IsOpen and "˄" or "˅"
                local TargetHeight = IsOpen and (40 + (#OptionsList * 30) + 5) or 40
                TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, TargetHeight)}):Play()
            end)

            local YOffset = 40
            for _, OptionString in ipairs(OptionsList) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Parent = DropdownFrame
                OptionButton.BackgroundTransparency = 1
                OptionButton.Position = UDim2.new(0, 0, 0, YOffset)
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.Font = CustomFont
                OptionButton.Text = "     • " .. OptionString
                OptionButton.TextColor3 = Theme.TextDim
                OptionButton.TextSize = 12
                OptionButton.TextXAlignment = Enum.TextXAlignment.Left

                OptionButton.MouseEnter:Connect(function() TweenService:Create(OptionButton, TweenInfo.new(0.2), {TextColor3 = Theme.Accent}):Play() end)
                OptionButton.MouseLeave:Connect(function() TweenService:Create(OptionButton, TweenInfo.new(0.2), {TextColor3 = Theme.TextDim}):Play() end)

                OptionButton.Activated:Connect(function()
                    IsOpen = false
                    Arrow.Text = "˅"
                    DropdownButton.Text = "   " .. DropdownText .. ": " .. OptionString
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                    pcall(Callback, OptionString)
                end)
                YOffset = YOffset + 30
            end
        end

        function TabElements:CreateTextbox(TextboxText, Placeholder, Callback, Side)
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Parent = GetTargetColumn(Side)
            TextboxFrame.BackgroundColor3 = Theme.ElementBg
            TextboxFrame.Size = UDim2.new(1, 0, 0, 60)
            ApplyCorner(TextboxFrame, 8)
            ApplyStroke(TextboxFrame)

            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Parent = TextboxFrame
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Position = UDim2.new(0, 15, 0, 8)
            TextboxLabel.Size = UDim2.new(1, -30, 0, 15)
            TextboxLabel.Font = CustomFont
            TextboxLabel.Text = TextboxText
            TextboxLabel.TextColor3 = Theme.Text
            TextboxLabel.TextSize = 13
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left

            local InputField = Instance.new("TextBox")
            InputField.Parent = TextboxFrame
            InputField.BackgroundColor3 = Theme.Background
            InputField.Position = UDim2.new(0, 15, 0, 28)
            InputField.Size = UDim2.new(1, -30, 0, 24)
            InputField.Font = CustomFont
            InputField.PlaceholderText = Placeholder
            InputField.Text = ""
            InputField.TextColor3 = Theme.Accent
            InputField.TextSize = 12
            ApplyCorner(InputField, 6)
            local InputStroke = ApplyStroke(InputField, Theme.Stroke, 0)

            InputField.Focused:Connect(function() TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Theme.Accent}):Play() end)
            InputField.FocusLost:Connect(function() 
                TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Theme.Stroke}):Play()
                pcall(Callback, InputField.Text) 
            end)
        end

        function TabElements:CreateColorPicker(PickerText, DefaultColor, Callback, Side)
            local CurrentColor = DefaultColor or Color3.fromRGB(255, 255, 255)

            local PickerFrame = Instance.new("Frame")
            PickerFrame.Parent = GetTargetColumn(Side)
            PickerFrame.BackgroundColor3 = Theme.ElementBg
            PickerFrame.ClipsDescendants = true
            PickerFrame.Size = UDim2.new(1, 0, 0, 40)
            ApplyCorner(PickerFrame, 8)
            ApplyStroke(PickerFrame)

            local MainPickerButton = Instance.new("TextButton")
            MainPickerButton.Parent = PickerFrame
            MainPickerButton.BackgroundTransparency = 1
            MainPickerButton.Size = UDim2.new(1, 0, 0, 40)
            MainPickerButton.Text = ""

            local PickerLabel = Instance.new("TextLabel")
            PickerLabel.Parent = MainPickerButton
            PickerLabel.BackgroundTransparency = 1
            PickerLabel.Position = UDim2.new(0, 15, 0, 0)
            PickerLabel.Size = UDim2.new(1, -50, 1, 0)
            PickerLabel.Font = CustomFont
            PickerLabel.Text = PickerText
            PickerLabel.TextColor3 = Theme.Text
            PickerLabel.TextSize = 13
            PickerLabel.TextXAlignment = Enum.TextXAlignment.Left

            local ColorDisplay = Instance.new("Frame")
            ColorDisplay.Parent = MainPickerButton
            ColorDisplay.BackgroundColor3 = CurrentColor
            ColorDisplay.Position = UDim2.new(1, -35, 0.5, -10)
            ColorDisplay.Size = UDim2.new(0, 20, 0, 20)
            ApplyCorner(ColorDisplay, 10)
            ApplyStroke(ColorDisplay, Theme.Stroke, 0)

            local IsOpen = false

            MainPickerButton.Activated:Connect(function()
                IsOpen = not IsOpen
                local TargetHeight = IsOpen and 95 or 40
                TweenService:Create(PickerFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, TargetHeight)}):Play()
            end)

            local function CreateMiniSlider(YPosition, SliderColor)
                local SliderBg = Instance.new("TextButton")
                SliderBg.Parent = PickerFrame
                SliderBg.BackgroundColor3 = Theme.Background
                SliderBg.Position = UDim2.new(0, 15, 0, YPosition)
                SliderBg.Size = UDim2.new(1, -30, 0, 6)
                SliderBg.Text = ""
                ApplyCorner(SliderBg, 3)

                local SliderFill = Instance.new("Frame")
                SliderFill.Parent = SliderBg
                SliderFill.BackgroundColor3 = SliderColor
                SliderFill.Size = UDim2.new(1, 0, 1, 0)
                ApplyCorner(SliderFill, 3)
                return SliderBg, SliderFill
            end

            local RedBg, RedFill = CreateMiniSlider(48, Color3.fromRGB(255, 75, 75))
            local GreenBg, GreenFill = CreateMiniSlider(64, Color3.fromRGB(75, 255, 75))
            local BlueBg, BlueFill = CreateMiniSlider(80, Color3.fromRGB(75, 125, 255))

            local function BindColorSlider(Background, Fill)
                local IsDragging = false
                local function UpdateColor(Input)
                    local RelativePos = math.clamp((Input.Position.X - Background.AbsolutePosition.X) / Background.AbsoluteSize.X, 0, 1)
                    Fill.Size = UDim2.new(RelativePos, 0, 1, 0)
                    CurrentColor = Color3.fromRGB(RedFill.Size.X.Scale * 255, GreenFill.Size.X.Scale * 255, BlueFill.Size.X.Scale * 255)
                    ColorDisplay.BackgroundColor3 = CurrentColor
                    pcall(Callback, CurrentColor)
                end
                Background.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then IsDragging = true; UpdateColor(Input) end
                end)
                UserInputService.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then IsDragging = false end
                end)
                UserInputService.InputChanged:Connect(function(Input)
                    if IsDragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then UpdateColor(Input) end
                end)
            end

            BindColorSlider(RedBg, RedFill)
            BindColorSlider(GreenBg, GreenFill)
            BindColorSlider(BlueBg, BlueFill)
        end

        return TabElements
    end

    return WindowObject
end

return KiwiLibrary