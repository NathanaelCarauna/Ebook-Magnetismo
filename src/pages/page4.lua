local composer = require("composer")
local scene = composer.newScene()

local backButton
local forwardButton
local background
local ponteiro
local bussola

local buttonSound

local buttonSoundOptions = {
    channel = 1,
    loops = 0,
    duration = 1000,
    fadein = 0,
    onComplete = function() audio.dispose(buttonSound) end
}

local function onBackPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        audio.play( buttonSound, buttonSoundOptions)
        composer.gotoScene("src.pages.page3", "slideRight")

        return true
    end
end

local function onNextPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        audio.play( buttonSound, buttonSoundOptions)
        composer.gotoScene(string.format("src.pages.page5"), "slideLeft")

        return true
    end
end

local function updateCompass(event)
    local rotation = display.getCurrentStage().contentWidth / display.getCurrentStage().contentHeight
    rotation = 360 - math.deg(math.atan2(event.yGravity, event.xGravity)) + 90 - rotation
    ponteiro.rotation = rotation
end

function scene:create(event)
    local sceneGroup = self.view
    buttonSound = audio.loadSound( "src/assets/sounds/click-button.mp3")

    background = display.newImage('src/assets/images/page3Background.png', display.actualContentWidth, display
        .actualContentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0
    background.y = 0
    sceneGroup:insert(background)

    local instructionsText = display.newImage('src/assets/texts/page4Instructions.png', display.actualContentWidth,
    display.actualContentHeight)
    instructionsText.x = display.contentWidth * 0.32
    instructionsText.y = display.contentHeight * 0.86
    sceneGroup:insert(instructionsText)

    local text = display.newImage('src/assets/texts/page4Text.png', display.actualContentWidth,
    display.actualContentHeight)
    text.x = display.contentWidth * 5/10
    text.y = display.contentHeight * 3/20
    sceneGroup:insert(text)

    bussola = display.newImage('src/assets/images/bussola.png', display.actualContentWidth,
    display.actualContentHeight)
    bussola.x = display.contentWidth * 5/10
    bussola.y = display.contentHeight * 12/20
    bussola:scale(0.2, 0.2)
    sceneGroup:insert(bussola)

    ponteiro = display.newImage('src/assets/images/bussola_ponteiro.png', display.actualContentWidth,
    display.actualContentHeight)
    ponteiro.x = display.contentWidth * 5/10
    ponteiro.y = display.contentHeight * 12/20
    ponteiro:scale(0.2, 0.2)
    sceneGroup:insert(ponteiro)

    backButton = display.newImage('src/assets/buttons/blackButtonLeft.png', display.contentWidth,
        display.contentWidth)
    backButton.x = display.contentWidth * 0.1
    backButton.y = display.contentHeight * 0.9
    sceneGroup:insert(backButton)

    forwardButton = display.newImage('src/assets/buttons/blackButtonRight.png', display.contentWidth,
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
        buttonSound = audio.loadSound( "src/assets/sounds/click-button.mp3")
        backButton.touch = onBackPage
        backButton:addEventListener("touch", backButton)

        forwardButton.touch = onNextPage
        forwardButton:addEventListener("touch", forwardButton)        
        Runtime:addEventListener("accelerometer", updateCompass)
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
