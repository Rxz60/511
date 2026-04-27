

local Lighting = game:GetService("Lighting")  
local Workspace = game:GetService("Workspace")  
local RunService = game:GetService("RunService")  
local Players = game:GetService("Players")  
local TweenService = game:GetService("TweenService")  
local UserInputService = game:GetService("UserInputService")  

local Player = Players.LocalPlayer  
local PlayerGui = Player:WaitForChild("PlayerGui")  
local Camera = Workspace.CurrentCamera  

local originalSettings = {}  
local effects = {}  
local shaderEnabled = false  
local foliageConnection = nil  
local motionBlurConnection = nil  


local function deepcopy(orig)  
    if type(orig) ~= 'table' then return orig end  
    local copy = {}  
    for k, v in pairs(orig) do copy[deepcopy(k)] = deepcopy(v) end  
    setmetatable(copy, deepcopy(getmetatable(orig)))  
    return copy  
end  


  
local Presets = {
    Dynamic = { Name="Dynamic", Technology="Future", Brightness=2.2, ShadowSoftness=0.15, 
        Bloom={Enabled=true, Intensity=0.3, Size=60, Threshold=0.7},
        ColorCorrection={Enabled=true, Brightness=0.05, Contrast=0.1, Saturation=0.25, TintColor=Color3.fromRGB(255,255,255)},
        SunRays={Enabled=true, Intensity=0.1, Spread=0.25},
        Atmosphere={Enabled=true, Density=0.35, Offset=0.1, Haze=1.2, Decay=Color3.fromRGB(150,170,200)},
        DepthOfField={Enabled=false, FarIntensity=0.1, FocusDistance=0, InFocusRadius=20},
        ChromaticAberration={Enabled=false},
        Water={Color=Color3.fromRGB(100,175,220), Transparency=0.6, WaveSize=0.1, WaveSpeed=0.05}
    },
    Ultra = { Name="ULTRA", Technology="Future", Brightness=3, ShadowSoftness=0.05,
        Bloom={Enabled=true, Intensity=0.6, Size=80, Threshold=0.5},
        ColorCorrection={Enabled=true, Brightness=0.1, Contrast=0.2, Saturation=0.3, TintColor=Color3.fromRGB(255,230,200)},
        SunRays={Enabled=true, Intensity=0.3, Spread=0.3},
        Atmosphere={Enabled=true, Density=0.4, Offset=0.2, Haze=1.5, Decay=Color3.fromRGB(180,190,210)},
        DepthOfField={Enabled=true, FarIntensity=0.1, FocusDistance=0, InFocusRadius=20},
        ChromaticAberration={Enabled=true},
        Water={Color=Color3.fromRGB(40,80,120), Transparency=0.4, WaveSize=0.05, WaveSpeed=0.02}
    },
    Vibrant = { Name="QUALITY", Technology="Future", Brightness=2.5, ShadowSoftness=0.2,
        Bloom={Enabled=true, Intensity=0.5, Size=70, Threshold=0.6},
        ColorCorrection={Enabled=true, Brightness=0.15, Contrast=0.25, Saturation=0.6, TintColor=Color3.fromRGB(255,250,240)},
        SunRays={Enabled=true, Intensity=0.2, Spread=0.4},
        Atmosphere={Enabled=true, Density=0.2, Offset=0, Haze=1, Decay=Color3.fromRGB(200,180,160)},
        DepthOfField={Enabled=false, FarIntensity=0.1, FocusDistance=0, InFocusRadius=20},
        ChromaticAberration={Enabled=false},
        Water={Color=Color3.fromRGB(80,200,255), Transparency=0.5, WaveSize=0.15, WaveSpeed=0.1}
    },
    Night = { Name="Night Mode", Technology="Future", Brightness=1.5, ShadowSoftness=0.3,
        Bloom={Enabled=true, Intensity=0.4, Size=100, Threshold=0.8},
        ColorCorrection={Enabled=true, Brightness=-0.1, Contrast=0.05, Saturation=0.15, TintColor=Color3.fromRGB(200,220,255)},
        SunRays={Enabled=false, Intensity=0.05, Spread=0.5},
        Atmosphere={Enabled=true, Density=0.6, Offset=0.5, Haze=2, Decay=Color3.fromRGB(50,60,80)},
        DepthOfField={Enabled=false, FarIntensity=0.1, FocusDistance=0, InFocusRadius=20},
        ChromaticAberration={Enabled=false},
        Water={Color=Color3.fromRGB(30,50,80), Transparency=0.3, WaveSize=0.1, WaveSpeed=0.05}
    }
}
local currentSettings = deepcopy(Presets.Dynamic)

  
local function backupOriginals()
    originalSettings = {Lighting={}, Terrain={}, Effects={}}
    local lightingProps = {"Ambient","Brightness","ColorShift_Top","EnvironmentDiffuseScale","EnvironmentSpecularScale","GlobalShadows","OutdoorAmbient","ShadowSoftness","Technology"}
    for _,prop in ipairs(lightingProps) do originalSettings.Lighting[prop] = Lighting[prop] end
    local terrainProps = {"WaterColor","WaterTransparency","WaterWaveSize","WaterWaveSpeed"}
    for _,prop in ipairs(terrainProps) do originalSettings.Terrain[prop] = Workspace.Terrain[prop] end
    for _,child in ipairs(Lighting:GetChildren()) do
        if child:IsA("PostEffect") then originalSettings.Effects[child.Name] = child:Clone() end
    end
