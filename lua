--============================================================
-- SAP HUB · Roblox Script UI (مع الاستهداف الكامل)
--============================================================

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer

if CoreGui:FindFirstChild("SAP_Tag") or (gethui and gethui():FindFirstChild("SAP_Tag")) then
    local AlreadySound = Instance.new("Sound")
    AlreadySound.SoundId = "rbxassetid://17692186249"
    AlreadySound.Volume = 1
    AlreadySound.Parent = SoundService
    AlreadySound:Play()
    Debris:AddItem(AlreadySound, 5)
    StarterGui:SetCore("SendNotification", {
        Title = "S A P  ~  H U B",
        Text = "تم تفعيل السكربت مسبقاً، أعد الدخول لتشغيله مجدداً",
        Duration = 5
    })
    return
else
    local Tag = Instance.new("Folder")
    Tag.Name = "SAP_Tag"
    Tag.Parent = (gethui and gethui()) or CoreGui
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SAP_HUB"
ScreenGui.Parent = (gethui and gethui()) or CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

--============================================================
-- الألوان
--============================================================
local COLOR_RED = Color3.fromRGB(120, 0, 0)
local COLOR_RED_DARK = Color3.fromRGB(35, 0, 0)
local COLOR_GREEN = Color3.fromRGB(0, 160, 0)
local COLOR_BLACK = Color3.fromRGB(8, 0, 0)

--============================================================
-- الإطار الرئيسي
--============================================================
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.BackgroundColor3 = COLOR_BLACK
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.new(0.5, 0, -0.5, 0)
Main.Size = UDim2.new(0, 540, 0, 340)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 24)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = COLOR_RED
MainStroke.Thickness = 3

local BGImage = Instance.new("ImageLabel", Main)
BGImage.BackgroundTransparency = 1
BGImage.Size = UDim2.new(1, 0, 1, 0)
BGImage.Image = "rbxassetid://126584489536404"
BGImage.ScaleType = Enum.ScaleType.Crop
BGImage.ImageTransparency = 0.15

local BGCorner = Instance.new("UICorner", BGImage)
BGCorner.CornerRadius = UDim.new(0, 24)

local DarkOverlay = Instance.new("Frame", Main)
DarkOverlay.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
DarkOverlay.BackgroundTransparency = 0.45
DarkOverlay.Size = UDim2.new(1, 0, 1, 0)

local OverlayCorner = Instance.new("UICorner", DarkOverlay)
OverlayCorner.CornerRadius = UDim.new(0, 24)

local Title = Instance.new("TextLabel", Main)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 6)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Font = Enum.Font.GothamBlack
Title.Text = "SAP"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true

local BGSpin = Instance.new("ImageLabel", Main)
BGSpin.BackgroundTransparency = 1
BGSpin.AnchorPoint = Vector2.new(0.5, 0.5)
BGSpin.Position = UDim2.new(0.73, 0, 0.58, 0)
BGSpin.Size = UDim2.new(0, 220, 0, 220)
BGSpin.Image = "rbxassetid://132784270564779"
BGSpin.ImageTransparency = 0.08
BGSpin.ZIndex = 1

local SideLogo = Instance.new("ImageLabel", Main)
SideLogo.BackgroundTransparency = 1
SideLogo.Image = "rbxthumb://type=Asset&w=420&h=420&id=86461299508559"
SideLogo.Size = UDim2.new(0, 135, 0, 135)
SideLogo.Position = UDim2.new(0, -58, 0, -58)
SideLogo.Rotation = -22
SideLogo.ZIndex = 10

--============================================================
-- القائمة الجانبية
--============================================================
local TabsFrame = Instance.new("Frame", Main)
TabsFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
TabsFrame.BackgroundTransparency = 0.15
TabsFrame.Position = UDim2.new(0, 15, 0, 70)
TabsFrame.Size = UDim2.new(0, 145, 1, -85)

local TabsCorner = Instance.new("UICorner", TabsFrame)
TabsCorner.CornerRadius = UDim.new(0, 18)

local function createTab(text, yPos)
    local Tab = Instance.new("TextButton", TabsFrame)
    Tab.BackgroundColor3 = COLOR_RED_DARK
    Tab.Position = UDim2.new(0, 8, 0, yPos)
    Tab.Size = UDim2.new(1, -16, 0, 42)
    Tab.Font = Enum.Font.GothamBlack
    Tab.Text = text
    Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tab.TextScaled = true
    Tab.BorderSizePixel = 0

    local Corner = Instance.new("UICorner", Tab)
    Corner.CornerRadius = UDim.new(0, 14)
    return Tab
