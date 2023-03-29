local composer = require("composer")
local physics = require("physics")

physics.start()
physics.setGravity(0, 0)
local ATTRACTION_DISTANCE = 150
local direction = -1

local scene = composer.newScene()

local backButton
local forwardButton
local background
local turnButton
local fixedMagnet
local magnet

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
    duration = 1000,
    fadein = 0
}

local function onBackPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        audio.play(buttonSound, buttonSoundOptions)
        composer.gotoScene("src.pages.page1", "slideRight")

        return true
    end
end

local function onNextPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        audio.play(buttonSound, buttonSoundOptions)
        composer.gotoScene(string.format("src.pages.page3"), "slideLeft")

        return true
    end
end


local function onMagnetTouch(event)
    onDragObj(event, magnet)
end

function onDragObj(event, obj)
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

local function onTurnButtonTouch(event)
    if event.phase == "ended" then
        -- Rotacione o ima fixado em 90 graus quando o botão for clicado
        fixedMagnet.rotation = fixedMagnet.rotation + 180
        if direction == -1 then
            direction = 1
        else
            direction = -1
        end
    end
    return true
end


local function atrairObjeto()
    local distancia = math.sqrt((magnet.x - fixedMagnet.x) ^ 2 + (magnet.y - fixedMagnet.y) ^ 2)
    if distancia < ATTRACTION_DISTANCE then
        local forca = direction * 200 * (100 - distancia)
        local direcaoX = fixedMagnet.x - magnet.x
        local direcaoY = fixedMagnet.y - magnet.y
        magnet:applyForce(direcaoX * forca, direcaoY * forca, magnet.x, magnet.y)
    else
        magnet:setLinearVelocity(0, 0)
    end
end

local function onCollision(event)
    if (event.phase == "began") then
        magnet:removeEventListener("enterFrame", atrairObjeto)
        magnet.x = fixedMagnet.x
        magnet.y = fixedMagnet.y

        audio.play(magnetHitSound, magnetHitSoundOptions)
    elseif (event.phase == "ended") then
        magnet:addEventListener("enterFrame", atrairObjeto)
    end
end

function scene:create(event)
    local sceneGroup = self.view
    buttonSound = audio.loadSound("src/assets/sounds/click-button.mp3")
    magnetHitSound = audio.loadSound("src/assets/sounds/magnet-hit.mp3")

    background = display.newImage('src/assets/images/page2BackGround.png', display.actualContentWidth, display
        .actualContentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0
    background.y = 0
    sceneGroup:insert(background)

    local instructionsText = display.newImage('src/assets/texts/page2Instructions.png', display.actualContentWidth,
        display.actualContentHeight)
    instructionsText.x = display.contentWidth * 0.32
    instructionsText.y = display.contentHeight * 0.02
    sceneGroup:insert(instructionsText)

    local text = display.newImage('src/assets/texts/page2Text.png', display.actualContentWidth,
        display.actualContentHeight)
    text.x = display.contentWidth * 5 / 10
    text.y = display.contentHeight * 0.67
    text:scale(0.9, 0.9)
    sceneGroup:insert(text)

    turnButton = display.newImage('src/assets/buttons/turnAroundButton.png', display.contentWidth,
        display.contentWidth)
    turnButton.x = display.contentWidth * 0.9
    turnButton.y = display.contentHeight * 0.2
    sceneGroup:insert(turnButton)

    fixedMagnet = display.newImage('src/assets/images/squareMagnet.png', display.contentWidth,
        display.contentWidth)
    fixedMagnet.isVisible = false
    sceneGroup:insert(fixedMagnet)


    magnet = display.newImage('src/assets/images/squareMagnet.png', display.contentWidth,
        display.contentWidth)
    magnet.isVisible = false
    sceneGroup:insert(magnet)


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
        buttonSound = audio.loadSound("src/assets/sounds/click-button.mp3")
        magnetHitSound = audio.loadSound("src/assets/sounds/magnet-hit.mp3")
        backButton.touch = onBackPage
        backButton:addEventListener("touch", backButton)

        --Reinicia posições
        fixedMagnet.x = display.contentWidth * 0.7
        fixedMagnet.y = display.contentHeight * 0.2
        fixedMagnet.isVisible = true
        magnet.x = display.contentWidth * 0.2
        magnet.y = display.contentHeight * 0.2
        magnet.isVisible = true

        physics.start()
        physics.addBody(fixedMagnet, "static", { radius = 52, friction = 1 })
        fixedMagnet.isFixedRotation = true
        physics.addBody(magnet, "dinamic", { radius = 50, friction = 1 })
        magnet.isFixedRotation = true

        forwardButton.touch = onNextPage
        forwardButton:addEventListener("touch", forwardButton)
        magnet:addEventListener("collision", onCollision)
        magnet:addEventListener("touch", onMagnetTouch)
        turnButton:addEventListener("touch", onTurnButtonTouch)
        Runtime:addEventListener("enterFrame", atrairObjeto)
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        Runtime:removeEventListener("enterFrame", atrairObjeto)
        backButton:removeEventListener("touch", backButton)
        forwardButton:removeEventListener("touch", forwardButton)
        background:removeEventListener("tap", background)
        magnet:removeEventListener("touch", onMagnetTouch)
        magnet:removeEventListener("collision", onCollision)
        turnButton:removeEventListener("touch", onTurnButtonTouch)

        physics.stop()
    elseif (phase == "did") then

    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
