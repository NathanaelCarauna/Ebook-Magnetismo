local composer = require("composer")
local scene = composer.newScene()

local backButton
local forwardButton
local background
local ponteiro
local bussola
local device
local switch_device

local function onBackPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene("src.pages.page6", "fade")

        return true
    end
end

local function updateCompass(event)
    local rotation = display.getCurrentStage().contentWidth / display.getCurrentStage().contentHeight
    rotation = 360 - math.deg(math.atan2(event.yGravity, event.xGravity)) + 90 - rotation
    ponteiro.rotation = rotation
end

local function turnOnOff(self, event)
    if self.isOn then
        self.isOn = false
        self.fill.effect = "filter.grayscale"
    else
        self.isOn = true
        self.fill.effect = nil
    end
    
end

local function onNextPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene(string.format("src.pages.page8"), "fade")

        return true
    end
end


function scene:create(event)
    local sceneGroup = self.view

    background = display.newImage('src/assets/images/page7Background.png', display.actualContentWidth, display
        .actualContentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0
    background.y = 0
    sceneGroup:insert(background)

    local instructionsText = display.newImage('src/assets/texts/page7Instructions.png', display.actualContentWidth,
    display.actualContentHeight)
    instructionsText.x = display.contentWidth * 0.5
    instructionsText.y = display.contentHeight * 0.02
    sceneGroup:insert(instructionsText)

    local text = display.newImage('src/assets/texts/page7Text.png', display.actualContentWidth,
    display.actualContentHeight)
    text.x = display.contentWidth * 5/10
    text.y = display.contentHeight * 0.74
    sceneGroup:insert(text)

    device = display.newImage('src/assets/images/device.png', display.actualContentWidth,
    display.actualContentHeight)
    device.x = display.contentWidth * 5/10 +5
    device.y = display.contentHeight * 6/20
    device:scale(1, 1)
    sceneGroup:insert(device)

    bussola = display.newImage('src/assets/images/bussola.png', display.actualContentWidth,
    display.actualContentHeight)
    bussola.x = display.contentWidth * 5/10
    bussola.y = display.contentHeight * 0.263
    bussola:scale(0.05, 0.05)
    sceneGroup:insert(bussola)

    ponteiro = display.newImage('src/assets/images/bussola_ponteiro.png', display.actualContentWidth,
    display.actualContentHeight)
    ponteiro.x = display.contentWidth * 5/10
    ponteiro.y = display.contentHeight * 0.263
    ponteiro:scale(0.05, 0.05)
    sceneGroup:insert(ponteiro)

    switch_device = display.newImage('src/assets/images/switch_device.png', display.actualContentWidth,
    display.actualContentHeight)    
    switch_device.x = display.contentWidth * 7/10
    switch_device.y = display.contentHeight * 5/10
    switch_device:scale(0.1, 0.1)
    sceneGroup:insert(switch_device)


    backButton = display.newImage('src/assets/buttons/lightButtonLeft.png', display.contentWidth,
        display.contentWidth)
    backButton.x = display.contentWidth * 0.1
    backButton.y = display.contentHeight * 0.9
    sceneGroup:insert(backButton)

    forwardButton = display.newImage('src/assets/buttons/lightButtonRight.png', display.contentWidth,
        display.contentWidth)
    forwardButton.x = display.contentWidth * 0.9
    forwardButton.y = display.contentHeight * 0.9
    sceneGroup:insert(forwardButton)
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then

    elseif (phase == "did") then
        backButton.touch = onBackPage
        backButton:addEventListener("touch", backButton)

        forwardButton.touch = onNextPage
        forwardButton:addEventListener("touch", forwardButton)
        Runtime:addEventListener("accelerometer", updateCompass)
        switch_device.touch = turnOnOff
        switch_device:addEventListener("touch", switch_device) 
        switch_device.isOn = true
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        backButton:removeEventListener("touch", backButton)
        forwardButton:removeEventListener("touch", forwardButton)
        background:removeEventListener("tap", background)
        Runtime:removeEventListener("accelerometer", updateCompass)
    elseif (phase == "did") then

    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