end

local HomeTab = createTab("الرئيسية", 8)
HomeTab.BackgroundColor3 = COLOR_RED

local PlayerTab = createTab("اللاعب", 58)
local TargetTab = createTab("الاستهداف", 108)

--============================================================
-- صفحة الرئيسية
--============================================================
local MainPage = Instance.new("ScrollingFrame", Main)
MainPage.BackgroundTransparency = 1
MainPage.Position = UDim2.new(0, 175, 0, 75)
MainPage.Size = UDim2.new(1, -190, 1, -90)
MainPage.Visible = true
MainPage.ScrollBarThickness = 4
MainPage.CanvasSize = UDim2.new(0, 0, 0, 530)
MainPage.ScrollBarImageColor3 = COLOR_RED

local ProfileImage = Instance.new("ImageLabel", MainPage)
ProfileImage.BackgroundTransparency = 1
ProfileImage.Position = UDim2.new(0, 12, 0, 12)
ProfileImage.Size = UDim2.new(0, 95, 0, 95)
ProfileImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. lp.UserId .. "&width=420&height=420&format=png"

local ProfileCorner = Instance.new("UICorner", ProfileImage)
ProfileCorner.CornerRadius = UDim.new(0, 26)

local ProfileStroke = Instance.new("UIStroke", ProfileImage)
ProfileStroke.Color = COLOR_RED
ProfileStroke.Thickness = 2

local MiniButton = Instance.new("ImageButton", MainPage)
MiniButton.BackgroundTransparency = 1
MiniButton.Position = UDim2.new(0, 112, 0, 82)
MiniButton.Size = UDim2.new(0, 25, 0, 25)
MiniButton.Image = "rbxassetid://135406680788649"
MiniButton.ZIndex = 6

local MiniButtonStroke = Instance.new("UIStroke", MiniButton)
MiniButtonStroke.Color = COLOR_RED
MiniButtonStroke.Thickness = 2

local MiniButtonCorner = Instance.new("UICorner", MiniButton)
MiniButtonCorner.CornerRadius = UDim.new(0, 4)

MiniButton.MouseButton1Click:Connect(function()
    if setclipboard then
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://6026984224"
        sound.Volume = 1
        sound.Parent = SoundService
        sound:Play()
        setclipboard("https://discord.gg/e6GzC8eDe")
        StarterGui:SetCore("SendNotification", {
            Title = "S A P",
            Text = "تم نسخ رابط الدس",
            Duration = 3
        })
    end
end)

local UserText = Instance.new("TextLabel", MainPage)
UserText.BackgroundTransparency = 1
UserText.Position = UDim2.new(0, 125, 0, 18)
UserText.Size = UDim2.new(1, -130, 0, 40)
UserText.Font = Enum.Font.GothamBlack
UserText.Text = "@" .. lp.Name
UserText.TextColor3 = Color3.fromRGB(255, 255, 255)
UserText.TextScaled = true
UserText.TextXAlignment = Enum.TextXAlignment.Left
UserText.ZIndex = 5

local InfoText = Instance.new("TextLabel", MainPage)
InfoText.BackgroundTransparency = 1
InfoText.Position = UDim2.new(0, 12, 0, 120)
InfoText.Size = UDim2.new(1, -20, 0, 60)
InfoText.Font = Enum.Font.GothamBold
InfoText.Text = "مرحبا بك في واجهة SAP"
InfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoText.TextWrapped = true
InfoText.TextScaled = true
InfoText.ZIndex = 5

local DevsTitle = Instance.new("TextLabel", MainPage)
DevsTitle.BackgroundTransparency = 1
DevsTitle.Position = UDim2.new(0, 12, 0, 190)
DevsTitle.Size = UDim2.new(1, -20, 0, 40)
DevsTitle.Font = Enum.Font.GothamBlack
DevsTitle.Text = "مطورين السكربت"
DevsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
DevsTitle.TextScaled = true