end

local function restoreOriginals()
    if not next(originalSettings) then return end
    for prop,value in pairs(originalSettings.Lighting) do Lighting[prop] = value end
    for prop,value in pairs(originalSettings.Terrain) do Workspace.Terrain[prop] = value end
    for _,child in ipairs(Lighting:GetChildren()) do
        if child:IsA("PostEffect") and not originalSettings.Effects[child.Name] then child:Destroy() end
    end
    for name,effect in pairs(originalSettings.Effects) do
        local existing = Lighting:FindFirstChild(name)
        if existing then existing:Destroy() end
        effect:Clone().Parent = Lighting
    end
end

  
local function getOrCreateEffect(name,class)
    if effects[name] and effects[name].Parent then return effects[name] end
    local effect = Lighting:FindFirstChild(name) or Instance.new(class)
    effect.Name = name
    effect.Parent = Lighting
    effects[name] = effect
    return effect
end

local function applyAllSettings()
    if not shaderEnabled then return end
    Lighting.Technology = Enum.Technology[currentSettings.Technology]
    Lighting.Brightness = currentSettings.Brightness
    Lighting.ShadowSoftness = currentSettings.ShadowSoftness
    Workspace.Terrain.WaterColor = currentSettings.Water.Color
    Workspace.Terrain.WaterTransparency = currentSettings.Water.Transparency
    Workspace.Terrain.WaterWaveSize = currentSettings.Water.WaveSize
    Workspace.Terrain.WaterWaveSpeed = currentSettings.Water.WaveSpeed

    local effectMap = {Bloom="BloomEffect",ColorCorrection="ColorCorrectionEffect",SunRays="SunRaysEffect",Atmosphere="Atmosphere",DepthOfField="DepthOfFieldEffect"}
    for effectName,effectSettings in pairs(currentSettings) do
        local class = effectMap[effectName]
        if class and type(effectSettings)=="table" and effectSettings.Enabled~=nil then
            local effect = getOrCreateEffect(effectName,class)
            for prop,value in pairs(effectSettings) do if prop~="Enabled" then effect[prop]=value end end
            effect.Enabled = effectSettings.Enabled
        end
    end

    
    local cc = getOrCreateEffect("ColorCorrection","ColorCorrectionEffect")
    if currentSettings.ChromaticAberration.Enabled then
        cc.TintColor = Color3.new(1.05,1,1)
    else
        cc.TintColor = currentSettings.ColorCorrection.TintColor
    end
end

  
local function startAnimations()
    if foliageConnection then foliageConnection:Disconnect() end
    foliageConnection = RunService.RenderStepped:Connect(function()
        local t=tick()
        local x = math.sin(t*0.5)*0.02
        local z = math.cos(t*0.5)*0.02
        local grass = Workspace.Terrain:FindFirstChild("Model") and Workspace.Terrain.Model:FindFirstChild("Grass")
        if grass then grass.CFrame = CFrame.new() + Vector3.new(x,0,z) end
    end)

    if motionBlurConnection then motionBlurConnection:Disconnect() end
    local blur = getOrCreateEffect("MotionBlur","BlurEffect")
    blur.Enabled = true
    blur.Size = 0
    local lastCFrame = Camera.CFrame
    motionBlurConnection = RunService.RenderStepped:Connect(function()
        local _,angle=(lastCFrame:ToObjectSpace(Camera.CFrame)):ToAxisAngle()
        blur.Size = math.min(24, angle*20)
        lastCFrame=Camera.CFrame
    end)
