local composer = require("composer")
local scene = composer.newScene()

local backButton
local forwardButton
local background

local currentIndex = 1
local images = {}


local function onBackPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene("src.pages.page4", "fade")

        return true
    end
end

local function onNextPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene(string.format("src.pages.page6"), "fade")

        return true
    end
end

local function changePowderImage(event)
    print("SHAKE")
    local threshold = 1.2
    local xGravity = event.xGravity
    local yGravity = event.yGravity
    local zGravity = event.zGravity
    local magnitude = math.sqrt(xGravity*xGravity + yGravity*yGravity + zGravity*zGravity)
    if magnitude > threshold then
        currentIndex = currentIndex + 1
        if currentIndex > #images then
            currentIndex = 1
        end
        -- exibir a nova imagem
        for i = 1, #images do
            images[i].isVisible = (i == currentIndex)
        end
    end
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

    local instructionsText = display.newImage('src/assets/texts/page5Instructions.png', display.actualContentWidth,
    display.actualContentHeight)
    instructionsText.x = display.contentWidth * 3/10
    instructionsText.y = display.contentHeight * 0.02
    sceneGroup:insert(instructionsText)

    local text = display.newImage('src/assets/texts/page5Text.png', display.actualContentWidth,
    display.actualContentHeight)
    text.x = display.contentWidth * 5/10
    text.y = display.contentHeight * 0.67
    sceneGroup:insert(text)

    magnetPowder01 = display.newImage('src/assets/images/magnetPowder01.png', display.contentWidth,
        display.contentWidth)
    magnetPowder01.x = display.contentWidth * 0.5
    magnetPowder01.y = display.contentHeight * 0.3
    sceneGroup:insert(magnetPowder01)
    table.insert(images, magnetPowder01)

    magnetPowder02 = display.newImage('src/assets/images/magnetPowder02.png', display.contentWidth,
        display.contentWidth)
    magnetPowder02.x = display.contentWidth * 0.5
    magnetPowder02.y = display.contentHeight * 0.3
    magnetPowder02.isVisible = false
    sceneGroup:insert(magnetPowder02)
    table.insert(images, magnetPowder02)

    magnetPowder03 = display.newImage('src/assets/images/magnetPowder03.png', display.contentWidth,
        display.contentWidth)
    magnetPowder03.x = display.contentWidth * 0.5
    magnetPowder03.y = display.contentHeight * 0.3
    magnetPowder03.isVisible = false
    sceneGroup:insert(magnetPowder03)
    table.insert(images, magnetPowder03)

    magnetPowder04 = display.newImage('src/assets/images/magnetPowder04.png', display.contentWidth,
        display.contentWidth)
    magnetPowder04.x = display.contentWidth * 0.5
    magnetPowder04.y = display.contentHeight * 0.3
    magnetPowder04.isVisible = false
    sceneGroup:insert(magnetPowder04)
    table.insert(images, magnetPowder04)

    magnetPowder05 = display.newImage('src/assets/images/magnetPowder05.png', display.contentWidth,
        display.contentWidth)
    magnetPowder05.x = display.contentWidth * 0.5
    magnetPowder05.y = display.contentHeight * 0.3
    magnetPowder05.isVisible = false
    sceneGroup:insert(magnetPowder05)
    table.insert(images, magnetPowder05)

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
        system.setAccelerometerInterval( 100 )
        Runtime:addEventListener("accelerometer", changePowderImage)
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        backButton:removeEventListener("touch", backButton)
        forwardButton:removeEventListener("touch", forwardButton)
        background:removeEventListener("tap", background)
        Runtime:removeEventListener("accelerometer", changePowderImage)
    elseif (phase == "did") then

    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