local function createDevCard(yPos, imageId, name, role)
    local Dev = Instance.new("Frame", MainPage)
    Dev.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    Dev.Position = UDim2.new(0, 10, 0, yPos)
    Dev.Size = UDim2.new(0, 310, 0, 80)
    Dev.BorderSizePixel = 0

    local Corner = Instance.new("UICorner", Dev)
    Corner.CornerRadius = UDim.new(0, 14)

    local Img = Instance.new("ImageLabel", Dev)
    Img.BackgroundTransparency = 1
    Img.Position = UDim2.new(0, 8, 0, 8)
    Img.Size = UDim2.new(0, 64, 0, 64)
    Img.Image = imageId

    local ImgCorner = Instance.new("UICorner", Img)
    ImgCorner.CornerRadius = UDim.new(1, 0)

    local NameLabel = Instance.new("TextLabel", Dev)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Position = UDim2.new(0, 85, 0, 12)
    NameLabel.Size = UDim2.new(0, 200, 0, 25)
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.Text = name
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextScaled = true
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left

    local RoleLabel = Instance.new("TextLabel", Dev)
    RoleLabel.BackgroundTransparency = 1
    RoleLabel.Position = UDim2.new(0, 85, 0, 40)
    RoleLabel.Size = UDim2.new(0, 200, 0, 20)
    RoleLabel.Font = Enum.Font.Gotham
    RoleLabel.Text = role
    RoleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    RoleLabel.TextScaled = true
    RoleLabel.TextXAlignment = Enum.TextXAlignment.Left

    return Dev
end

local Dev1 = createDevCard(245, "rbxthumb://type=Asset&w=420&h=420&id=94404276157627", "SAP | HUB 🇸🇦", "مطور الواجهة")
local Dev2 = createDevCard(340, "rbxthumb://type=Asset&w=420&h=420&id=105677551726307", "SAP 🇸🇦", "مطور السكربت")
local Dev3 = createDevCard(435, "rbxthumb://type=Asset&w=420&h=420&id=112161329435254", "SAP 🇸🇦", "مساعد السكربتر")

--============================================================
-- صفحة اللاعب
--============================================================
local PlayerPage = Instance.new("ScrollingFrame", Main)
PlayerPage.BackgroundTransparency = 1
PlayerPage.Position = UDim2.new(0, 175, 0, 75)
PlayerPage.Size = UDim2.new(1, -190, 1, -90)
PlayerPage.Visible = false
PlayerPage.ScrollBarThickness = 4
PlayerPage.CanvasSize = UDim2.new(0, 0, 0, 270)
PlayerPage.ScrollBarImageColor3 = COLOR_RED

local function createPlayerBtn(text, xPos, yPos, width)
    local Btn = Instance.new("TextButton", PlayerPage)
    Btn.BackgroundColor3 = COLOR_RED
    Btn.BackgroundTransparency = 0.3
    Btn.BorderSizePixel = 0
    Btn.Position = UDim2.new(0, xPos, 0, yPos)
    Btn.Size = UDim2.new(0, width, 0, 35)
    Btn.Font = Enum.Font.Oswald
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextScaled = true

    local Corner = Instance.new("UICorner", Btn)
    Corner.CornerRadius = UDim.new(0, 8)
    return Btn
end

local function createToggleIcon(xPos, yPos)
    local Icon = Instance.new("ImageButton", PlayerPage)
    Icon.BackgroundTransparency = 1
    Icon.Size = UDim2.new(0, 50, 0, 50)
    Icon.Position = UDim2.new(0, xPos, 0, yPos)
    Icon.Image = "rbxthumb://type=Asset&w=420&h=420&id=123230060492540"

    local Corner = Instance.new("UICorner", Icon)
    Corner.CornerRadius = UDim.new(0, 6)

    local toggled = false
    Icon.MouseButton1Click:Connect(function()
        toggled = not toggled
        Icon.Image = toggled and "rbxthumb://type=Asset&w=420&h=420&id=73373774661562"
            or "rbxthumb://type=Asset&w=420&h=420&id=123230060492540"
    end)
    return Icon
end

