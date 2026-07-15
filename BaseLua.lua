local KiwiLibrary = {}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Sistema seguro para cargar iconos
local success, result = pcall(function()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/KaiStudio0/Icons/refs/heads/main/Icons.lua"))()
end)
local IconsList = (success and type(result) == "table") and result or {}

local function GetIcon(iconName)
	if type(IconsList) == "table" and IconsList[iconName] then
		return IconsList[iconName]
	end
	return ""
end

-- ==========================================
-- CONSTRUCTOR DE LA VENTANA
-- ==========================================
function KiwiLibrary:CreateWindow(config)
	config = config or {}
	local titleText = config.Title or "Kiwi.xyz"
	local useKey = config.KeySystem or false
	local correctKey = config.Key or "1234"
	
	if CoreGui:FindFirstChild("KiwiUI") then
		CoreGui.KiwiUI:Destroy()
	end

	local KiwiUI = Instance.new("ScreenGui")
	KiwiUI.Name = "KiwiUI"
	KiwiUI.Parent = CoreGui
	KiwiUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	-- Contenedor de Notificaciones
	local NotificationContainer = Instance.new("Frame")
	NotificationContainer.Name = "NotificationContainer"
	NotificationContainer.Parent = KiwiUI
	NotificationContainer.BackgroundTransparency = 1
	NotificationContainer.Position = UDim2.new(1, -320, 1, -20)
	NotificationContainer.Size = UDim2.new(0, 300, 1, 0)
	NotificationContainer.AnchorPoint = Vector2.new(0, 1)

	local NotifLayout = Instance.new("UIListLayout")
	NotifLayout.Parent = NotificationContainer
	NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
	NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	NotifLayout.Padding = UDim.new(0, 10)

	-- ==========================================
	-- CONTENEDOR PRINCIPAL
	-- ==========================================
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = KiwiUI
	MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
	MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
	MainFrame.Size = UDim2.new(0, 600, 0, 400)
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Visible = false

	Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
	local MainStroke = Instance.new("UIStroke", MainFrame)
	MainStroke.Color = Color3.fromRGB(74, 222, 128)
	MainStroke.Thickness = 1
	MainStroke.Transparency = 0.5

	-- TopBar
	local TopBar = Instance.new("Frame")
	TopBar.Name = "TopBar"
	TopBar.Parent = MainFrame
	TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
	TopBar.Size = UDim2.new(1, 0, 0, 35)
	TopBar.BorderSizePixel = 0

	local TopTitle = Instance.new("TextLabel")
	TopTitle.Parent = TopBar
	TopTitle.BackgroundTransparency = 1
	TopTitle.Position = UDim2.new(0, 15, 0, 0)
	TopTitle.Size = UDim2.new(0, 200, 1, 0)
	TopTitle.Font = Enum.Font.MontserratBold
	TopTitle.RichText = true
	TopTitle.Text = '<font color="#4ade80">Kiwi</font><font color="#9ca3af">.xyz</font>'
	TopTitle.TextSize = 16
	TopTitle.TextXAlignment = Enum.TextXAlignment.Left

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Parent = TopBar
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Position = UDim2.new(1, -35, 0, 0)
	CloseBtn.Size = UDim2.new(0, 35, 1, 0)
	CloseBtn.Font = Enum.Font.MontserratBold
	CloseBtn.Text = "X"
	CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
	CloseBtn.TextSize = 14

	local MinBtn = Instance.new("TextButton")
	MinBtn.Parent = TopBar
	MinBtn.BackgroundTransparency = 1
	MinBtn.Position = UDim2.new(1, -70, 0, 0)
	MinBtn.Size = UDim2.new(0, 35, 1, 0)
	MinBtn.Font = Enum.Font.MontserratBold
	MinBtn.Text = "-"
	MinBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
	MinBtn.TextSize = 22

	local minimized = false
	MinBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 35)}):Play()
		else
			TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 400)}):Play()
		end
	end)

	CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(239, 68, 68)}):Play() end)
	CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play() end)
	CloseBtn.MouseButton1Click:Connect(function()
		TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
		task.wait(0.3)
		KiwiUI:Destroy()
	end)

	-- Sidebar
	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Parent = MainFrame
	Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
	Sidebar.Position = UDim2.new(0, 0, 0, 35)
	Sidebar.Size = UDim2.new(0, 150, 1, -35)
	Sidebar.BorderSizePixel = 0

	local TabContainer = Instance.new("ScrollingFrame")
	TabContainer.Parent = Sidebar
	TabContainer.BackgroundTransparency = 1
	TabContainer.Position = UDim2.new(0, 10, 0, 10)
	TabContainer.Size = UDim2.new(1, -20, 1, -20)
	TabContainer.ScrollBarThickness = 0

	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.Parent = TabContainer
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabListLayout.Padding = UDim.new(0, 5)

	-- Área de Contenido
	local ContentArea = Instance.new("Frame")
	ContentArea.Name = "ContentArea"
	ContentArea.Parent = MainFrame
	ContentArea.BackgroundTransparency = 1
	ContentArea.Position = UDim2.new(0, 160, 0, 45)
	ContentArea.Size = UDim2.new(1, -175, 1, -55)

	-- Lógica Draggable
	local dragging, dragInput, dragStart, startPos
	TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true; dragStart = input.Position; startPos = MainFrame.Position
			input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	TopBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	-- ==========================================
	-- PANTALLA DE CARGA
	-- ==========================================
	local function StartLoadingAnimation()
		local LoadGroup = Instance.new("CanvasGroup")
		LoadGroup.Parent = KiwiUI
		LoadGroup.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
		LoadGroup.Position = UDim2.new(0.5, -150, 0.5, -100)
		LoadGroup.Size = UDim2.new(0, 300, 0, 200)
		
		Instance.new("UICorner", LoadGroup).CornerRadius = UDim.new(0, 10)
		Instance.new("UIStroke", LoadGroup).Color = Color3.fromRGB(74, 222, 128)
		
		local CenterAlign = Instance.new("Frame")
		CenterAlign.Parent = LoadGroup
		CenterAlign.BackgroundTransparency = 1
		CenterAlign.Size = UDim2.new(1, 0, 1, 0)
		
		local AlignLayout = Instance.new("UIListLayout")
		AlignLayout.Parent = CenterAlign
		AlignLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		AlignLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		
		local LoadTitle = Instance.new("TextLabel")
		LoadTitle.Parent = CenterAlign
		LoadTitle.BackgroundTransparency = 1
		LoadTitle.Size = UDim2.new(0, 200, 0, 45)
		LoadTitle.Font = Enum.Font.MontserratBold
		LoadTitle.RichText = true
		LoadTitle.Text = '<font color="#4ade80">Kiwi</font><font color="#9ca3af">.xyz</font>'
		LoadTitle.TextSize = 38
		
		local LoadSub = Instance.new("TextLabel")
		LoadSub.Parent = CenterAlign
		LoadSub.BackgroundTransparency = 1
		LoadSub.Size = UDim2.new(0, 200, 0, 20)
		LoadSub.Font = Enum.Font.Montserrat
		LoadSub.Text = "Made with love"
		LoadSub.TextColor3 = Color3.fromRGB(120, 120, 125)
		LoadSub.TextSize = 13

		LoadGroup.Size = UDim2.new(0, 0, 0, 0)
		TweenService:Create(LoadGroup, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 300, 0, 200)}):Play()
		task.wait(2) 
		
		local fade = TweenService:Create(LoadGroup, TweenInfo.new(0.4), {GroupTransparency = 1, Size = UDim2.new(0, 320, 0, 220)})
		fade:Play()
		fade.Completed:Wait()
		LoadGroup:Destroy()
		
		MainFrame.Size = UDim2.new(0, 0, 0, 0)
		MainFrame.Visible = true
		TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 400)}):Play()
	end

	-- ==========================================
	-- SISTEMA DE KEYS
	-- ==========================================
	if useKey then
		local KeyGroup = Instance.new("CanvasGroup")
		KeyGroup.Parent = KiwiUI
		KeyGroup.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
		KeyGroup.Position = UDim2.new(0.5, -175, 0.5, -100)
		KeyGroup.Size = UDim2.new(0, 0, 0, 0) 
		
		Instance.new("UICorner", KeyGroup).CornerRadius = UDim.new(0, 10)
		local KeyStroke = Instance.new("UIStroke", KeyGroup)
		KeyStroke.Color = Color3.fromRGB(50, 50, 55)
		
		local KeyTitle = Instance.new("TextLabel")
		KeyTitle.Parent = KeyGroup
		KeyTitle.BackgroundTransparency = 1
		KeyTitle.Position = UDim2.new(0, 0, 0, 20)
		KeyTitle.Size = UDim2.new(1, 0, 0, 30)
		KeyTitle.Font = Enum.Font.MontserratBold
		KeyTitle.Text = "Authentication"
		KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		KeyTitle.TextSize = 18
		
		local KeyBox = Instance.new("TextBox")
		KeyBox.Parent = KeyGroup
		KeyBox.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
		KeyBox.Position = UDim2.new(0.5, -125, 0.5, -15)
		KeyBox.Size = UDim2.new(0, 250, 0, 40)
		KeyBox.Font = Enum.Font.Montserrat
		KeyBox.PlaceholderText = "Enter Secret Key..."
		KeyBox.Text = ""
		KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		KeyBox.TextSize = 14
		Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 6)
		local BoxStroke = Instance.new("UIStroke", KeyBox)
		BoxStroke.Color = Color3.fromRGB(50, 50, 55)
		
		KeyBox.Focused:Connect(function() TweenService:Create(BoxStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(74, 222, 128)}):Play() end)
		KeyBox.FocusLost:Connect(function() TweenService:Create(BoxStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(50, 50, 55)}):Play() end)

		local SubmitBtn = Instance.new("TextButton")
		SubmitBtn.Parent = KeyGroup
		SubmitBtn.BackgroundColor3 = Color3.fromRGB(74, 222, 128)
		SubmitBtn.Position = UDim2.new(0.5, -125, 0.5, 40)
		SubmitBtn.Size = UDim2.new(0, 250, 0, 35)
		SubmitBtn.Font = Enum.Font.MontserratBold
		SubmitBtn.Text = "Verify"
		SubmitBtn.TextColor3 = Color3.fromRGB(25, 25, 28)
		SubmitBtn.TextSize = 14
		Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 6)
		
		SubmitBtn.MouseEnter:Connect(function() TweenService:Create(SubmitBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 240, 140)}):Play() end)
		SubmitBtn.MouseLeave:Connect(function() TweenService:Create(SubmitBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(74, 222, 128)}):Play() end)

		TweenService:Create(KeyGroup, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 350, 0, 220)}):Play()

		SubmitBtn.MouseButton1Click:Connect(function()
			if KeyBox.Text == correctKey then
				SubmitBtn.Text = "Verified!"
				TweenService:Create(KeyStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(74, 222, 128)}):Play()
				task.wait(0.6)
				local fade = TweenService:Create(KeyGroup, TweenInfo.new(0.4), {GroupTransparency = 1, Size = UDim2.new(0, 370, 0, 240)})
				fade:Play()
				fade.Completed:Wait()
				KeyGroup:Destroy()
				StartLoadingAnimation()
			else
				SubmitBtn.Text = "Invalid Key"
				TweenService:Create(SubmitBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(239, 68, 68), TextColor3 = Color3.fromRGB(255,255,255)}):Play()
				TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(239, 68, 68)}):Play()
				task.wait(1)
				SubmitBtn.Text = "Verify"
				TweenService:Create(SubmitBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(74, 222, 128), TextColor3 = Color3.fromRGB(25, 25, 28)}):Play()
				TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 55)}):Play()
			end
		end)
	else
		StartLoadingAnimation()
	end

	-- ==========================================
	-- API DEL OBJETO WINDOW (TABS & COMPONENTES)
	-- ==========================================
	local WindowObj = {}
	local firstTab = true

	-- Funcionalidad de Notificaciones
	function WindowObj:Notify(title, text, duration)
		duration = duration or 3
		local NotifFrame = Instance.new("Frame")
		NotifFrame.Parent = NotificationContainer
		NotifFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
		NotifFrame.Size = UDim2.new(1, 0, 0, 60)
		NotifFrame.BackgroundTransparency = 1
		
		Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 8)
		local NStroke = Instance.new("UIStroke", NotifFrame)
		NStroke.Color = Color3.fromRGB(74, 222, 128)
		NStroke.Transparency = 1
		
		local NTitle = Instance.new("TextLabel")
		NTitle.Parent = NotifFrame
		NTitle.BackgroundTransparency = 1
		NTitle.Position = UDim2.new(0, 10, 0, 5)
		NTitle.Size = UDim2.new(1, -20, 0, 20)
		NTitle.Font = Enum.Font.MontserratBold
		NTitle.Text = title
		NTitle.TextColor3 = Color3.fromRGB(74, 222, 128)
		NTitle.TextSize = 14
		NTitle.TextXAlignment = Enum.TextXAlignment.Left
		NTitle.TextTransparency = 1

		local NText = Instance.new("TextLabel")
		NText.Parent = NotifFrame
		NText.BackgroundTransparency = 1
		NText.Position = UDim2.new(0, 10, 0, 25)
		NText.Size = UDim2.new(1, -20, 1, -30)
		NText.Font = Enum.Font.Montserrat
		NText.Text = text
		NText.TextColor3 = Color3.fromRGB(200, 200, 200)
		NText.TextSize = 12
		NText.TextXAlignment = Enum.TextXAlignment.Left
		NText.TextWrapped = true
		NText.TextTransparency = 1

		-- Animación de entrada
		TweenService:Create(NotifFrame, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
		TweenService:Create(NStroke, TweenInfo.new(0.4), {Transparency = 0}):Play()
		TweenService:Create(NTitle, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
		TweenService:Create(NText, TweenInfo.new(0.4), {TextTransparency = 0}):Play()

		task.delay(duration, function()
			TweenService:Create(NotifFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
			TweenService:Create(NStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
			TweenService:Create(NTitle, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
			TweenService:Create(NText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
			task.wait(0.4)
			NotifFrame:Destroy()
		end)
	end

	function WindowObj:CreateTab(tabName, iconName)
		local TabBtn = Instance.new("TextButton")
		TabBtn.Parent = TabContainer
		TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
		TabBtn.Size = UDim2.new(1, 0, 0, 35)
		TabBtn.AutoButtonColor = false
		TabBtn.Font = Enum.Font.MontserratBold
		TabBtn.Text = tabName
		TabBtn.TextColor3 = Color3.fromRGB(130, 130, 130)
		TabBtn.TextSize = 13
		TabBtn.TextXAlignment = Enum.TextXAlignment.Left

		Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
		local Padding = Instance.new("UIPadding", TabBtn)
		Padding.PaddingLeft = UDim.new(0, 35)

		local iconID = GetIcon(iconName)
		if iconID ~= "" then
			local TabIcon = Instance.new("ImageLabel")
			TabIcon.Parent = TabBtn
			TabIcon.BackgroundTransparency = 1
			TabIcon.Position = UDim2.new(0, -25, 0.5, -8) 
			TabIcon.Size = UDim2.new(0, 16, 0, 16)
			TabIcon.Image = iconID
			TabIcon.ImageColor3 = Color3.fromRGB(130, 130, 130)
		end

		local TabPage = Instance.new("ScrollingFrame")
		TabPage.Parent = ContentArea
		TabPage.BackgroundTransparency = 1
		TabPage.Size = UDim2.new(1, 0, 1, 0)
		TabPage.ScrollBarThickness = 3
		TabPage.ScrollBarImageColor3 = Color3.fromRGB(74, 222, 128)
		TabPage.Visible = false

		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Parent = TabPage
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Padding = UDim.new(0, 8)

		TabBtn.MouseButton1Click:Connect(function()
			for _, child in ipairs(TabContainer:GetChildren()) do
				if child:IsA("TextButton") then
					TweenService:Create(child, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(25, 25, 28), TextColor3 = Color3.fromRGB(130, 130, 130)}):Play()
					if child:FindFirstChild("ImageLabel") then
						TweenService:Create(child.ImageLabel, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(130, 130, 130)}):Play()
					end
				end
			end
			for _, page in ipairs(ContentArea:GetChildren()) do
				if page:IsA("ScrollingFrame") then page.Visible = false end
			end

			TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 40), TextColor3 = Color3.fromRGB(74, 222, 128)}):Play()
			if TabBtn:FindFirstChild("ImageLabel") then
				TweenService:Create(TabBtn.ImageLabel, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(74, 222, 128)}):Play()
			end
			TabPage.Visible = true
		end)

		if firstTab then
			firstTab = false
			TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			TabBtn.TextColor3 = Color3.fromRGB(74, 222, 128)
			if TabBtn:FindFirstChild("ImageLabel") then TabBtn.ImageLabel.ImageColor3 = Color3.fromRGB(74, 222, 128) end
			TabPage.Visible = true
		end

		local TabElements = {}

		-- COMPONENTE: BOTÓN
		function TabElements:CreateButton(name, callback)
			local callback = callback or function() end
			local Btn = Instance.new("TextButton")
			Btn.Parent = TabPage
			Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			Btn.Size = UDim2.new(1, -10, 0, 38)
			Btn.AutoButtonColor = false
			Btn.Font = Enum.Font.MontserratBold
			Btn.Text = name
			Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
			Btn.TextSize = 13
			Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

			Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play() end)
			Btn.MouseLeave:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play() end)
			Btn.MouseButton1Click:Connect(function()
				TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(74, 222, 128), TextColor3 = Color3.fromRGB(25, 25, 28)}):Play()
				task.wait(0.1)
				TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50), TextColor3 = Color3.fromRGB(220, 220, 220)}):Play()
				pcall(callback)
			end)
		end

		-- COMPONENTE: TOGGLE (Interruptor)
		function TabElements:CreateToggle(name, default, callback)
			local toggled = default or false
			local callback = callback or function() end
			
			local ToggleFrame = Instance.new("TextButton")
			ToggleFrame.Parent = TabPage
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			ToggleFrame.Size = UDim2.new(1, -10, 0, 38)
			ToggleFrame.AutoButtonColor = false
			ToggleFrame.Text = ""
			Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)
			
			local TTitle = Instance.new("TextLabel")
			TTitle.Parent = ToggleFrame
			TTitle.BackgroundTransparency = 1
			TTitle.Position = UDim2.new(0, 15, 0, 0)
			TTitle.Size = UDim2.new(1, -60, 1, 0)
			TTitle.Font = Enum.Font.MontserratBold
			TTitle.Text = name
			TTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
			TTitle.TextSize = 13
			TTitle.TextXAlignment = Enum.TextXAlignment.Left
			
			local ToggleBg = Instance.new("Frame")
			ToggleBg.Parent = ToggleFrame
			ToggleBg.BackgroundColor3 = toggled and Color3.fromRGB(74, 222, 128) or Color3.fromRGB(25, 25, 28)
			ToggleBg.Position = UDim2.new(1, -45, 0.5, -10)
			ToggleBg.Size = UDim2.new(0, 36, 0, 20)
			Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)
			
			local ToggleCircle = Instance.new("Frame")
			ToggleCircle.Parent = ToggleBg
			ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleCircle.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
			ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
			Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

			ToggleFrame.MouseButton1Click:Connect(function()
				toggled = not toggled
				pcall(callback, toggled)
				if toggled then
					TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(74, 222, 128)}):Play()
					TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
				else
					TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 28)}):Play()
					TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
				end
			end)
		end

		-- COMPONENTE: SLIDER (Deslizador)
		function TabElements:CreateSlider(name, min, max, default, callback)
			local callback = callback or function() end
			local currentValue = default or min
			
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Parent = TabPage
			SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			SliderFrame.Size = UDim2.new(1, -10, 0, 50)
			Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)
			
			local STitle = Instance.new("TextLabel")
			STitle.Parent = SliderFrame
			STitle.BackgroundTransparency = 1
			STitle.Position = UDim2.new(0, 15, 0, 5)
			STitle.Size = UDim2.new(1, -30, 0, 20)
			STitle.Font = Enum.Font.MontserratBold
			STitle.Text = name
			STitle.TextColor3 = Color3.fromRGB(220, 220, 220)
			STitle.TextSize = 13
			STitle.TextXAlignment = Enum.TextXAlignment.Left
			
			local SValue = Instance.new("TextLabel")
			SValue.Parent = SliderFrame
			SValue.BackgroundTransparency = 1
			SValue.Position = UDim2.new(1, -50, 0, 5)
			SValue.Size = UDim2.new(0, 35, 0, 20)
			SValue.Font = Enum.Font.MontserratBold
			SValue.Text = tostring(currentValue)
			SValue.TextColor3 = Color3.fromRGB(74, 222, 128)
			SValue.TextSize = 13
			SValue.TextXAlignment = Enum.TextXAlignment.Right
			
			local SliderBg = Instance.new("TextButton")
			SliderBg.Parent = SliderFrame
			SliderBg.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
			SliderBg.Position = UDim2.new(0, 15, 0, 30)
			SliderBg.Size = UDim2.new(1, -30, 0, 8)
			SliderBg.AutoButtonColor = false
			SliderBg.Text = ""
			Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)
			
			local SliderFill = Instance.new("Frame")
			SliderFill.Parent = SliderBg
			SliderFill.BackgroundColor3 = Color3.fromRGB(74, 222, 128)
			SliderFill.Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)
			Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

			local dragging = false
			local function updateSlider(input)
				local relative = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
				local value = math.floor(min + ((max - min) * relative))
				SValue.Text = tostring(value)
				TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(relative, 0, 1, 0)}):Play()
				pcall(callback, value)
			end

			SliderBg.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true; updateSlider(input)
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					updateSlider(input)
				end
			end)
		end

		-- COMPONENTE: DROPDOWN (Menú Desplegable)
		function TabElements:CreateDropdown(name, options, callback)
			local callback = callback or function() end
			local isDropped = false
			
			local DropFrame = Instance.new("Frame")
			DropFrame.Parent = TabPage
			DropFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			DropFrame.Size = UDim2.new(1, -10, 0, 38)
			DropFrame.ClipsDescendants = true
			Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)
			
			local DropBtn = Instance.new("TextButton")
			DropBtn.Parent = DropFrame
			DropBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			DropBtn.Size = UDim2.new(1, 0, 0, 38)
			DropBtn.AutoButtonColor = false
			DropBtn.Font = Enum.Font.MontserratBold
			DropBtn.Text = name .. " : N/A"
			DropBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
			DropBtn.TextSize = 13
			Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 6)
			local DPadding = Instance.new("UIPadding", DropBtn)
			DPadding.PaddingLeft = UDim.new(0, 15)

			local OptionContainer = Instance.new("ScrollingFrame")
			OptionContainer.Parent = DropFrame
			OptionContainer.BackgroundTransparency = 1
			OptionContainer.Position = UDim2.new(0, 0, 0, 38)
			OptionContainer.Size = UDim2.new(1, 0, 1, -38)
			OptionContainer.ScrollBarThickness = 2
			OptionContainer.ScrollBarImageColor3 = Color3.fromRGB(74, 222, 128)
			
			local OptLayout = Instance.new("UIListLayout")
			OptLayout.Parent = OptionContainer
			OptLayout.SortOrder = Enum.SortOrder.LayoutOrder

			DropBtn.MouseButton1Click:Connect(function()
				isDropped = not isDropped
				if isDropped then
					local totalSize = 38 + math.min(#options * 30, 120)
					TweenService:Create(DropFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, -10, 0, totalSize)}):Play()
				else
					TweenService:Create(DropFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, -10, 0, 38)}):Play()
				end
			end)

			for _, option in ipairs(options) do
				local OptBtn = Instance.new("TextButton")
				OptBtn.Parent = OptionContainer
				OptBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
				OptBtn.Size = UDim2.new(1, 0, 0, 30)
				OptBtn.AutoButtonColor = false
				OptBtn.Font = Enum.Font.Montserrat
				OptBtn.Text = option
				OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
				OptBtn.TextSize = 12
				
				OptBtn.MouseButton1Click:Connect(function()
					DropBtn.Text = name .. " : " .. option
					isDropped = false
					TweenService:Create(DropFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, -10, 0, 38)}):Play()
					pcall(callback, option)
				end)
			end
		-- COMPONENTE: TEXTBOX (Entrada de texto)
		function TabElements:CreateTextbox(name, placeholder, callback)
			local callback = callback or function() end
			
			local BoxFrame = Instance.new("Frame")
			BoxFrame.Parent = TabPage
			BoxFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			BoxFrame.Size = UDim2.new(1, -10, 0, 45)
			Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 6)
			
			local BTitle = Instance.new("TextLabel")
			BTitle.Parent = BoxFrame
			BTitle.BackgroundTransparency = 1
			BTitle.Position = UDim2.new(0, 15, 0, 0)
			BTitle.Size = UDim2.new(1, -30, 1, 0)
			BTitle.Font = Enum.Font.MontserratBold
			BTitle.Text = name
			BTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
			BTitle.TextSize = 13
			BTitle.TextXAlignment = Enum.TextXAlignment.Left
			
			local InputBox = Instance.new("TextBox")
			InputBox.Parent = BoxFrame
			InputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
			InputBox.Position = UDim2.new(1, -130, 0.5, -12)
			InputBox.Size = UDim2.new(0, 120, 0, 25)
			InputBox.Font = Enum.Font.Montserrat
			InputBox.PlaceholderText = placeholder
			InputBox.Text = ""
			InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			InputBox.TextSize = 12
			Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 4)
			
			InputBox.FocusLost:Connect(function(enterPressed)
				if enterPressed then
					pcall(callback, InputBox.Text)
				end
			end)
		end

		-- COMPONENTE: KEYBIND (Asignar tecla)
		function TabElements:CreateKeybind(name, default, callback)
			local callback = callback or function() end
			local binding = false
			local currentKey = default or Enum.KeyCode.RightControl
			
			local KBindFrame = Instance.new("TextButton")
			KBindFrame.Parent = TabPage
			KBindFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			KBindFrame.Size = UDim2.new(1, -10, 0, 38)
			KBindFrame.AutoButtonColor = false
			KBindFrame.Text = ""
			Instance.new("UICorner", KBindFrame).CornerRadius = UDim.new(0, 6)
			
			local KTitle = Instance.new("TextLabel")
			KTitle.Parent = KBindFrame
			KTitle.BackgroundTransparency = 1
			KTitle.Position = UDim2.new(0, 15, 0, 0)
			KTitle.Size = UDim2.new(1, -60, 1, 0)
			KTitle.Font = Enum.Font.MontserratBold
			KTitle.Text = name
			KTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
			KTitle.TextSize = 13
			KTitle.TextXAlignment = Enum.TextXAlignment.Left
			
			local KeyLabel = Instance.new("TextLabel")
			KeyLabel.Parent = KBindFrame
			KeyLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
			KeyLabel.Position = UDim2.new(1, -85, 0.5, -12)
			KeyLabel.Size = UDim2.new(0, 75, 0, 25)
			KeyLabel.Font = Enum.Font.MontserratBold
			KeyLabel.Text = currentKey.Name
			KeyLabel.TextColor3 = Color3.fromRGB(74, 222, 128)
			KeyLabel.TextSize = 12
			Instance.new("UICorner", KeyLabel).CornerRadius = UDim.new(0, 4)
			
			KBindFrame.MouseButton1Click:Connect(function()
				binding = true
				KeyLabel.Text = "..."
			end)
			
			UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if binding then
					if input.UserInputType == Enum.UserInputType.Keyboard then
						currentKey = input.KeyCode
						KeyLabel.Text = currentKey.Name
						binding = false
					end
				elseif input.KeyCode == currentKey and not gameProcessed then
					pcall(callback)
				end
			end)
		end
	end

	return TabElements
end

return WindowObj
end

return KiwiLibrary