end

local function stopAnimations()
    if foliageConnection then foliageConnection:Disconnect(); foliageConnection=nil end
    if motionBlurConnection then motionBlurConnection:Disconnect(); motionBlurConnection=nil end
    if effects.MotionBlur then effects.MotionBlur:Destroy(); effects.MotionBlur=nil end
    local grass = Workspace.Terrain:FindFirstChild("Model") and Workspace.Terrain.Model:FindFirstChild("Grass")
    if grass then grass.CFrame = CFrame.new() end
end

  
local function enableShader()
    if shaderEnabled then return end
    backupOriginals()
    shaderEnabled=true
    applyAllSettings()
    startAnimations()
end

local function disableShader()
    if not shaderEnabled then return end
    shaderEnabled=false
    stopAnimations()
    restoreOriginals()
    effects={}
end


local screenGui = Instance.new("ScreenGui")
screenGui.Name="FaresOmniShaderGUI"
screenGui.ResetOnSpawn=false
screenGui.ZIndexBehavior=Enum.ZIndexBehavior.Global
screenGui.Parent=PlayerGui

local mainFrame=Instance.new("Frame")
mainFrame.Name="MainFrame"
mainFrame.Parent=screenGui
mainFrame.BackgroundColor3=Color3.fromRGB(25,25,25)
mainFrame.BorderColor3=Color3.fromRGB(218,165,32)
mainFrame.BorderSizePixel=2
mainFrame.Position=UDim2.new(0.03,0,0.1,0)
mainFrame.Size=UDim2.new(0.7,0,0.7,0)
mainFrame.Active=true
mainFrame.Draggable=true
local corner=Instance.new("UICorner"); corner.CornerRadius=UDim.new(0,8); corner.Parent=mainFrame

local header=Instance.new("Frame")
header.Name="Header"
header.Parent=mainFrame
header.BackgroundColor3=Color3.fromRGB(35,35,35)
header.Size=UDim2.new(1,0,0,50)
local headerCorner=Instance.new("UICorner"); headerCorner.CornerRadius=UDim.new(0,8); headerCorner.Parent=header

local titleLabel=Instance.new("TextLabel")
titleLabel.Name="Title"
titleLabel.Parent=header
titleLabel.BackgroundTransparency=1
titleLabel.Position=UDim2.new(0,10,0,0)
titleLabel.Size=UDim2.new(1,-20,0,30)
titleLabel.Font=Enum.Font.GothamBold
titleLabel.Text="FARES SCRIPT-SHADERv1"
titleLabel.TextColor3=Color3.fromRGB(218,165,32)
titleLabel.TextSize=18
titleLabel.TextXAlignment=Enum.TextXAlignment.Left

local mainToggle=Instance.new("TextButton")
mainToggle.Name="MainToggle"
mainToggle.Parent=header
mainToggle.BackgroundColor3=Color3.fromRGB(200,40,40)
mainToggle.Position=UDim2.new(1,-60,0.5,-12)
mainToggle.Size=UDim2.new(0,50,0,24)
mainToggle.Font=Enum.Font.GothamBold
mainToggle.Text="شغل"
mainToggle.TextColor3=Color3.fromRGB(255,255,255)
mainToggle.TextSize=14
local toggleCorner=Instance.new("UICorner"); toggleCorner.CornerRadius=UDim.new(0,6); toggleCorner.Parent=mainToggle

mainToggle.MouseButton1Click:Connect(function()
    if shaderEnabled then disableShader() mainToggle.Text="شغل" mainToggle.BackgroundColor3=Color3.fromRGB(200,40,40)
    else enableShader() mainToggle.Text="ON" mainToggle.BackgroundColor3=Color3.fromRGB(40,200,40) end
end)


local contentFrame=Instance.new("Frame")
contentFrame.Name="ContentFrame"
contentFrame.Parent=mainFrame
contentFrame.BackgroundTransparency=1
contentFrame.Position=UDim2.new(0,0,0,50)
contentFrame.Size=UDim2.new(1,0,1,-50)



local presetFrame = Instance.new("Frame")
presetFrame.Name = "PresetFrame"
presetFrame.Parent = contentFrame
presetFrame.BackgroundTransparency = 1
presetFrame.Size = UDim2.new(1, -20, 0, 40)
presetFrame.Position = UDim2.new(0, 10, 0, 10)

