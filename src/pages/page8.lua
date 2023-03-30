local composer = require("composer")
local scene = composer.newScene()
local physics = require("physics")

--Variáveis de maior escopo
local DISTANCIA_RELPUSAO = 150

local backButton
local forwardButton
local background
local sun_particle
local earth
local sun
local limit_left, limit_right, limit_Up, limit_bottom

--Voltar página
local function onBackPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene("src.pages.page7", "slideRight")

        return true
    end
end

--Avançar página
local function onNextPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene(string.format("src.pages.endpage"), "slideLeft")

        return true
    end
end

--Mover particula de acordo com movimento do celular
local function moveParticle(event)
    local xGravity = event.xGravity
    local zGravity = event.yGravity

    local moveX = xGravity * 5  -- multiplicador para controlar a velocidade de movimento
    local moveY = -zGravity * 5 -- multiplicador para controlar a velocidade de movimento

    sun_particle.x = sun_particle.x + moveX
    sun_particle.y = sun_particle.y + moveY
end

--Repelir particula
local function repelirParticle()
    local distancia = math.sqrt((sun_particle.x - earth.x) ^ 2 + (sun_particle.y - earth.y) ^ 2)
    if distancia < DISTANCIA_RELPUSAO then
        local forca = 200 * (100 - distancia)
        local direcaoX = earth.x - sun_particle.x
        local direcaoY = earth.y - sun_particle.y
        sun_particle:applyForce(direcaoX * forca, direcaoY * forca, sun_particle.x, sun_particle.y)
    else
        sun_particle:setLinearVelocity(0, 0)
    end
end


function scene:create(event)
    local sceneGroup = self.view    

    --Plano de fundo
    background = display.newImage('src/assets/images/page2BackGround.png', display.actualContentWidth, display
        .actualContentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0
    background.y = 0
    sceneGroup:insert(background)

    --Texto de instrução
    local instructionsText = display.newImage('src/assets/texts/page8Instructions.png', display.actualContentWidth,
        display.actualContentHeight)
    instructionsText.x = display.contentWidth * 3 / 10
    instructionsText.y = display.contentHeight * 0.49
    sceneGroup:insert(instructionsText)

    --Texto explicativo
    local text = display.newImage('src/assets/texts/page8Text.png', display.actualContentWidth,
        display.actualContentHeight)
    text.x = display.contentWidth * 5 / 10
    text.y = display.contentHeight * 0.2
    sceneGroup:insert(text)

    --Sol
    sun = display.newImage('src/assets/images/sun.png', display.actualContentWidth,
        display.actualContentHeight)
    sun.x = display.contentWidth * 10 / 10
    sun.y = display.contentHeight * 0.6
    sun:scale(0.5, 0.5)
    sceneGroup:insert(sun)

    --Terra
    earth = display.newImage('src/assets/images/earth2.png', display.actualContentWidth,
        display.actualContentHeight)
    earth.x = display.contentWidth * 2 / 10
    earth.y = display.contentHeight * 0.7
    earth:scale(0.7, 0.7)
    sceneGroup:insert(earth)

    --Raio solar
    sun_particle = display.newImage('src/assets/images/raio_solar.png', display.actualContentWidth,
        display.actualContentHeight)
    sun_particle.x = display.contentWidth * 9 / 10
    sun_particle.y = display.contentHeight * 0.6
    sun_particle:scale(0.1, 0.1)
    sceneGroup:insert(sun_particle)

    --Limites da tela
    limit_left = display.newRect(-40, 0, 40, display.contentHeight)
    limit_left.anchorX = 0
    limit_left.anchorY = 0
    sceneGroup:insert(limit_left)

    limit_right = display.newRect(display.contentWidth, 0, 40, display.contentHeight)
    limit_right.anchorX = 0
    limit_right.anchorY = 0
    sceneGroup:insert(limit_right)

    limit_bottom = display.newRect(0, display.contentHeight, display.contentWidth, 40)
    limit_bottom.anchorX = 0
    limit_bottom.anchorY = 0
    sceneGroup:insert(limit_bottom)

    limit_Up = display.newRect(0, -40, display.contentWidth, 40)
    limit_Up.anchorX = 0
    limit_Up.anchorY = 0
    sceneGroup:insert(limit_Up)

    --Botões de navegação
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
        backButton.touch = onBackPage
        backButton:addEventListener("touch", backButton)

        --Iniciar física
        physics.start()
        physics.setGravity(0, 0)
        physics.addBody(earth, "static", { density = 1.6, friction = 0.5, radius = 30 })
        physics.addBody(sun, "static", { density = 1.6, friction = 0.5, radius = 40 })
        physics.addBody(sun_particle, "dinamic", { density = 1.6, radius = 20, bounce = 0.7 })
        physics.addBody(limit_left, "static", { density = 1.6, friction = 0.5, bounce = 0.2 })
        physics.addBody(limit_right, "static", { density = 1.6, friction = 0.5, bounce = 0.2 })
        physics.addBody(limit_bottom, "static", { density = 1.6, friction = 0.5, bounce = 0.2 })
        physics.addBody(limit_Up, "static", { density = 1.6, friction = 0.5, bounce = 0.2 })

        --Adicionar eventos
        forwardButton.touch = onNextPage
        forwardButton:addEventListener("touch", forwardButton)
        Runtime:addEventListener("accelerometer", moveParticle)
        Runtime:addEventListener("enterFrame", repelirParticle)
    elseif (phase == "did") then
        
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        sun_particle.x = display.contentWidth * 9 / 10
        sun_particle.y = display.contentHeight * 0.6

        --Remover eventos
        Runtime:removeEventListener("enterFrame", repelirParticle)
        backButton:removeEventListener("touch", backButton)
        forwardButton:removeEventListener("touch", forwardButton)
        background:removeEventListener("tap", background)
        Runtime:removeEventListener("accelerometer", moveParticle)
        physics.stop()
        audio.stop()
    elseif (phase == "did") then

    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