local function createInput(placeholder, xPos, yPos, width)
    local Input = Instance.new("TextBox", PlayerPage)
    Input.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    Input.BackgroundTransparency = 0.3
    Input.BorderSizePixel = 0
    Input.Position = UDim2.new(0, xPos, 0, yPos)
    Input.Size = UDim2.new(0, width, 0, 35)
    Input.Font = Enum.Font.Gotham
    Input.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
    Input.PlaceholderText = placeholder
    Input.Text = ""
    Input.TextColor3 = Color3.fromRGB(255, 255, 255)
    Input.TextSize = 14

    local Corner = Instance.new("UICorner", Input)
    Corner.CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", Input)
    Stroke.Color = COLOR_RED
    Stroke.Thickness = 1
    return Input
end

local WalkSpeedBtn = createPlayerBtn("Ws | السرعة", 10, 15, 140)
local WalkSpeedIcon = createToggleIcon(155, 8)
local WalkSpeedInput = createInput("Number [1-99999]", 210, 15, 120)

local JumpPowerBtn = createPlayerBtn("النط | Jump", 10, 65, 140)
local JumpPowerIcon = createToggleIcon(155, 58)
local JumpPowerInput = createInput("Number [1-99999]", 210, 65, 120)

local NoclipBtn = createPlayerBtn("نوكليب", 10, 115, 140)
local NoclipIcon = createToggleIcon(155, 108)
local TeleportToolBtn = createPlayerBtn("اداة التنقل", 210, 115, 120)
local TeleportToolIcon = createToggleIcon(175, 108)

local SaveCheckpointBtn = createPlayerBtn("حفظ الشيك بوينت", 10, 165, 140)
local SaveCheckpointIcon = createToggleIcon(155, 158)
local ClearCheckpointBtn = createPlayerBtn("ازالة الشيك بوينت", 210, 165, 120)
local ClearCheckpointIcon = createToggleIcon(175, 158)

local RespawnBtn = createPlayerBtn("ريسبون", 10, 215, 140)
local RespawnIcon = createToggleIcon(155, 208)

--============================================================
-- صفحة الاستهداف
--============================================================
local TargetPage = Instance.new("ScrollingFrame", Main)
TargetPage.BackgroundTransparency = 1
TargetPage.Position = UDim2.new(0, 175, 0, 75)
TargetPage.Size = UDim2.new(1, -190, 1, -90)
TargetPage.Visible = false
TargetPage.ScrollBarThickness = 4
TargetPage.CanvasSize = UDim2.new(0, 0, 0, 550)
TargetPage.ScrollBarImageColor3 = COLOR_RED

-- صورة الهدف
local TargetImage = Instance.new("ImageLabel", TargetPage)
TargetImage.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TargetImage.BackgroundTransparency = 0.2
TargetImage.Position = UDim2.new(0, 15, 0, 15)
TargetImage.Size = UDim2.new(0, 75, 0, 75)
TargetImage.Image = "rbxassetid://10818605405"

local TargetImageCorner = Instance.new("UICorner", TargetImage)
TargetImageCorner.CornerRadius = UDim.new(0, 10)

local TargetImageStroke = Instance.new("UIStroke", TargetImage)
TargetImageStroke.Color = COLOR_RED
TargetImageStroke.Thickness = 2

-- حقل اسم الهدف
local TargetName_Input = Instance.new("TextBox", TargetPage)
TargetName_Input.Position = UDim2.new(0, 100, 0, 20)
TargetName_Input.Size = UDim2.new(0, 120, 0, 28)
TargetName_Input.PlaceholderText = "@الهدف..."
TargetName_Input.Text = ""
TargetName_Input.Font = Enum.Font.Gotham
TargetName_Input.TextSize = 13
TargetName_Input.BackgroundTransparency = 0.3
TargetName_Input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TargetName_Input.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetName_Input.BorderSizePixel = 0

local TargetInputCorner = Instance.new("UICorner", TargetName_Input)
TargetInputCorner.CornerRadius = UDim.new(0, 8)

--============================================================
-- أداة اليد (ImageButton) جنب الاسم
--============================================================
local HandTool = Instance.new("ImageButton", TargetPage)
HandTool.Position = UDim2.new(0, 228, 0, 18)
HandTool.Size = UDim2.new(0, 32, 0, 32)
HandTool.BackgroundTransparency = 0.2
HandTool.BackgroundColor3 = COLOR_RED
HandTool.Image = "rbxassetid://131608169355205" -- أيقونة يد
HandTool.BorderSizePixel = 0

local HandToolCorner = Instance.new("UICorner", HandTool)
HandToolCorner.CornerRadius = UDim.new(0, 8)

