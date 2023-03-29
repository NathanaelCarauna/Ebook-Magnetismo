local composer = require("composer")
local scene = composer.newScene()

local backButton
local forwardButton
local background
local clip1, clip2, clip3, clip4, magnet

local function onBackPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene("src.pages.page5", "slideRight")

        return true
    end
end

local function onNextPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene(string.format("src.pages.page7"), "slideLeft")

        return true
    end
end

local function onDragObj(self, event)
    if event.phase == "began" then
        display.getCurrentStage():setFocus(self)
        self.isFocus = true
        self.deltaX = event.x - self.x
        self.deltaY = event.y - self.y
    elseif event.phase == "moved" then
        self.x = event.x - self.deltaX
        self.y = event.y - self.deltaY
    elseif event.phase == "ended" or event.phase == "cancelled" then
        display.getCurrentStage():setFocus(nil)
        self.isFocus = false
    end
end

function scene:create(event)
    local sceneGroup = self.view

    background = display.newImage('src/assets/images/page6Background.png', display.actualContentWidth, display
        .actualContentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0
    background.y = 0
    sceneGroup:insert(background)

    local instructionsText = display.newImage('src/assets/texts/page6Instructions.png', display.actualContentWidth,
    display.actualContentHeight)
    instructionsText.x = display.contentWidth * 2/10
    instructionsText.y = display.contentHeight * 0.48
    sceneGroup:insert(instructionsText)

    local text = display.newImage('src/assets/texts/page6Text.png', display.actualContentWidth,
    display.actualContentHeight)
    text.x = display.contentWidth * 5/10
    text.y = display.contentHeight * 0.2
    sceneGroup:insert(text)

    magnet = display.newImage('src/assets/images/umagnet.png', display.actualContentWidth,
    display.actualContentHeight)
    magnet.x = display.contentWidth * 0.5
    magnet.y = display.contentHeight * 0.5
    sceneGroup:insert(magnet)

    clip1 = display.newImage('src/assets/images/clip.png', display.actualContentWidth,
    display.actualContentHeight)
    clip1.x = display.contentWidth * 0.2
    clip1.y = display.contentHeight * 0.85
    sceneGroup:insert(clip1)

    clip2 = display.newImage('src/assets/images/clip.png', display.actualContentWidth,
    display.actualContentHeight)
    clip2.x = display.contentWidth * 0.4
    clip2.y = display.contentHeight * 0.85
    sceneGroup:insert(clip2)

    clip3 = display.newImage('src/assets/images/clip.png', display.actualContentWidth,
    display.actualContentHeight)
    clip3.x = display.contentWidth * 0.6
    clip3.y = display.contentHeight * 0.85
    sceneGroup:insert(clip3)

    clip4 = display.newImage('src/assets/images/clip.png', display.actualContentWidth,
    display.actualContentHeight)
    clip4.x = display.contentWidth * 0.8
    clip4.y = display.contentHeight * 0.85
    sceneGroup:insert(clip4)

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
        magnet.touch= onDragObj
        magnet:addEventListener("touch", magnet)
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        backButton:removeEventListener("touch", backButton)
        forwardButton:removeEventListener("touch", forwardButton)
        background:removeEventListener("tap", background)
        magnet:removeEventListener("touch", magnet)
    elseif (phase == "did") then

    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
