local composer = require("composer")
local scene = composer.newScene()

local backButton
local forwardButton
local background
local meteor

local function onBackPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene("src.pages.page7", "slideRight")

        return true
    end
end

local function onNextPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene(string.format("src.pages.endpage"), "slideLeft")

        return true
    end
end

local function moveMeteor(event)
    local xGravity = event.xGravity
    local zGravity = event.yGravity

    local moveX = xGravity * 10 -- multiplicador para controlar a velocidade de movimento
    local moveY = -zGravity * 10 -- multiplicador para controlar a velocidade de movimento

    meteor.x = meteor.x + moveX
    meteor.y = meteor.y + moveY
end


function scene:create(event)
    local sceneGroup = self.view

    background = display.newImage('src/assets/images/page2BackGround.png', display.actualContentWidth, display
        .actualContentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0
    background.y = 0
    sceneGroup:insert(background)

    local instructionsText = display.newImage('src/assets/texts/page8Instructions.png', display.actualContentWidth,
        display.actualContentHeight)
    instructionsText.x = display.contentWidth * 3 / 10
    instructionsText.y = display.contentHeight * 0.49
    sceneGroup:insert(instructionsText)

    local text = display.newImage('src/assets/texts/page8Text.png', display.actualContentWidth,
        display.actualContentHeight)
    text.x = display.contentWidth * 5 / 10
    text.y = display.contentHeight * 0.2
    sceneGroup:insert(text)

    meteor = display.newImage('src/assets/images/meteor.png', display.actualContentWidth,
        display.actualContentHeight)
    meteor.x = display.contentWidth * 9 / 10
    meteor.y = display.contentHeight * 0.6
    meteor:scale(0.1, 0.1)
    sceneGroup:insert(meteor)

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
        Runtime:addEventListener("accelerometer", moveMeteor)
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        meteor.x = display.contentWidth * 9 / 10
        meteor.y = display.contentHeight * 0.6

        backButton:removeEventListener("touch", backButton)
        forwardButton:removeEventListener("touch", forwardButton)
        background:removeEventListener("tap", background)
        Runtime:removeEventListener("accelerometer", moveMeteor)
    elseif (phase == "did") then

    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
