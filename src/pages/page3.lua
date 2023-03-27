local composer = require("composer")
local physics = require("physics")

physics.start()
physics.setGravity(0, 0)
local scene = composer.newScene()

local backButton
local forwardButton
local background
local magnet
local knife

local function onBackPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene("src.pages.page2", "fade")

        return true
    end
end

local function onNextPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene(string.format("src.pages.page4"), "fade")

        return true
    end
end

local function onDragKnife(event) 
    onDragObj(event, knife)
end

local function onDragObj(event, obj)
    if event.phase == "began" then
        display.getCurrentStage():setFocus(obj)
        obj.isFocus = true
        obj.deltaX = event.x - obj.x
        obj.deltaY = event.y - obj.y
    elseif event.phase == "moved" then
        obj.x = event.x - obj.deltaX
        obj.y = event.y - obj.deltaY
    elseif event.phase == "ended" or event.phase == "cancelled" then
        display.getCurrentStage():setFocus(nil)
        obj.isFocus = false
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

    local instructionsText = display.newImage('src/assets/texts/page3Instructions.png', display.actualContentWidth,
        display.actualContentHeight)
    instructionsText.x = display.contentWidth * 0.32
    instructionsText.y = display.contentHeight * 0.86
    sceneGroup:insert(instructionsText)

    local text = display.newImage('src/assets/texts/page3Text.png', display.actualContentWidth,
        display.actualContentHeight)
    text.x = display.contentWidth * 5 / 10
    text.y = display.contentHeight * 2 / 20
    sceneGroup:insert(text)

    magnet = display.newImage('src/assets/images/squareMagnet.png', display.contentWidth,
        display.contentWidth)
    magnet.x = display.contentWidth * 0.6
    magnet.y = display.contentHeight * 0.6
    sceneGroup:insert(magnet)
    physics.addBody(magnet, "dinamic", { radius = 50, friction = 1 })
    magnet.isFixedRotation = true

    knife = display.newImage('src/assets/images/Knife.png', display.contentWidth,
        display.contentWidth)    
    knife.x = display.contentWidth * 0.2
    knife.y = display.contentHeight * 0.6
    knife:scale(-0.03, 0.03)
    sceneGroup:insert(knife)
    physics.addBody(knife, "dinamic", { isSensor=true, radius=10})
    knife.isFixedRotation = true

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
        knife:addEventListener("touch", onDragKnife)
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        backButton:removeEventListener("touch", backButton)
        forwardButton:removeEventListener("touch", forwardButton)
        background:removeEventListener("tap", background)
        knife:removeEventListener("touch", onDragKnife)
    elseif (phase == "did") then

    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
