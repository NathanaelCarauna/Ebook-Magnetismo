local composer = require("composer")
local scene = composer.newScene()
local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

local DISTANCIA_RELPUSAO = 150

local backButton
local forwardButton
local background
local raio_solar
local earth
local sun

-- display.setDrawMode("debug")

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

    local moveX = xGravity * 5  -- multiplicador para controlar a velocidade de movimento
    local moveY = -zGravity * 5 -- multiplicador para controlar a velocidade de movimento

    raio_solar.x = raio_solar.x + moveX
    raio_solar.y = raio_solar.y + moveY
end

local function repelirMeteoro()
    local distancia = math.sqrt((raio_solar.x - earth.x) ^ 2 + (raio_solar.y - earth.y) ^ 2)
    if distancia < DISTANCIA_RELPUSAO then
        local forca = 200 * (100 - distancia)
        local direcaoX = earth.x - raio_solar.x
        local direcaoY = earth.y - raio_solar.y
        raio_solar:applyForce(direcaoX * forca, direcaoY * forca, raio_solar.x, raio_solar.y)
    else
        raio_solar:setLinearVelocity(0, 0)
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

    sun = display.newImage('src/assets/images/sun.png', display.actualContentWidth,
        display.actualContentHeight)
    sun.x = display.contentWidth * 10 / 10
    sun.y = display.contentHeight * 0.6
    sun:scale(0.5, 0.5)
    physics.addBody(sun, "static", { density = 1.6, friction = 0.5, radius= 40})
    sceneGroup:insert(sun)

    earth = display.newImage('src/assets/images/earth.png', display.actualContentWidth,
        display.actualContentHeight)
    earth.x = display.contentWidth * 2 / 10
    earth.y = display.contentHeight * 0.7
    earth:scale(0.1, 0.1)
    physics.addBody(earth, "static", { density = 1.6, friction = 0.5, radius= 30})
    sceneGroup:insert(earth)

    raio_solar = display.newImage('src/assets/images/raio_solar.png', display.actualContentWidth,
        display.actualContentHeight)
    raio_solar.x = display.contentWidth * 9 / 10
    raio_solar.y = display.contentHeight * 0.6
    raio_solar:scale(0.1, 0.1)
    physics.addBody(raio_solar, "dinamic", { density = 1.6, radius = 20, bounce=0.7})
    sceneGroup:insert(raio_solar)

    local limit_left = display.newRect(-40, 0, 40, display.contentHeight)
    limit_left.anchorX = 0
    limit_left.anchorY = 0
    physics.addBody(limit_left, "static", { density = 1.6, friction = 0.5, bounce = 0.2 })
    sceneGroup:insert(limit_left)

    local limit_right = display.newRect(display.contentWidth, 0, 40, display.contentHeight)
    limit_right.anchorX = 0
    limit_right.anchorY = 0
    physics.addBody(limit_right, "static", { density = 1.6, friction = 0.5, bounce = 0.2 })
    sceneGroup:insert(limit_right)

    local limit_bottom = display.newRect(0, display.contentHeight, display.contentWidth, 40)
    limit_bottom.anchorX = 0
    limit_bottom.anchorY = 0
    physics.addBody(limit_bottom, "static", { density = 1.6, friction = 0.5, bounce = 0.2 })
    sceneGroup:insert(limit_bottom)

    local limit_Up = display.newRect(0, -40, display.contentWidth, 40)
    limit_Up.anchorX = 0
    limit_Up.anchorY = 0
    physics.addBody(limit_Up, "static", { density = 1.6, friction = 0.5, bounce = 0.2 })
    sceneGroup:insert(limit_Up)

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

        physics.start()
        physics.setGravity(0, 0)

        forwardButton.touch = onNextPage
        forwardButton:addEventListener("touch", forwardButton)
        Runtime:addEventListener("accelerometer", moveMeteor)
        Runtime:addEventListener("enterFrame", repelirMeteoro)
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        raio_solar.x = display.contentWidth * 9 / 10
        raio_solar.y = display.contentHeight * 0.6

        backButton:removeEventListener("touch", backButton)
        forwardButton:removeEventListener("touch", forwardButton)
        background:removeEventListener("tap", background)
        Runtime:removeEventListener("accelerometer", moveMeteor)
        Runtime:removeEventListener("enterFrame", repelirMeteoro)
        physics.stop()
    elseif (phase == "did") then

    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
