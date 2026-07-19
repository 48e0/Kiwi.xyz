local KiwiLibrary = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Success, Result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/KaiStudio0/Icons/refs/heads/main/Icons.lua"))()
end)
local Icons = Success and Result or {}

-- NUEVA PALETA DE COLORES (Premium Midnight & Neon Kiwi)
local Theme = {
    Background = Color3.fromRGB(12, 14, 18),     -- Fondo principal ultra oscuro
    Sidebar = Color3.fromRGB(16, 18, 23),        -- Panel lateral ligeramente más claro
    ElementBg = Color3.fromRGB(22, 24, 30),      -- Fondo de botones
    ElementHover = Color3.fromRGB(30, 32, 40),   -- Fondo al pasar el ratón
    Stroke = Color3.fromRGB(40, 42, 50),         -- Bordes sutiles
    Accent = Color3.fromRGB(0, 255, 102),        -- Verde Neón Brutal
    Text = Color3.fromRGB(255, 255, 255),        -- Texto principal brillante
    TextDim = Color3.fromRGB(130, 135, 145)      -- Texto apagado elegante
}

local function ApplyCorner(InstanceTarget, RadiusValue)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, RadiusValue or 6) -- Bordes más suaves por defecto
    UICorner.Parent = InstanceTarget
end

local function ApplyStroke(InstanceTarget, Color, Transparency)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color or Theme.Stroke
    Stroke.Transparency = Transparency or 0
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = InstanceTarget
    return Stroke
end

local function AddHoverEffect(Element, DefaultColor, HoverColor)
    Element.MouseEnter:Connect(function()
        TweenService:Create(Element, TweenInfo.new(0.2), {BackgroundColor3 = HoverColor}):Play()
    end)
    Element.MouseLeave:Connect(function()
        TweenService:Create(Element, TweenInfo.new(0.2), {BackgroundColor3 = DefaultColor}):Play()
    end)
end

local function MakeDraggable(DragArea, TargetObject)
    local IsDragging = false
    local DragInput, DragStart, StartPosition

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
            TargetObject.Position = UDim2.new(
                StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, 
                StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y
            )
        end
    end)
end

