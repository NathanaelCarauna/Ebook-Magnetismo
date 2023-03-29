local composer = require("composer")
local scene = composer.newScene()

local backButton
local forwardButton
local background
local ponteiro
local bussola
local device
local switch_device
local spark

local buttonSound, magnetHitSound

local buttonSoundOptions = {
    channel = 1,
    loops = 0,
    duration = 1000,
    fadein = 0,
    onComplete = function() audio.dispose(buttonSound) end
}

local magnetHitSoundOptions = {
    channel = 1,
    loops = 0,
    duration = 3000,
    fadein = 0
}

local function onBackPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        audio.play( buttonSound, buttonSoundOptions)
        composer.gotoScene("src.pages.page6", "slideRight")

        return true
    end
end
local function animateImage()
    print("animateImage called")
    transition.to(spark, { x = display.contentWidth * 0.22, y = display.contentHeight * 0.20, time = 1000 })
    transition.to(spark, { x = display.contentWidth * 0.22, y = display.contentHeight * 0.33, time = 500, delay = 1000 })
    transition.to(spark, { x = display.contentWidth * 0.77, y = display.contentHeight * 0.33, time = 1000, delay = 1500 })
    transition.to(spark, { x = display.contentWidth * 0.77, y = display.contentHeight * 0.20, time = 500, delay = 2500 })
    print("animateImage finished")

    timer.performWithDelay(3001, function()
        turnDeviceOFF()
    end)
end

local function updateCompass(event)
    if switch_device.isOn == false and event.xGravity ~= nil then
        local rotation = display.getCurrentStage().contentWidth / display.getCurrentStage().contentHeight
        rotation = 360 - math.deg(math.atan2(event.yGravity, event.xGravity)) + 90 - rotation
        ponteiro.rotation = rotation
    elseif switch_device.isOn then
        local diffX = spark.x - ponteiro.x
        local diffY = spark.y - ponteiro.y

        local angle = math.atan2(diffY, diffX) * 180 / math.pi
        ponteiro.rotation = angle - 90
    end
end

local function turnOnOff(event)
    if event.phase == "ended" then
        if switch_device.isOn then
            turnDeviceOFF()
        else
            audio.play(magnetHitSound, magnetHitSoundOptions)
            turnDeviceON()
        end
    end
end
function turnDeviceOFF()
    switch_device.isOn = false
    switch_device.fill.effect = "filter.grayscale"
    spark.isVisible = false
end

function turnDeviceON()
    switch_device.fill.effect = "filter.bloom"
    switch_device.isOn = true

    if (spark.isVisible == false) then
        spark.x = display.contentWidth * 0.77
        spark.y = display.contentHeight * 0.20
        spark.isVisible = true
        animateImage()
    end
end

local function onNextPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        audio.play( buttonSound, buttonSoundOptions)
        composer.gotoScene(string.format("src.pages.page8"), "slideLeft")

        return true
    end
end


function scene:create(event)
    local sceneGroup = self.view
    buttonSound = audio.loadSound( "src/assets/sounds/click-button.mp3")

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
    text.x = display.contentWidth * 5 / 10
    text.y = display.contentHeight * 0.74
    sceneGroup:insert(text)

    device = display.newImage('src/assets/images/device.png', display.actualContentWidth,
        display.actualContentHeight)
    device.x = display.contentWidth * 5 / 10 + 5
    device.y = display.contentHeight * 6 / 20
    device:scale(1, 1)
    sceneGroup:insert(device)

    bussola = display.newImage('src/assets/images/bussola.png', display.actualContentWidth,
        display.actualContentHeight)
    bussola.x = display.contentWidth * 5 / 10
    bussola.y = display.contentHeight * 0.263
    bussola:scale(0.05, 0.05)
    sceneGroup:insert(bussola)

    ponteiro = display.newImage('src/assets/images/bussola_ponteiro.png', display.actualContentWidth,
        display.actualContentHeight)
    ponteiro.x = display.contentWidth * 5 / 10
    ponteiro.y = display.contentHeight * 0.263
    ponteiro:scale(0.05, 0.05)
    sceneGroup:insert(ponteiro)

    spark = display.newImage('src/assets/images/spark.png', display.actualContentWidth,
        display.actualContentHeight)
    spark.x = display.contentWidth * 0.77
    spark.y = display.contentHeight * 0.20
    spark:scale(0.1, 0.1)
    spark.isVisible = false
    sceneGroup:insert(spark)

    switch_device = display.newImage('src/assets/images/switch_device.png', display.actualContentWidth,
        display.actualContentHeight)
    switch_device.x = display.contentWidth * 7 / 10
    switch_device.y = display.contentHeight * 5 / 10
    switch_device.fill.effect = "filter.grayscale"
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
        buttonSound = audio.loadSound( "src/assets/sounds/click-button.mp3")
        magnetHitSound = audio.loadSound( "src/assets/sounds/electric-hum.mp3")
        backButton.touch = onBackPage
        backButton:addEventListener("touch", backButton)

        forwardButton.touch = onNextPage
        forwardButton:addEventListener("touch", forwardButton)
        Runtime:addEventListener("accelerometer", updateCompass)
        Runtime:addEventListener("enterFrame", updateCompass)
        switch_device:addEventListener("touch", turnOnOff)
        switch_device.fill.effect = "filter.grayscale"
        switch_device.isOn = false
    elseif (phase == "did") then
       
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
        Runtime:removeEventListener("enterFrame", updateCompass)
        switch_device:removeEventListener("touch", turnOnOff)
        spark.isVisible = false
    elseif (phase == "did") then

    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