local HandToolStroke = Instance.new("UIStroke", HandTool)
HandToolStroke.Color = COLOR_RED
HandToolStroke.Thickness = 2

-- معلومات الهدف
local UserIDTargetLabel = Instance.new("TextLabel", TargetPage)
UserIDTargetLabel.Position = UDim2.new(0, 100, 0, 55)
UserIDTargetLabel.Size = UDim2.new(0, 190, 0, 60)
UserIDTargetLabel.BackgroundTransparency = 1
UserIDTargetLabel.Font = Enum.Font.Oswald
UserIDTargetLabel.Text = "المعرف: --\nالاسم الظاهر: --\nتاريخ الانضمام: --"
UserIDTargetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UserIDTargetLabel.TextSize = 12
UserIDTargetLabel.TextXAlignment = Enum.TextXAlignment.Left
UserIDTargetLabel.TextYAlignment = Enum.TextYAlignment.Top

--============================================================
-- متغير الهدف
--============================================================
local TargetPlayer = nil

-- دالة تحديث معلومات الهدف
local function updateTargetInfo(player)
    if not player then return end
    TargetPlayer = player
    TargetImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
    TargetName_Input.Text = "@" .. player.Name
    
    local joinDate = "غير معروف"
    pcall(function()
        joinDate = player.AccountAge .. " يوم"
    end)
    
    UserIDTargetLabel.Text = "المعرف: " .. player.UserId ..
        "\nالاسم الظاهر: " .. player.DisplayName ..
        "\nتاريخ الانضمام: " .. joinDate
end

-- البحث التلقائي بالاسم
TargetName_Input.Focused:Connect(function()
    TargetName_Input.Text = ""
end)

TargetName_Input.FocusLost:Connect(function()
    local searchName = TargetName_Input.Text:gsub("@", "")
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():find(searchName:lower()) or p.DisplayName:lower():find(searchName:lower()) then
            updateTargetInfo(p)
            return
        end
    end
end)

--============================================================
-- أداة اليد: تفعيل + اختيار الهدف بالنقر
--============================================================
local handActive = false

HandTool.MouseButton1Click:Connect(function()
    handActive = not handActive
    if handActive then
        HandTool.BackgroundColor3 = COLOR_GREEN
        StarterGui:SetCore("SendNotification", {
            Title = "SAP",
            Text = "أداة اليد مفعلة - اضغط على أي لاعب لاستهدافه",
            Duration = 3
        })
    else
        HandTool.BackgroundColor3 = COLOR_RED
    end
end)

local mouse = lp:GetMouse()

mouse.Button1Down:Connect(function()
    if not handActive then return end
    local target = mouse.Target
    if target then
        local character = target:FindFirstAncestorOfClass("Model")
        if character then
            local plr = Players:GetPlayerFromCharacter(character)
            if plr and plr ~= lp then
                updateTargetInfo(plr)
                handActive = false
                HandTool.BackgroundColor3 = COLOR_RED
                local s = Instance.new("Sound")
                s.SoundId = "rbxassetid://6026984224"
                s.Volume = 1
                s.Parent = SoundService
                s:Play()
                Debris:AddItem(s, 5)
                StarterGui:SetCore("SendNotification", {
                    Title = "SAP",
                    Text = "تم استهداف: " .. plr.Name,
                    Duration = 3
                })
            end
        end
    end
end)

--============================================================
-- أزرار الاستهداف (مع تبديل اللون أخضر/أحمر)
--============================================================
local function createTargetButton(text, xPos, yPos, callback, isToggle)
    local Btn = Instance.new("TextButton", TargetPage)
    Btn.BackgroundColor3 = COLOR_RED
    Btn.BackgroundTransparency = 0.2
    Btn.BorderSizePixel = 0
    Btn.Position = UDim2.new(0, xPos, 0, yPos)
    Btn.Size = UDim2.new(0, 110, 0, 28)
    Btn.Font = Enum.Font.Oswald
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextScaled = true
    Btn.TextWrapped = true

    local Corner = Instance.new("UICorner", Btn)
    Corner.CornerRadius = UDim.new(0, 8)

    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Color = COLOR_RED
    Stroke.Thickness = 2

    local toggled = false

    Btn.MouseButton1Click:Connect(function()
        if isToggle then
            toggled = not toggled
            if toggled then
                Btn.BackgroundColor3 = COLOR_GREEN
                Stroke.Color = COLOR_GREEN
            else
                Btn.BackgroundColor3 = COLOR_RED
                Stroke.Color = COLOR_RED
            end
        else
            -- تأثير وميض
            local original = Btn.BackgroundColor3
            Btn.BackgroundColor3 = COLOR_GREEN
            task.wait(0.15)
            Btn.BackgroundColor3 = original
        end
        if callback then
            pcall(callback, Btn, toggled)
        end
    end)

    return Btn