function KiwiLibrary:CreateWindow()
    for _, GUI in pairs(CoreGui:GetChildren()) do
        if GUI.Name == "KiwiUI_Pro" then GUI:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KiwiUI_Pro"
    ScreenGui.Parent = CoreGui

    local MainFrame = Instance.new("CanvasGroup")
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 480, 0, 320) -- Inicia pequeño
    MainFrame.GroupTransparency = 1
    ApplyCorner(MainFrame, 8)
    ApplyStroke(MainFrame, Theme.Stroke, 0.3)

    -- Animación de Entrada "Pop"
    TweenService:Create(MainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 650, 0, 420),
        GroupTransparency = 0
    }):Play()

    local Topbar = Instance.new("Frame")
    Topbar.Parent = MainFrame
    Topbar.BackgroundTransparency = 1
    Topbar.Size = UDim2.new(1, 0, 0, 45)
    MakeDraggable(Topbar, MainFrame)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = Topbar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.RichText = true
    TitleLabel.Text = "<font color='#00FF66'>Kiwi</font><font color='#828791'>.xyz</font>"
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local MinimizeIcon = Instance.new("TextButton")
    MinimizeIcon.Parent = ScreenGui
    MinimizeIcon.BackgroundColor3 = Theme.Background
    MinimizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    MinimizeIcon.Position = UDim2.new(0.5, 0, 0, 45)
    MinimizeIcon.Size = UDim2.new(0, 0, 0, 0)
    MinimizeIcon.Visible = false
    MinimizeIcon.Font = Enum.Font.Bodoni 
    MinimizeIcon.Text = "K"
    MinimizeIcon.TextColor3 = Theme.Accent
    MinimizeIcon.TextSize = 28
    ApplyCorner(MinimizeIcon, 10)
    ApplyStroke(MinimizeIcon, Theme.Accent, 0)
    MakeDraggable(MinimizeIcon, MinimizeIcon)

    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = Topbar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -30, 0, 12)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Theme.TextDim
    CloseButton.TextSize = 22

    CloseButton.Activated:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 480, 0, 320), GroupTransparency = 1
        }):Play()
        task.wait(0.3)
        ScreenGui:Destroy()
    end)

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Parent = Topbar
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -55, 0, 12)
    MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Theme.TextDim
    MinimizeButton.TextSize = 22

    MinimizeButton.Activated:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 480, 0, 320), GroupTransparency = 1
        }):Play()
        task.wait(0.3)
        MainFrame.Visible = false
        MinimizeIcon.Visible = true
        TweenService:Create(MinimizeIcon, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 48, 0, 48)
        }):Play()
    end)

    MinimizeIcon.Activated:Connect(function()
        TweenService:Create(MinimizeIcon, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        task.wait(0.2)
        MinimizeIcon.Visible = false
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 650, 0, 420), GroupTransparency = 0
        }):Play()
    end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.Position = UDim2.new(0, 0, 0, 45)
    Sidebar.Size = UDim2.new(0, 150, 1, -45)
    Sidebar.BorderSizePixel = 0
    
    local SidebarLine = Instance.new("Frame")
    SidebarLine.Parent = Sidebar
    SidebarLine.BackgroundColor3 = Theme.Stroke
    SidebarLine.Position = UDim2.new(1, 0, 0, 0)
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarLine.BorderSizePixel = 0

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.Size = UDim2.new(1, 0, 1, -15)
    TabContainer.ScrollBarThickness = 0

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabContainer
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 165, 0, 45)
    ContentContainer.Size = UDim2.new(1, -180, 1, -55)

    local WindowObject = {}
    local CurrentTab = nil

    function WindowObject:CreateTab(TabName, IconName)
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabContainer
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(0.9, 0, 0, 36)
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Text = (IconName and Icons[IconName]) and ("       " .. TabName) or ("   " .. TabName)
        TabButton.TextColor3 = Theme.TextDim
        TabButton.TextSize = 13
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        ApplyCorner(TabButton, 6)

        local TabIndicator = Instance.new("Frame")
        TabIndicator.Parent = TabButton
        TabIndicator.BackgroundColor3 = Theme.Accent
        TabIndicator.Position = UDim2.new(0, 0, 0.5, 0)
        TabIndicator.Size = UDim2.new(0, 3, 0, 0)
        TabIndicator.AnchorPoint = Vector2.new(0, 0.5)
        ApplyCorner(TabIndicator, 2)

        if IconName and Icons[IconName] then
            local TabIcon = Instance.new("ImageLabel")
            TabIcon.Parent = TabButton
            TabIcon.BackgroundTransparency = 1
            TabIcon.Position = UDim2.new(0, 8, 0.5, -8)
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
        TabPage.ScrollBarImageColor3 = Theme.Stroke
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

        Instance.new("UIListLayout", LeftColumn).Padding = UDim.new(0, 8)
        Instance.new("UIListLayout", RightColumn).Padding = UDim.new(0, 8)

        local function ActivateTab()
            if CurrentTab then
                TweenService:Create(CurrentTab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Theme.TextDim}):Play()
                TweenService:Create(CurrentTab.Indicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 0)}):Play()
                CurrentTab.Page.Visible = false
                if CurrentTab.Button:FindFirstChild("ImageLabel") then
                    TweenService:Create(CurrentTab.Button.ImageLabel, TweenInfo.new(0.2), {ImageColor3 = Theme.TextDim}):Play()
                end
            end

            CurrentTab = {Button = TabButton, Indicator = TabIndicator, Page = TabPage}
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, TextColor3 = Theme.Text}):Play()
            TweenService:Create(TabIndicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 18)}):Play()
            TabPage.Visible = true

            if TabButton:FindFirstChild("ImageLabel") then
                TweenService:Create(TabButton.ImageLabel, TweenInfo.new(0.2), {ImageColor3 = Theme.Accent}):Play()
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
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.Text = SectionTitle
            SectionLabel.TextColor3 = Theme.Text
            SectionLabel.TextSize = 14
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left

            local SectionLine = Instance.new("Frame")
            SectionLine.Parent = SectionFrame
            SectionLine.BackgroundColor3 = Theme.Accent
            SectionLine.BorderSizePixel = 0
            SectionLine.Position = UDim2.new(0, 0, 0, 32)
            SectionLine.Size = UDim2.new(1, 0, 0, 1)

            local LineGradient = Instance.new("UIGradient")
            LineGradient.Parent = SectionLine
            LineGradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.8, 0.8),
                NumberSequenceKeypoint.new(1, 1)
            })
        end

        function TabElements:CreateLabel(LabelText, Side)
            local Label = Instance.new("TextLabel")
            Label.Parent = GetTargetColumn(Side)
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.Font = Enum.Font.Gotham
            Label.Text = LabelText
            Label.TextColor3 = Theme.TextDim
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
        end

        function TabElements:CreateButton(ButtonText, Callback, Side)
            local Button = Instance.new("TextButton")
            Button.Parent = GetTargetColumn(Side)
            Button.BackgroundColor3 = Theme.ElementBg
            Button.Size = UDim2.new(1, 0, 0, 36)
            Button.Font = Enum.Font.GothamMedium
            Button.Text = ButtonText
            Button.TextColor3 = Theme.Text
            Button.TextSize = 13
            ApplyCorner(Button)
            ApplyStroke(Button)
            AddHoverEffect(Button, Theme.ElementBg, Theme.ElementHover)

            Button.Activated:Connect(function()
                local ClickTween = TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0.95, 0, 0, 32)})
                ClickTween:Play()
                ClickTween.Completed:Wait()
                TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                pcall(Callback)
            end)
        end

        function TabElements:CreateToggle(ToggleText, DefaultState, Callback, Side)
            local CurrentState = DefaultState or false

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Parent = GetTargetColumn(Side)
            ToggleButton.BackgroundColor3 = Theme.ElementBg
            ToggleButton.Size = UDim2.new(1, 0, 0, 36)
            ToggleButton.Text = ""
            ApplyCorner(ToggleButton)
            ApplyStroke(ToggleButton)
            AddHoverEffect(ToggleButton, Theme.ElementBg, Theme.ElementHover)

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Parent = ToggleButton
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Font = Enum.Font.GothamMedium
            ToggleLabel.Text = ToggleText
            ToggleLabel.TextColor3 = Theme.Text
            ToggleLabel.TextSize = 13
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

            local ToggleBg = Instance.new("Frame")
            ToggleBg.Parent = ToggleButton
            ToggleBg.BackgroundColor3 = CurrentState and Theme.Accent or Theme.Background
            ToggleBg.Position = UDim2.new(1, -40, 0.5, -9)
            ToggleBg.Size = UDim2.new(0, 32, 0, 18)
            ApplyCorner(ToggleBg, 9)
            ApplyStroke(ToggleBg)

            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Parent = ToggleBg
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.Position = CurrentState and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            ToggleCircle.Size = UDim2.new(0, 14, 0, 14)
            ApplyCorner(ToggleCircle, 7)

            ToggleButton.Activated:Connect(function()
                CurrentState = not CurrentState
                TweenService:Create(ToggleBg, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
                    BackgroundColor3 = CurrentState and Theme.Accent or Theme.Background
                }):Play()
                TweenService:Create(ToggleCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
                    Position = CurrentState and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                }):Play()
                pcall(Callback, CurrentState)
            end)
        end

        function TabElements:CreateSlider(SliderText, MinValue, MaxValue, DefaultValue, Callback, Side)
            local CurrentValue = DefaultValue or MinValue

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = GetTargetColumn(Side)
            SliderFrame.BackgroundColor3 = Theme.ElementBg
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            ApplyCorner(SliderFrame)
            ApplyStroke(SliderFrame)

            local SliderTitle = Instance.new("TextLabel")
            SliderTitle.Parent = SliderFrame
            SliderTitle.BackgroundTransparency = 1
            SliderTitle.Position = UDim2.new(0, 12, 0, 6)
            SliderTitle.Size = UDim2.new(0.5, 0, 0, 15)
            SliderTitle.Font = Enum.Font.GothamMedium
            SliderTitle.Text = SliderText
            SliderTitle.TextColor3 = Theme.Text
            SliderTitle.TextSize = 13
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

            local ValueDisplay = Instance.new("TextLabel")
            ValueDisplay.Parent = SliderFrame
            ValueDisplay.BackgroundTransparency = 1
            ValueDisplay.Position = UDim2.new(0.5, -12, 0, 6)
            ValueDisplay.Size = UDim2.new(0.5, 0, 0, 15)
            ValueDisplay.Font = Enum.Font.GothamBold
            ValueDisplay.Text = tostring(CurrentValue)
            ValueDisplay.TextColor3 = Theme.Accent
            ValueDisplay.TextSize = 13
            ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right

            local SliderBackground = Instance.new("TextButton")
            SliderBackground.Parent = SliderFrame
            SliderBackground.BackgroundColor3 = Theme.Background
            SliderBackground.Position = UDim2.new(0, 12, 0, 30)
            SliderBackground.Size = UDim2.new(1, -24, 0, 8)
            SliderBackground.Text = ""
            ApplyCorner(SliderBackground, 4)
            ApplyStroke(SliderBackground)

            local SliderFill = Instance.new("Frame")
            SliderFill.Parent = SliderBackground
            SliderFill.BackgroundColor3 = Theme.Accent
            SliderFill.Size = UDim2.new((CurrentValue - MinValue) / (MaxValue - MinValue), 0, 1, 0)
            ApplyCorner(SliderFill, 4)

            local IsDragging = false

            local function UpdateSliderPosition(Input)
                local RelativePosition = math.clamp((Input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
                CurrentValue = math.floor(MinValue + ((MaxValue - MinValue) * RelativePosition))
                ValueDisplay.Text = tostring(CurrentValue)
                TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(RelativePosition, 0, 1, 0)}):Play()
                pcall(Callback, CurrentValue)
            end

            SliderBackground.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    IsDragging = true; UpdateSliderPosition(Input)
                end
            end)
            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    IsDragging = false
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
            DropdownFrame.Size = UDim2.new(1, 0, 0, 36)
            ApplyCorner(DropdownFrame)
            ApplyStroke(DropdownFrame)

            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Parent = DropdownFrame
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Size = UDim2.new(1, 0, 0, 36)
            DropdownButton.Font = Enum.Font.GothamMedium
            DropdownButton.Text = "   " .. DropdownText
            DropdownButton.TextColor3 = Theme.Text
            DropdownButton.TextSize = 13
            DropdownButton.TextXAlignment = Enum.TextXAlignment.Left

            local Arrow = Instance.new("TextLabel")
            Arrow.Parent = DropdownButton
            Arrow.BackgroundTransparency = 1
            Arrow.Position = UDim2.new(1, -25, 0, 0)
            Arrow.Size = UDim2.new(0, 20, 1, 0)
            Arrow.Font = Enum.Font.GothamBold
            Arrow.Text = "+"
            Arrow.TextColor3 = Theme.TextDim
            Arrow.TextSize = 16

            local IsOpen = false

            DropdownButton.Activated:Connect(function()
                IsOpen = not IsOpen
                Arrow.Text = IsOpen and "-" or "+"
                local TargetHeight = IsOpen and (36 + (#OptionsList * 28) + 5) or 36
                TweenService:Create(DropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, TargetHeight)}):Play()
            end)

            local YOffset = 36
            for _, OptionString in ipairs(OptionsList) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Parent = DropdownFrame
                OptionButton.BackgroundTransparency = 1
                OptionButton.Position = UDim2.new(0, 0, 0, YOffset)
                OptionButton.Size = UDim2.new(1, 0, 0, 28)
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Text = "     " .. OptionString
                OptionButton.TextColor3 = Theme.TextDim
                OptionButton.TextSize = 12
                OptionButton.TextXAlignment = Enum.TextXAlignment.Left
                AddHoverEffect(OptionButton, Color3.fromRGB(0,0,0,1), Theme.Background)

                OptionButton.Activated:Connect(function()
                    IsOpen = false
                    Arrow.Text = "+"
                    DropdownButton.Text = "   " .. DropdownText .. ": " .. OptionString
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                    pcall(Callback, OptionString)
                end)
                YOffset = YOffset + 28
            end
        end

        function TabElements:CreateTextbox(TextboxText, Placeholder, Callback, Side)
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Parent = GetTargetColumn(Side)
            TextboxFrame.BackgroundColor3 = Theme.ElementBg
            TextboxFrame.Size = UDim2.new(1, 0, 0, 55)
            ApplyCorner(TextboxFrame)
            ApplyStroke(TextboxFrame)

            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Parent = TextboxFrame
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Position = UDim2.new(0, 12, 0, 6)
            TextboxLabel.Size = UDim2.new(1, -24, 0, 15)
            TextboxLabel.Font = Enum.Font.GothamMedium
            TextboxLabel.Text = TextboxText
            TextboxLabel.TextColor3 = Theme.Text
            TextboxLabel.TextSize = 13
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left

            local InputField = Instance.new("TextBox")
            InputField.Parent = TextboxFrame
            InputField.BackgroundColor3 = Theme.Background
            InputField.Position = UDim2.new(0, 12, 0, 25)
            InputField.Size = UDim2.new(1, -24, 0, 22)
            InputField.Font = Enum.Font.Gotham
            InputField.PlaceholderText = Placeholder
            InputField.Text = ""
            InputField.TextColor3 = Theme.Accent
            InputField.TextSize = 12
            ApplyCorner(InputField, 4)
            ApplyStroke(InputField)

            InputField.FocusLost:Connect(function() pcall(Callback, InputField.Text) end)
        end

        function TabElements:CreateKeybind(KeybindText, DefaultKey, Callback, Side)
            local CurrentKey = DefaultKey

            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Parent = GetTargetColumn(Side)
            KeybindFrame.BackgroundColor3 = Theme.ElementBg
            KeybindFrame.Size = UDim2.new(1, 0, 0, 36)
            ApplyCorner(KeybindFrame)
            ApplyStroke(KeybindFrame)

            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Parent = KeybindFrame
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Position = UDim2.new(0, 12, 0, 0)
            KeybindLabel.Size = UDim2.new(1, -70, 1, 0)
            KeybindLabel.Font = Enum.Font.GothamMedium
            KeybindLabel.Text = KeybindText
            KeybindLabel.TextColor3 = Theme.Text
            KeybindLabel.TextSize = 13
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

            local KeyButton = Instance.new("TextButton")
            KeyButton.Parent = KeybindFrame
            KeyButton.BackgroundColor3 = Theme.Background
            KeyButton.Position = UDim2.new(1, -70, 0.5, -12)
            KeyButton.Size = UDim2.new(0, 60, 0, 24)
            KeyButton.Font = Enum.Font.GothamBold
            KeyButton.Text = CurrentKey.Name
            KeyButton.TextColor3 = Theme.Accent
            KeyButton.TextSize = 12
            ApplyCorner(KeyButton, 4)
            ApplyStroke(KeyButton)

            local IsWaitingForKey = false

            KeyButton.Activated:Connect(function()
                KeyButton.Text = "..."
                IsWaitingForKey = true
            end)

            UserInputService.InputBegan:Connect(function(Input, GameProcessed)
                if IsWaitingForKey and Input.UserInputType == Enum.UserInputType.Keyboard then
                    CurrentKey = Input.KeyCode
                    KeyButton.Text = CurrentKey.Name
                    IsWaitingForKey = false
                elseif not GameProcessed and Input.KeyCode == CurrentKey and not IsWaitingForKey then
                    pcall(Callback)
                end
            end)
        end

        function TabElements:CreateColorPicker(PickerText, DefaultColor, Callback, Side)
            local CurrentColor = DefaultColor or Color3.fromRGB(255, 255, 255)

            local PickerFrame = Instance.new("Frame")
            PickerFrame.Parent = GetTargetColumn(Side)
            PickerFrame.BackgroundColor3 = Theme.ElementBg
            PickerFrame.ClipsDescendants = true
            PickerFrame.Size = UDim2.new(1, 0, 0, 36)
            ApplyCorner(PickerFrame)
            ApplyStroke(PickerFrame)

            local MainPickerButton = Instance.new("TextButton")
            MainPickerButton.Parent = PickerFrame
            MainPickerButton.BackgroundTransparency = 1
            MainPickerButton.Size = UDim2.new(1, 0, 0, 36)
            MainPickerButton.Text = ""

            local PickerLabel = Instance.new("TextLabel")
            PickerLabel.Parent = MainPickerButton
            PickerLabel.BackgroundTransparency = 1
            PickerLabel.Position = UDim2.new(0, 12, 0, 0)
            PickerLabel.Size = UDim2.new(1, -40, 1, 0)
            PickerLabel.Font = Enum.Font.GothamMedium
            PickerLabel.Text = PickerText
            PickerLabel.TextColor3 = Theme.Text
            PickerLabel.TextSize = 13
            PickerLabel.TextXAlignment = Enum.TextXAlignment.Left

            local ColorDisplay = Instance.new("Frame")
            ColorDisplay.Parent = MainPickerButton
            ColorDisplay.BackgroundColor3 = CurrentColor
            ColorDisplay.Position = UDim2.new(1, -34, 0.5, -9)
            ColorDisplay.Size = UDim2.new(0, 22, 0, 18)
            ApplyCorner(ColorDisplay, 4)
            ApplyStroke(ColorDisplay, Color3.fromRGB(0,0,0), 0.5)

            local IsOpen = false

            MainPickerButton.Activated:Connect(function()
                IsOpen = not IsOpen
                local TargetHeight = IsOpen and 90 or 36
                TweenService:Create(PickerFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, TargetHeight)}):Play()
            end)

            local function CreateMiniSlider(YPosition, SliderColor)
                local SliderBg = Instance.new("TextButton")
                SliderBg.Parent = PickerFrame
                SliderBg.BackgroundColor3 = Theme.Background
                SliderBg.Position = UDim2.new(0, 12, 0, YPosition)
                SliderBg.Size = UDim2.new(1, -24, 0, 8)
                SliderBg.Text = ""
                ApplyCorner(SliderBg)

                local SliderFill = Instance.new("Frame")
                SliderFill.Parent = SliderBg
                SliderFill.BackgroundColor3 = SliderColor
                SliderFill.Size = UDim2.new(1, 0, 1, 0)
                ApplyCorner(SliderFill)

                return SliderBg, SliderFill
            end

            local RedBg, RedFill = CreateMiniSlider(44, Color3.fromRGB(255, 60, 60))
            local GreenBg, GreenFill = CreateMiniSlider(58, Color3.fromRGB(60, 255, 60))
            local BlueBg, BlueFill = CreateMiniSlider(72, Color3.fromRGB(60, 120, 255))

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
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        IsDragging = true; UpdateColor(Input)
                    end
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