local presetLabel = Instance.new("TextLabel")
presetLabel.Parent = presetFrame
presetLabel.BackgroundTransparency = 1
presetLabel.Size = UDim2.new(0.3,0,1,0)
presetLabel.Position = UDim2.new(0,0,0,0)
presetLabel.Font = Enum.Font.GothamBold
presetLabel.Text = "لو ضغطت علي زر شغل بيشتغل! ولو ضغطت مره ثانيه بينفصل! "
presetLabel.TextColor3 = Color3.fromRGB(200,200,200)
presetLabel.TextSize = 7.8
presetLabel.TextXAlignment = Enum.TextXAlignment.Left

local buttonsHolder = Instance.new("Frame")
buttonsHolder.Name = "ButtonsHolder"
buttonsHolder.Parent = presetFrame
buttonsHolder.BackgroundTransparency = 1
buttonsHolder.Size = UDim2.new(0.7,0,1,0)
buttonsHolder.Position = UDim2.new(0.3,5,0,0)

local buttonLayout = Instance.new("UIListLayout")
buttonLayout.Parent = buttonsHolder
buttonLayout.FillDirection = Enum.FillDirection.Horizontal
buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
buttonLayout.Padding = UDim.new(0,5)


local function createPresetButton(presetName, layoutOrder)
    local button = Instance.new("TextButton")
    button.Name = presetName
    button.LayoutOrder = layoutOrder
    button.Parent = buttonsHolder
    button.BackgroundColor3 = Color3.fromRGB(50,50,50)
    button.Size = UDim2.new(0,70,1,0)
    button.Font = Enum.Font.Gotham
    button.Text = Presets[presetName].Name
    button.TextColor3 = Color3.fromRGB(220,220,220)
    button.TextSize = 14

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,6)
    btnCorner.Parent = button

    button.MouseButton1Click:Connect(function()
        currentSettings = deepcopy(Presets[presetName])
        applyAllSettings()
    end)

    return button
end


createPresetButton("Dynamic",1)
createPresetButton("Ultra",2)
createPresetButton("Vibrant",3)
createPresetButton("Night",4)


  
local settingsList=Instance.new("ScrollingFrame")
settingsList.Name="SettingsList"
settingsList.Parent=contentFrame
settingsList.BackgroundColor3=Color3.fromRGB(30,30,30)
settingsList.BorderSizePixel=0
settingsList.Position=UDim2.new(0,0,0,50)
settingsList.Size=UDim2.new(1,0,1,-50)
settingsList.CanvasSize=UDim2.new(0,0,0,0)
settingsList.ScrollBarThickness=6

local listLayout=Instance.new("UIListLayout")
listLayout.Parent=settingsList
listLayout.SortOrder=Enum.SortOrder.LayoutOrder
listLayout.Padding=UDim.new(0,10)

local function createSlider(parent,name,min,max,initialValue,callback)
    local frame=Instance.new("Frame")
    frame.Name=name.."Slider"
    frame.Parent=parent
    frame.BackgroundTransparency=1
    frame.Size=UDim2.new(1,-20,0,40)
    frame.Position=UDim2.new(0,10,0,0)

    local label=Instance.new("TextLabel")
    label.Parent=frame
    label.BackgroundTransparency=1
    label.Size=UDim2.new(0.5,0,0,20)
    label.Font=Enum.Font.Gotham
    label.Text=name
    label.TextColor3=Color3.fromRGB(200,200,200)
    label.TextSize=14
    label.TextXAlignment=Enum.TextXAlignment.Left

    local valueLabel=Instance.new("TextLabel")
    valueLabel.Parent=frame
    valueLabel.BackgroundTransparency=1
    valueLabel.Position=UDim2.new(0.5,0,0,0)
    valueLabel.Size=UDim2.new(0.5,-10,0,20)
    valueLabel.Font=Enum.Font.Gotham
    valueLabel.Text=string.format("%.2f",initialValue)
    valueLabel.TextColor3=Color3.fromRGB(200,200,200)
    valueLabel.TextSize=14
    valueLabel.TextXAlignment=Enum.TextXAlignment.Right

    local sliderBg=Instance.new("Frame")
    sliderBg.Parent=frame
    sliderBg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    sliderBg.Position = UDim2.new(0, 0, 0, 25)
    sliderBg.Size = UDim2.new(1, 0, 0, 10)
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 5)
    sliderCorner.Parent = sliderBg

    local handle = Instance.new("TextButton")
    handle.Parent = sliderBg
    handle.BackgroundColor3 = Color3.fromRGB(218, 165, 32)
    handle.Size = UDim2.new(0, 10, 1, 0)
    handle.Text = ""
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 5)
    handleCorner.Parent = handle
    handle.Position = UDim2.new((initialValue - min) / (max - min), -5, 0, 0)

    local dragging = false