end

-- دالة مساعدة للتحقق من الهدف
local function checkTarget()
    if not TargetPlayer then
        StarterGui:SetCore("SendNotification", {
            Title = "SAP",
            Text = "الرجاء اختيار هدف أولاً",
            Duration = 3
        })
        return false
    end
    return true
end

-- الحصول على HRP للاعب
local function getHRP(plr)
    if plr and plr.Character then
        return plr.Character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

--============================================================
-- الأزرار
--============================================================
createTargetButton("دفع", 15, 120, function()
    if not checkTarget() then return end
    local hrp = getHRP(TargetPlayer)
    local myHRP = getHRP(lp)
    if hrp and myHRP then
        hrp.Velocity = (hrp.Position - myHRP.Position).Unit * 100
    end
end)

createTargetButton("مشاهدة", 140, 120, function(Btn, toggled)
    if not checkTarget() then return end
    if toggled then
        task.spawn(function()
            while TargetPlayer and Btn.BackgroundColor3 == COLOR_GREEN do
                local hrp = getHRP(TargetPlayer)
                local cam = workspace.CurrentCamera
                if hrp and cam then
                    cam.CameraType = Enum.CameraType.Scriptable
                    cam.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 5, -10), hrp.Position)
                end
                task.wait(0.05)
            end
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        end)
    end
end, true)

createTargetButton("تركيز", 15, 160, function(Btn, toggled)
    if not checkTarget() then return end
    if toggled then
        task.spawn(function()
            while TargetPlayer and Btn.BackgroundColor3 == COLOR_GREEN do
                local hrp = getHRP(TargetPlayer)
                local cam = workspace.CurrentCamera
                if hrp and cam then
                    cam.CameraType = Enum.CameraType.Scriptable
                    cam.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 3, 8), hrp.Position)
                end
                task.wait(0.05)
            end
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        end)
    end
end, true)

createTargetButton("بانغ", 140, 160, function()
    if not checkTarget() then return end
    local hrp = getHRP(TargetPlayer)
    local myHRP = getHRP(lp)
    if hrp and myHRP then
        for _ = 1, 10 do
            hrp.CFrame = myHRP.CFrame
            task.wait(0.02)
        end
    end
end)

createTargetButton("وقوف", 15, 200, function()
    if not checkTarget() then return end
    local hum = TargetPlayer.Character and TargetPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Sit = false end
end)

createTargetButton("الجلوس على الرأس", 140, 200, function(Btn, toggled)
    if not checkTarget() then return end
    if toggled then
        task.spawn(function()
            while TargetPlayer and Btn.BackgroundColor3 == COLOR_GREEN do
                local hrp = getHRP(TargetPlayer)
                local myHRP = getHRP(lp)
                if hrp and myHRP then
                    myHRP.CFrame = hrp.CFrame * CFrame.new(0, 3, 0)
                end
                task.wait(0.05)
            end
        end)
    end
end, true)

createTargetButton("دوغي", 15, 240, function()
    if not checkTarget() then return end
    local hrp = getHRP(TargetPlayer)
    if hrp then
        hrp.Size = Vector3.new(50, 50, 50)
        task.wait(1)
        hrp.Size = Vector3.new(2, 2, 1)
    end
end)

createTargetButton("الحقيبة", 140, 240, function()
    if not checkTarget() then return end
    local bp = TargetPlayer:FindFirstChildOfClass("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = TargetPlayer.Character
            end
        end
    end
end)

createTargetButton("سحب", 15, 280, function(Btn, toggled)
    if not checkTarget() then return end
    if toggled then
        task.spawn(function()
            while TargetPlayer and Btn.BackgroundColor3 == COLOR_GREEN do
                local hrp = getHRP(TargetPlayer)
                local myHRP = getHRP(lp)
                if hrp and myHRP then
                    myHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, 2)
                end
                task.wait(0.05)
            end
        end)
    end
end, true)

