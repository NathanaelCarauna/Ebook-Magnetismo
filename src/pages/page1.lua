local composer = require("composer")
local scene = composer.newScene()

local backButton
local forwardButton
local background
local horseAnimationImage

local function onBackPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene("src.pages.home", "fade")

        return true
    end
end

local function onNextPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene(string.format("src.pages.page2"), "fade")

        return true
    end
end


function scene:create(event)
    local sceneGroup = self.view

    background = display.newImageRect('src/assets/images/page1Background.png', display.actualContentWidth, display
        .actualContentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0
    background.y = 0
    sceneGroup:insert(background)

    local instructionsText = display.newImageRect('src/assets/texts/Page1Instructions.png', display.actualContentWidth,
    display.actualContentHeight)
    instructionsText.x = display.contentWidth * 3/10
    instructionsText.y = display.contentHeight * 1/2
    instructionsText:scale(0.5,0.01)
    sceneGroup:insert(instructionsText)

    local text = display.newImageRect('src/assets/texts/page1Text.png', display.actualContentWidth,
    display.actualContentHeight)
    text.x = display.contentWidth * 5/10
    text.y = display.contentHeight * 4/20
    text:scale(0.9,0.35)
    sceneGroup:insert(text)

    local metal = display.newImageRect('src/assets/images/page1Metal.png', display.actualContentWidth,
    display.actualContentHeight)
    metal.x = display.contentWidth * 19/20
    metal.y = display.contentHeight * 0.718
    metal:scale(0.3,0.5)
    sceneGroup:insert(metal)


    backButton = display.newImageRect('src/assets/buttons/blackButtonLeft.png', display.contentWidth,
        display.contentWidth)
    backButton.x = display.contentWidth * 0.1
    backButton.y = display.contentHeight * 0.9
    backButton:scale(0.1, 0.1)
    sceneGroup:insert(backButton)

    forwardButton = display.newImageRect('src/assets/buttons/blackButtonRight.png', display.contentWidth,
        display.contentWidth)
    forwardButton.x = display.contentWidth * 0.9
    forwardButton.y = display.contentHeight * 0.9
    forwardButton:scale(0.1, 0.1)
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
