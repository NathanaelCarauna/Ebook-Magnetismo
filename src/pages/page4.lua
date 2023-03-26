local composer = require("composer")
local scene = composer.newScene()

local backButton
local forwardButton
local background

local function onBackPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene("src.pages.page3", "fade")

        return true
    end
end

local function onNextPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene(string.format("src.pages.page5"), "fade")

        return true
    end
end


function scene:create(event)
    local sceneGroup = self.view

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
    text.y = display.contentHeight * 2/20
    sceneGroup:insert(text)

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
        backButton.touch = onBackPage
        backButton:addEventListener("touch", backButton)

        forwardButton.touch = onNextPage
        forwardButton:addEventListener("touch", forwardButton)
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        backButton:removeEventListener("touch", backButton)
        forwardButton:removeEventListener("touch", forwardButton)
        background:removeEventListener("tap", background)
    elseif (phase == "did") then

    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