createTargetButton("انتقال", 140, 280, function()
    if not checkTarget() then return end
    local hrp = getHRP(TargetPlayer)
    local myHRP = getHRP(lp)
    if hrp and myHRP then
        myHRP.CFrame = hrp.CFrame
    end
end)

createTargetButton("دفع قوي", 15, 320, function()
    if not checkTarget() then return end
    local hrp = getHRP(TargetPlayer)
    if hrp then
        hrp.Velocity = Vector3.new(0, 500, 0)
    end
end)

createTargetButton("القائمة البيضاء", 140, 320, function(Btn, toggled)
    if not checkTarget() then return end
    if toggled then
        Btn.Text = "✓ " .. TargetPlayer.Name
    else
        Btn.Text = "القائمة البيضاء"
    end
end, true)

createTargetButton("جلوس في راسه", 15, 360, function(Btn, toggled)
    if not checkTarget() then return end
    if toggled then
        task.spawn(function()
            while TargetPlayer and Btn.BackgroundColor3 == COLOR_GREEN do
                local hrp = getHRP(TargetPlayer)
                local myHRP = getHRP(lp)
                if hrp and myHRP then
                    myHRP.CFrame = hrp.CFrame * CFrame.new(0, 3.5, 0)
                end
                task.wait(0.05)
            end
        end)
    end
end, true)

createTargetButton("ضرب مؤخرة", 140, 360, function(Btn, toggled)
    if not checkTarget() then return end
    if toggled then
        task.spawn(function()
            while TargetPlayer and Btn.BackgroundColor3 == COLOR_GREEN do
                local hrp = getHRP(TargetPlayer)
                local myHRP = getHRP(lp)
                if hrp and myHRP then
                    myHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, 3)
                end
                task.wait(0.1)
            end
        end)
    end
end, true)

createTargetButton("تقليد الكلام", 15, 400, function(Btn, toggled)
    if not checkTarget() then return end
    if toggled then
        StarterGui:SetCore("SendNotification", {
            Title = "SAP",
            Text = "جاري تقليد كلام: " .. TargetPlayer.Name,
            Duration = 3
        })
    end
end, true)

createTargetButton("سماع", 140, 400, function(Btn, toggled)
    if not checkTarget() then return end
    if toggled then
        StarterGui:SetCore("SendNotification", {
            Title = "SAP",
            Text = "جاري سماع: " .. TargetPlayer.Name,
            Duration = 3
        })
    end
end, true)

createTargetButton("بانق عكسي", 15, 440, function()
    if not checkTarget() then return end
    local hrp = getHRP(TargetPlayer)
    local myHRP = getHRP(lp)
    if hrp and myHRP then
        for _ = 1, 5 do
            myHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, -5)
            task.wait(0.05)
        end
    end
end)

createTargetButton("يمص", 140, 440, function(Btn, toggled)
    if not checkTarget() then return end
    if toggled then
        task.spawn(function()
            while TargetPlayer and Btn.BackgroundColor3 == COLOR_GREEN do
                local head = TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("Head")
                local myHRP = getHRP(lp)
                if head and myHRP then
                    myHRP.CFrame = head.CFrame * CFrame.new(0, 0, 1)
                end
                task.wait(0.1)
            end
        end)
    end
end, true)

createTargetButton("تمص", 15, 480, function(Btn, toggled)
    if not checkTarget() then return end
    if toggled then
        task.spawn(function()
            while TargetPlayer and Btn.BackgroundColor3 == COLOR_GREEN do
                local head = TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("Head")
                local myHRP = getHRP(lp)
                if head and myHRP then
                    myHRP.CFrame = head.CFrame * CFrame.new(0, 0, 1)
                end
                task.wait(0.1)
            end
        end)
    end
end, true)

createTargetButton("سوها عليه", 140, 480, function(Btn, toggled)
    if not checkTarget() then return end
    if toggled then
        task.spawn(function()
            while TargetPlayer and Btn.BackgroundColor3 == COLOR_GREEN do
                local hrp = getHRP(TargetPlayer)
                local myHRP = getHRP(lp)
                if hrp and myHRP then
                    myHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, 1.5)
                end
                task.wait(0.1)
            end
        end)
    end
end, true)

--============================================================
-- الوظائف العامة (اللاعب)
--============================================================
local savedPos = nil
local noclip = false