local function updateHandle(input)
    local pos = input.Position.X - sliderBg.AbsolutePosition.X
    local percentage = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1)
    local value = min + (max - min) * percentage
    handle.Position = UDim2.new(percentage, -5, 0, 0)
    valueLabel.Text = string.format("%.2f", value)
    callback(value)
end

sliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        updateHandle(input)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)


UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateHandle(input)
    end
end)

    return frame
end


createSlider(settingsList, "Brightness", 0, 5, currentSettings.Brightness, function(val)
    currentSettings.Brightness = val
    applyAllSettings()
end)
createSlider(settingsList, "Saturation", -1, 1, currentSettings.ColorCorrection.Saturation, function(val)
    currentSettings.ColorCorrection.Saturation = val
    applyAllSettings()
end)
createSlider(settingsList, "Contrast", -1, 1, currentSettings.ColorCorrection.Contrast, function(val)
    currentSettings.ColorCorrection.Contrast = val
    applyAllSettings()
end)
createSlider(settingsList, "Bloom Intensity", 0, 2, currentSettings.Bloom.Intensity, function(val)
    currentSettings.Bloom.Intensity = val
    applyAllSettings()
end)
createSlider(settingsList, "Bloom Size", 0, 100, currentSettings.Bloom.Size, function(val)
    currentSettings.Bloom.Size = val
    applyAllSettings()
end)
createSlider(settingsList, "Sun Rays", 0, 1, currentSettings.SunRays.Intensity, function(val)
    currentSettings.SunRays.Intensity = val
    applyAllSettings()
end)
createSlider(settingsList, "Haze", 0, 5, currentSettings.Atmosphere.Haze, function(val)
    currentSettings.Atmosphere.Haze = val
    applyAllSettings()
end)


settingsList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)


Player.CharacterRemoving:Connect(function()
    if shaderEnabled then disableShader() end
    pcall(function() screenGui:Destroy() end)
end)


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer


local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TimeGUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 190, 0, 155)
Frame.Position = UDim2.new(0, 20, 0, 60)
Frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true
Frame.BackgroundTransparency = 0.1
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -10, 0, 25)
Title.Position = UDim2.new(0, 5, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "FARES"
Title.TextColor3 = Color3.fromRGB(0, 255, 0) 

Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 150, 0)
Stroke.Thickness = 1.5
Stroke.Parent = Title
local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0,12)


local names = {"ليل","صبح","غروب"}
local buttons = {}
local selected = 1
local enabled = true


local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0,170,0,32)
Toggle.Position = UDim2.new(0,10,0,112)
Toggle.Text = "ON"
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
Toggle.Parent = Frame
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0,10)

Toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    Toggle.Text = enabled and "ON" or "OFF"
end)


for i,name in ipairs(names) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,50,0,32)
    btn.Position = UDim2.new(0,10 + (i-1)*60,0,45)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.Parent = Frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    buttons[i] = btn
end


local function selectButton(index)
    for i,btn in ipairs(buttons) do
        if i == index then
            btn.BackgroundColor3 = Color3.fromRGB(0,200,0)
        else
            btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
        end
    end
    selected = index
end

selectButton(1)

for i,btn in ipairs(buttons) do
    btn.MouseButton1Click:Connect(function()
        selectButton(i)
    end)
end


RunService.RenderStepped:Connect(function()
    if not enabled then return end

    Lighting.GeographicLatitude = 0
    Lighting.FogEnd = 1000

    if selected == 1 then
       

        Lighting.ClockTime = 0
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(70,70,90)
        Lighting.OutdoorAmbient = Color3.fromRGB(60,60,80)

    elseif selected == 2 then
        
        Lighting.ClockTime = 14
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.fromRGB(200,200,200)
        Lighting.OutdoorAmbient = Color3.fromRGB(200,200,200)

    elseif selected == 3 then
        
        Lighting.ClockTime = 18.5
        Lighting.Brightness = 2.5
        Lighting.Ambient = Color3.fromRGB(255,170,100)
        Lighting.OutdoorAmbient = Color3.fromRGB(255,140,80)
    end
end)

            Notify("سكربتات فارس", "تم تشغيل الشادر", 3)
        end
    })

    
