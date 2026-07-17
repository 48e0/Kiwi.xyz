local KiwiLibrary = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Success, Result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/KaiStudio0/Icons/refs/heads/main/Icons.lua"))()
end)
local Icons = Success and Result or {}

local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Sidebar = Color3.fromRGB(22, 22, 22),
    ElementBg = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(46, 204, 113),
    Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(140, 140, 140)
}

local function ApplyCorner(InstanceTarget, RadiusValue)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, RadiusValue or 4)
    UICorner.Parent = InstanceTarget
end

local function MakeDraggable(DragArea, TargetObject)
    local IsDragging = false
    local DragInput
    local DragStart
    local StartPosition

    DragArea.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            IsDragging = true
            DragStart = Input.Position
            StartPosition = TargetObject.Position
            
            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    IsDragging = false
                end
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
                StartPosition.X.Scale, 
                StartPosition.X.Offset + Delta.X, 
                StartPosition.Y.Scale, 
                StartPosition.Y.Offset + Delta.Y
            )
        end
    end)
end

function KiwiLibrary:CreateWindow()
    for _, GUI in pairs(CoreGui:GetChildren()) do
        if GUI.Name == "KiwiUI" then
            GUI:Destroy()
        end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KiwiUI"
    ScreenGui.Parent = CoreGui

    -- CAMBIO A CANVASGROUP PARA ARREGLAR EL CORTE DEL BORDE
    local MainFrame = Instance.new("CanvasGroup")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    -- Ajustamos AnchorPoint al centro para que la animación de Pop-in se vea genial
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    -- Estado inicial para la Animación de Inicio
    MainFrame.Size = UDim2.new(0, 450, 0, 300)
    MainFrame.GroupTransparency = 1
    ApplyCorner(MainFrame, 6)

    -- Animación de Inicio (Aparece y crece suavemente)
    TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 600, 0, 400),
        GroupTransparency = 0
    }):Play()

    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Parent = MainFrame
    Topbar.BackgroundTransparency = 1
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    MakeDraggable(Topbar, MainFrame)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = Topbar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.RichText = true
    TitleLabel.Text = "<font color='#2ecc71'>Kiwi</font><font color='#8c8c8c'>.xyz</font>"
    TitleLabel.TextSize = 15
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local MinimizeIcon = Instance.new("TextButton")
    MinimizeIcon.Parent = ScreenGui
    MinimizeIcon.BackgroundColor3 = Theme.Background
    MinimizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    MinimizeIcon.Position = UDim2.new(0.5, 0, 0, 45)
    MinimizeIcon.Size = UDim2.new(0, 0, 0, 0) -- Empieza en 0 para animación
    MinimizeIcon.Visible = false
    MinimizeIcon.Font = Enum.Font.Bodoni -- FUENTE ELEGANTE (Serif)
    MinimizeIcon.Text = "K"
    MinimizeIcon.TextColor3 = Theme.Accent
    MinimizeIcon.TextSize = 28
    ApplyCorner(MinimizeIcon, 8)
    MakeDraggable(MinimizeIcon, MinimizeIcon)
    
    local MinStroke = Instance.new("UIStroke")
    MinStroke.Parent = MinimizeIcon
    MinStroke.Color = Theme.Accent
    MinStroke.Thickness = 2
    MinStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = Topbar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -25, 0, 10)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Theme.TextDim
    CloseButton.TextSize = 20

    -- Animación de Cierre Completo
    CloseButton.Activated:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 450, 0, 300),
            GroupTransparency = 1
        }):Play()
        task.wait(0.3)
        ScreenGui:Destroy()
    end)

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Parent = Topbar
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -48, 0, 10)
    MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Theme.TextDim
    MinimizeButton.TextSize = 20

    -- Animación al Minimizar
    MinimizeButton.Activated:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 450, 0, 300),
            GroupTransparency = 1
        }):Play()
        task.wait(0.3)
        MainFrame.Visible = false
        
        MinimizeIcon.Visible = true
        TweenService:Create(MinimizeIcon, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 45, 0, 45)
        }):Play()
    end)

    -- Animación al Maximizar (Abrir desde la K)
    MinimizeIcon.Activated:Connect(function()
        TweenService:Create(MinimizeIcon, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        task.wait(0.2)
        MinimizeIcon.Visible = false
        
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 600, 0, 400),
            GroupTransparency = 0
        }):Play()
    end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.Size = UDim2.new(0, 140, 1, -40)
    Sidebar.BorderSizePixel = 0

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.Size = UDim2.new(1, 0, 1, -10)
    TabContainer.ScrollBarThickness = 0

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabContainer
    TabListLayout.Padding = UDim.new(0, 2)

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 150, 0, 40)
    ContentContainer.Size = UDim2.new(1, -160, 1, -50)

    local WindowObject = {}
    local CurrentTab = nil

    function WindowObject:CreateTab(TabName, IconName)
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabContainer
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, 0, 0, 32)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = (IconName and Icons[IconName]) and ("       " .. TabName) or ("   " .. TabName)
        TabButton.TextColor3 = Theme.TextDim
        TabButton.TextSize = 13
        TabButton.TextXAlignment = Enum.TextXAlignment.Left

        if IconName and Icons[IconName] then
            local TabIcon = Instance.new("ImageLabel")
            TabIcon.Parent = TabButton
            TabIcon.BackgroundTransparency = 1
            TabIcon.Position = UDim2.new(0, 8, 0.5, -8)
            TabIcon.Size = UDim2.new(0, 16, 0, 16)
            TabIcon.Image = Icons[IconName]
            TabIcon.ImageColor3 = Theme.TextDim
        end

        local TabIndicator = Instance.new("Frame")
        TabIndicator.Parent = TabButton
        TabIndicator.BackgroundColor3 = Theme.Accent
        TabIndicator.Position = UDim2.new(0, 0, 0.5, 0)
        TabIndicator.Size = UDim2.new(0, 2, 0, 0)
        TabIndicator.AnchorPoint = Vector2.new(0, 0.5)
        TabIndicator.BorderSizePixel = 0

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Parent = ContentContainer
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.ScrollBarThickness = 1
        TabPage.ScrollBarImageColor3 = Theme.Accent
        TabPage.Visible = false

        local LeftColumn = Instance.new("Frame")
        LeftColumn.Parent = TabPage
        LeftColumn.BackgroundTransparency = 1
        LeftColumn.Size = UDim2.new(0.48, 0, 1, 0)

        local RightColumn = Instance.new("Frame")
        RightColumn.Parent = TabPage
        RightColumn.BackgroundTransparency = 1
        RightColumn.Position = UDim2.new(0.52, 0, 0, 0)
        RightColumn.Size = UDim2.new(0.48, 0, 1, 0)

        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.Parent = LeftColumn
        LeftLayout.Padding = UDim.new(0, 6)

        local RightLayout = Instance.new("UIListLayout")
        RightLayout.Parent = RightColumn
        RightLayout.Padding = UDim.new(0, 6)

        TabButton.Activated:Connect(function()
            if CurrentTab then
                CurrentTab.Button.TextColor3 = Theme.TextDim
                TweenService:Create(CurrentTab.Indicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 2, 0, 0)}):Play()
                CurrentTab.Page.Visible = false
                if CurrentTab.Button:FindFirstChild("ImageLabel") then
                    CurrentTab.Button.ImageLabel.ImageColor3 = Theme.TextDim
                end
            end

            CurrentTab = {Button = TabButton, Indicator = TabIndicator, Page = TabPage}
            TabButton.TextColor3 = Theme.Text
            TweenService:Create(TabIndicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 2, 0, 18)}):Play()
            TabPage.Visible = true

            if TabButton:FindFirstChild("ImageLabel") then
                TabButton.ImageLabel.ImageColor3 = Theme.Accent
            end
        end)

        if not CurrentTab then
            TabButton.TextColor3 = Theme.Text
            TabIndicator.Size = UDim2.new(0, 2, 0, 18)
            TabPage.Visible = true
            if TabButton:FindFirstChild("ImageLabel") then
                TabButton.ImageLabel.ImageColor3 = Theme.Accent
            end
            CurrentTab = {Button = TabButton, Indicator = TabIndicator, Page = TabPage}
        end

        local TabElements = {}

        local function GetTargetColumn(Side)
            return (Side == "Right") and RightColumn or LeftColumn
        end

        function TabElements:CreateSection(SectionTitle, Side)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Parent = GetTargetColumn(Side)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Size = UDim2.new(1, 0, 0, 30)

            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Parent = SectionFrame
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Size = UDim2.new(1, 0, 0, 20)
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.Text = SectionTitle
            SectionLabel.TextColor3 = Theme.Text
            SectionLabel.TextSize = 13
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left

            local SectionLine = Instance.new("Frame")
            SectionLine.Parent = SectionFrame
            SectionLine.BackgroundColor3 = Theme.Accent
            SectionLine.BorderSizePixel = 0
            SectionLine.Position = UDim2.new(0, 0, 0, 22)
            SectionLine.Size = UDim2.new(1, 0, 0, 1)

            local LineGradient = Instance.new("UIGradient")
            LineGradient.Parent = SectionLine
            LineGradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
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
            Label.TextColor3 = Theme.Text
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
        end

        function TabElements:CreateButton(ButtonText, Callback, Side)
            local Button = Instance.new("TextButton")
            Button.Parent = GetTargetColumn(Side)
            Button.BackgroundColor3 = Theme.ElementBg
            Button.Size = UDim2.new(1, 0, 0, 32)
            Button.Font = Enum.Font.Gotham
            Button.Text = ButtonText
            Button.TextColor3 = Theme.Text
            Button.TextSize = 13
            ApplyCorner(Button)

            Button.Activated:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent}):Play()
                task.wait(0.1)
                TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Theme.ElementBg}):Play()
                pcall(Callback)
            end)
        end

        function TabElements:CreateToggle(ToggleText, DefaultState, Callback, Side)
            local CurrentState = DefaultState or false

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Parent = GetTargetColumn(Side)
            ToggleButton.BackgroundColor3 = Theme.ElementBg
            ToggleButton.Size = UDim2.new(1, 0, 0, 32)
            ToggleButton.Text = ""
            ApplyCorner(ToggleButton)

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Parent = ToggleButton
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.Size = UDim2.new(1, -40, 1, 0)
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.Text = ToggleText
            ToggleLabel.TextColor3 = Theme.Text
            ToggleLabel.TextSize = 13
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Parent = ToggleButton
            ToggleIndicator.BackgroundColor3 = CurrentState and Theme.Accent or Theme.Background
            ToggleIndicator.Position = UDim2.new(1, -26, 0.5, -8)
            ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
            ApplyCorner(ToggleIndicator)

            ToggleButton.Activated:Connect(function()
                CurrentState = not CurrentState
                local TargetColor = CurrentState and Theme.Accent or Theme.Background
                TweenService:Create(ToggleIndicator, TweenInfo.new(0.15), {BackgroundColor3 = TargetColor}):Play()
                pcall(Callback, CurrentState)
            end)
        end

        function TabElements:CreateSlider(SliderText, MinValue, MaxValue, DefaultValue, Callback, Side)
            local CurrentValue = DefaultValue or MinValue

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = GetTargetColumn(Side)
            SliderFrame.BackgroundColor3 = Theme.ElementBg
            SliderFrame.Size = UDim2.new(1, 0, 0, 45)
            ApplyCorner(SliderFrame)

            local SliderTitle = Instance.new("TextLabel")
            SliderTitle.Parent = SliderFrame
            SliderTitle.BackgroundTransparency = 1
            SliderTitle.Position = UDim2.new(0, 10, 0, 4)
            SliderTitle.Size = UDim2.new(0.5, 0, 0, 15)
            SliderTitle.Font = Enum.Font.Gotham
            SliderTitle.Text = SliderText
            SliderTitle.TextColor3 = Theme.Text
            SliderTitle.TextSize = 12
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

            local ValueDisplay = Instance.new("TextLabel")
            ValueDisplay.Parent = SliderFrame
            ValueDisplay.BackgroundTransparency = 1
            ValueDisplay.Position = UDim2.new(0.5, -10, 0, 4)
            ValueDisplay.Size = UDim2.new(0.5, 0, 0, 15)
            ValueDisplay.Font = Enum.Font.Gotham
            ValueDisplay.Text = tostring(CurrentValue)
            ValueDisplay.TextColor3 = Theme.TextDim
            ValueDisplay.TextSize = 12
            ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right

            local SliderBackground = Instance.new("TextButton")
            SliderBackground.Parent = SliderFrame
            SliderBackground.BackgroundColor3 = Theme.Background
            SliderBackground.Position = UDim2.new(0, 10, 0, 25)
            SliderBackground.Size = UDim2.new(1, -20, 0, 6)
            SliderBackground.Text = ""
            ApplyCorner(SliderBackground, 6)

            local SliderFill = Instance.new("Frame")
            SliderFill.Parent = SliderBackground
            SliderFill.BackgroundColor3 = Theme.Accent
            SliderFill.Size = UDim2.new((CurrentValue - MinValue) / (MaxValue - MinValue), 0, 1, 0)
            ApplyCorner(SliderFill, 6)

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
                    IsDragging = true
                    UpdateSliderPosition(Input)
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
            DropdownFrame.Size = UDim2.new(1, 0, 0, 32)
            ApplyCorner(DropdownFrame)

            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Parent = DropdownFrame
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Size = UDim2.new(1, 0, 0, 32)
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.Text = "  " .. DropdownText
            DropdownButton.TextColor3 = Theme.Text
            DropdownButton.TextSize = 13
            DropdownButton.TextXAlignment = Enum.TextXAlignment.Left

            local IsOpen = false

            DropdownButton.Activated:Connect(function()
                IsOpen = not IsOpen
                local TargetHeight = IsOpen and (32 + (#OptionsList * 25) + 5) or 32
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, TargetHeight)}):Play()
            end)

            local YOffset = 32
            for _, OptionString in ipairs(OptionsList) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Parent = DropdownFrame
                OptionButton.BackgroundTransparency = 1
                OptionButton.Position = UDim2.new(0, 0, 0, YOffset)
                OptionButton.Size = UDim2.new(1, 0, 0, 25)
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Text = "  - " .. OptionString
                OptionButton.TextColor3 = Theme.TextDim
                OptionButton.TextSize = 12
                OptionButton.TextXAlignment = Enum.TextXAlignment.Left

                OptionButton.Activated:Connect(function()
                    IsOpen = false
                    DropdownButton.Text = "  " .. DropdownText .. ": " .. OptionString
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 32)}):Play()
                    pcall(Callback, OptionString)
                end)

                YOffset = YOffset + 25
            end
        end

        function TabElements:CreateTextbox(TextboxText, Placeholder, Callback, Side)
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Parent = GetTargetColumn(Side)
            TextboxFrame.BackgroundColor3 = Theme.ElementBg
            TextboxFrame.Size = UDim2.new(1, 0, 0, 45)
            ApplyCorner(TextboxFrame)

            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Parent = TextboxFrame
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Position = UDim2.new(0, 10, 0, 4)
            TextboxLabel.Size = UDim2.new(1, -20, 0, 15)
            TextboxLabel.Font = Enum.Font.Gotham
            TextboxLabel.Text = TextboxText
            TextboxLabel.TextColor3 = Theme.Text
            TextboxLabel.TextSize = 12
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left

            local InputField = Instance.new("TextBox")
            InputField.Parent = TextboxFrame
            InputField.BackgroundColor3 = Theme.Background
            InputField.Position = UDim2.new(0, 10, 0, 22)
            InputField.Size = UDim2.new(1, -20, 0, 18)
            InputField.Font = Enum.Font.Gotham
            InputField.PlaceholderText = Placeholder
            InputField.Text = ""
            InputField.TextColor3 = Theme.Text
            InputField.TextSize = 11
            ApplyCorner(InputField, 4)

            InputField.FocusLost:Connect(function()
                pcall(Callback, InputField.Text)
            end)
        end

        function TabElements:CreateKeybind(KeybindText, DefaultKey, Callback, Side)
            local CurrentKey = DefaultKey

            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Parent = GetTargetColumn(Side)
            KeybindFrame.BackgroundColor3 = Theme.ElementBg
            KeybindFrame.Size = UDim2.new(1, 0, 0, 32)
            ApplyCorner(KeybindFrame)

            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Parent = KeybindFrame
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Position = UDim2.new(0, 10, 0, 0)
            KeybindLabel.Size = UDim2.new(1, -70, 1, 0)
            KeybindLabel.Font = Enum.Font.Gotham
            KeybindLabel.Text = KeybindText
            KeybindLabel.TextColor3 = Theme.Text
            KeybindLabel.TextSize = 13
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

            local KeyButton = Instance.new("TextButton")
            KeyButton.Parent = KeybindFrame
            KeyButton.BackgroundColor3 = Theme.Background
            KeyButton.Position = UDim2.new(1, -60, 0.5, -10)
            KeyButton.Size = UDim2.new(0, 50, 0, 20)
            KeyButton.Font = Enum.Font.Gotham
            KeyButton.Text = CurrentKey.Name
            KeyButton.TextColor3 = Theme.Accent
            KeyButton.TextSize = 12
            ApplyCorner(KeyButton)

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
            PickerFrame.Size = UDim2.new(1, 0, 0, 32)
            ApplyCorner(PickerFrame)

            local MainPickerButton = Instance.new("TextButton")
            MainPickerButton.Parent = PickerFrame
            MainPickerButton.BackgroundTransparency = 1
            MainPickerButton.Size = UDim2.new(1, 0, 0, 32)
            MainPickerButton.Text = ""

            local PickerLabel = Instance.new("TextLabel")
            PickerLabel.Parent = MainPickerButton
            PickerLabel.BackgroundTransparency = 1
            PickerLabel.Position = UDim2.new(0, 10, 0, 0)
            PickerLabel.Size = UDim2.new(1, -40, 1, 0)
            PickerLabel.Font = Enum.Font.Gotham
            PickerLabel.Text = PickerText
            PickerLabel.TextColor3 = Theme.Text
            PickerLabel.TextSize = 13
            PickerLabel.TextXAlignment = Enum.TextXAlignment.Left

            local ColorDisplay = Instance.new("Frame")
            ColorDisplay.Parent = MainPickerButton
            ColorDisplay.BackgroundColor3 = CurrentColor
            ColorDisplay.Position = UDim2.new(1, -30, 0.5, -8)
            ColorDisplay.Size = UDim2.new(0, 20, 0, 16)
            ApplyCorner(ColorDisplay)

            local IsOpen = false

            MainPickerButton.Activated:Connect(function()
                IsOpen = not IsOpen
                local TargetHeight = IsOpen and 80 or 32
                TweenService:Create(PickerFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, TargetHeight)}):Play()
            end)

            local function CreateMiniSlider(YPosition, SliderColor)
                local SliderBg = Instance.new("TextButton")
                SliderBg.Parent = PickerFrame
                SliderBg.BackgroundColor3 = Theme.Background
                SliderBg.Position = UDim2.new(0, 10, 0, YPosition)
                SliderBg.Size = UDim2.new(1, -20, 0, 8)
                SliderBg.Text = ""
                ApplyCorner(SliderBg)

                local SliderFill = Instance.new("Frame")
                SliderFill.Parent = SliderBg
                SliderFill.BackgroundColor3 = SliderColor
                SliderFill.Size = UDim2.new(1, 0, 1, 0)
                ApplyCorner(SliderFill)

                return SliderBg, SliderFill
            end

            local RedBg, RedFill = CreateMiniSlider(38, Color3.fromRGB(255, 80, 80))
            local GreenBg, GreenFill = CreateMiniSlider(52, Color3.fromRGB(80, 255, 80))
            local BlueBg, BlueFill = CreateMiniSlider(66, Color3.fromRGB(80, 80, 255))

            local function BindColorSlider(Background, Fill)
                local IsDragging = false

                local function UpdateColor(Input)
                    local RelativePos = math.clamp((Input.Position.X - Background.AbsolutePosition.X) / Background.AbsoluteSize.X, 0, 1)
                    Fill.Size = UDim2.new(RelativePos, 0, 1, 0)
                    
                    CurrentColor = Color3.fromRGB(
                        RedFill.Size.X.Scale * 255, 
                        GreenFill.Size.X.Scale * 255, 
                        BlueFill.Size.X.Scale * 255
                    )
                    
                    ColorDisplay.BackgroundColor3 = CurrentColor
                    pcall(Callback, CurrentColor)
                end

                Background.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        IsDragging = true
                        UpdateColor(Input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        IsDragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(Input)
                    if IsDragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateColor(Input)
                    end
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