WalkSpeedBtn.MouseButton1Click:Connect(function()
    local targetSpeed = tonumber(WalkSpeedInput.Text)
    if targetSpeed and lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = targetSpeed end
    end
end)

JumpPowerBtn.MouseButton1Click:Connect(function()
    local targetJump = tonumber(JumpPowerInput.Text)
    if targetJump and lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.JumpPower = targetJump
            hum.UseJumpPower = true
        end
    end
end)

NoclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    NoclipBtn.BackgroundColor3 = noclip and COLOR_GREEN or COLOR_RED
end)

RunService.Stepped:Connect(function()
    if noclip and lp.Character then
        for _, part in pairs(lp.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

TeleportToolBtn.MouseButton1Click:Connect(function()
    local tool = Instance.new("Tool")
    tool.Name = "TP Click"
    tool.RequiresHandle = false
    tool.Activated:Connect(function()
        local mouse = lp:GetMouse()
        if mouse and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end)
    tool.Parent = lp.Backpack
end)

SaveCheckpointBtn.MouseButton1Click:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        savedPos = lp.Character.HumanoidRootPart.CFrame
    end
end)

ClearCheckpointBtn.MouseButton1Click:Connect(function()
    savedPos = nil
end)

RespawnBtn.MouseButton1Click:Connect(function()
    if lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = 0 end
    end
end)

lp.CharacterAdded:Connect(function(char)
    if savedPos then
        task.wait(0.5)
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if hrp then hrp.CFrame = savedPos end
    end
end)

--============================================================
-- تبديل التابات
--============================================================
HomeTab.MouseButton1Click:Connect(function()
    HomeTab.BackgroundColor3 = COLOR_RED
    PlayerTab.BackgroundColor3 = COLOR_RED_DARK
    TargetTab.BackgroundColor3 = COLOR_RED_DARK
    MainPage.Visible = true
    PlayerPage.Visible = false
    TargetPage.Visible = false
end)

PlayerTab.MouseButton1Click:Connect(function()
    PlayerTab.BackgroundColor3 = COLOR_RED
    HomeTab.BackgroundColor3 = COLOR_RED_DARK
    TargetTab.BackgroundColor3 = COLOR_RED_DARK
    MainPage.Visible = false
    PlayerPage.Visible = true
    TargetPage.Visible = false
end)

TargetTab.MouseButton1Click:Connect(function()
    TargetTab.BackgroundColor3 = COLOR_RED
    HomeTab.BackgroundColor3 = COLOR_RED_DARK
    PlayerTab.BackgroundColor3 = COLOR_RED_DARK
    MainPage.Visible = false
    PlayerPage.Visible = false
    TargetPage.Visible = true
end)

--============================================================
-- زر الفتح/الإغلاق
--============================================================
local Toggle = Instance.new("ImageButton", ScreenGui)
Toggle.BackgroundTransparency = 1
Toggle.AnchorPoint = Vector2.new(0.5, 0.5)
Toggle.Position = UDim2.new(0, 75, 0.5, 0)
Toggle.Size = UDim2.new(0, 64, 0, 64)
Toggle.Image = "rbxassetid://132784270564779"
Toggle.Active = true
Toggle.Draggable = true

local ToggleCorner = Instance.new("UICorner", Toggle)
ToggleCorner.CornerRadius = UDim.new(0, 10)

Toggle.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

task.spawn(function()
    while Main.Parent do
        BGSpin.Rotation = BGSpin.Rotation + 7
        task.wait(0.01)
    end
end)

task.spawn(function()
    while Toggle.Parent do
        Toggle.Rotation = Toggle.Rotation + 7
        task.wait(0.01)
    end
end)

task.spawn(function()
    local IntroSound = Instance.new("Sound")
    IntroSound.SoundId = "rbxassetid://3398620867"
    IntroSound.Volume = 1
    IntroSound.Parent = SoundService
    IntroSound:Play()
    Debris:AddItem(IntroSound, 5)

    StarterGui:SetCore("SendNotification", {
        Title = "SAP",
        Text = "SAP",
        Duration = 5
    })

    local Tween = TweenService:Create(Main,
        TweenInfo.new(1.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
        { Position = UDim2.new(0.5, 0, 0.5, 0) }
    )
    Tween:Play()
end)
