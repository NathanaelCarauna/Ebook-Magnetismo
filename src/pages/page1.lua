local composer = require("composer")
local physics = require("physics")

local ATTRACTION_DISTANCE = 300

local scene = composer.newScene()

-- Variáveis de maior escopo
local backButton
local forwardButton
local background
local magnetita
local metal
local rock1
local rock2
local rock3
local buttonSound, metalHitSound

-- Opções de audio do botão
local buttonSoundOptions = {
    channel = 1,
    loops = 0,
    duration = 1000,
    fadein = 0,
    onComplete = function() audio.dispose(buttonSound) end
}

-- Opções de audio de colisão
local metalHitSoundOptions = {
    channel = 1,
    loops = 0,
    duration = 1000,
    fadein = 0
}

-- Retorna para página anterior
local function onBackPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        audio.play(buttonSound, buttonSoundOptions)
        composer.gotoScene("src.pages.home", "slideRight")

        return true
    end
end

-- Avança para a próxima página
local function onNextPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        audio.play(buttonSound, buttonSoundOptions)
        composer.gotoScene(string.format("src.pages.page2"), "slideLeft")

        return true
    end
end

-- Adiciona arrasto à magnetita
local function onMagnetitaTouch(event)
    onDragObj(event, magnetita)
end

-- Adiciona arrasto à rock3
local function onRock3Touch(event)
    onDragObj(event, rock3)
end

-- Adiciona arrasto à rock2
local function onRock2Touch(event)
    onDragObj(event, rock2)
end

-- Adiciona arrasto à rock1
local function onRock1Touch(event)
    onDragObj(event, rock1)
end

-- arrasto de objeto
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

-- Atrair magnetita para a bola de ferro se a distancia for menor que definida
local function atractObj()
    local distancia = math.sqrt((magnetita.x - metal.x) ^ 2 + (magnetita.y - metal.y) ^ 2)
    if distancia < ATTRACTION_DISTANCE then
        local forca = -200 * (100 - distancia)
        local direcaoX = metal.x - magnetita.x
        local direcaoY = metal.y - magnetita.y
        magnetita:applyForce(direcaoX * forca, direcaoY * forca, magnetita.x, magnetita.y)
    else
        magnetita:setLinearVelocity(0, 0)
    end
end

-- impedir que a magnetita sobreponha a bola de metal
local function onCollision(event)
    if (event.phase == "began") then
        magnetita:removeEventListener("enterFrame", atractObj)
        magnetita.x = metal.x
        magnetita.y = metal.y
        if event.other == metal then
            audio.play(metalHitSound, metalHitSoundOptions)
        end
    elseif (event.phase == "ended") then
        magnetita:addEventListener("enterFrame", atractObj)
    end
end

function scene:create(event)
    local sceneGroup = self.view
    buttonSound = audio.loadSound("src/assets/sounds/click-button.mp3")
    metalHitSound = audio.loadSound("src/assets/sounds/metal-hit.mp3")

    --Background
    background = display.newImage('src/assets/images/page1Background.png', display.actualContentWidth, display
        .actualContentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0
    background.y = 0
    sceneGroup:insert(background)

    --Instruções de interação
    local instructionsText = display.newImage('src/assets/texts/Page1Instructions.png', display.actualContentWidth,
        display.actualContentHeight)
    instructionsText.x = display.contentWidth * 0.4
    instructionsText.y = display.contentHeight * 0.49
    instructionsText:scale(1, 1)
    sceneGroup:insert(instructionsText)

    --Texto explicativo
    local text = display.newImage('src/assets/texts/page1Text.png', display.actualContentWidth,
        display.actualContentHeight)
    text.x = display.contentWidth * 5 / 10
    text.y = display.contentHeight * 4 / 20
    text:scale(1, 1)
    sceneGroup:insert(text)

    --Bola de metal
    metal = display.newImage('src/assets/images/iron-ball.png', display.contentWidth,
        display.contentHeight)
    metal.x = display.contentWidth * 19 / 20
    metal.y = display.contentHeight * 0.727
    metal:scale(1, 1)
    sceneGroup:insert(metal)

    --Magnetita
    magnetita = display.newImage('src/assets/images/magnetita.png', display.actualContentWidth,
        display.actualContentHeight)
    magnetita:scale(1, 1)
    sceneGroup:insert(magnetita)

    --Rock1
    rock1 = display.newImage('src/assets/images/rock1.png', display.actualContentWidth,
        display.actualContentHeight)
    rock1:scale(1, 1)
    sceneGroup:insert(rock1)


    --Rock2
    rock2 = display.newImage('src/assets/images/rock2.png', display.actualContentWidth,
        display.actualContentHeight)
    rock2:scale(1, 1)
    sceneGroup:insert(rock2)


    --Rock3
    rock3 = display.newImage('src/assets/images/rock3.png', display.actualContentWidth,
        display.actualContentHeight)
    rock3:scale(1, 1)
    sceneGroup:insert(rock3)

    --Botão de voltar
    backButton = display.newImage('src/assets/buttons/blackButtonLeft.png', display.contentWidth,
        display.contentWidth)
    backButton.x = display.contentWidth * 0.1
    backButton.y = display.contentHeight * 0.9
    backButton:scale(1, 1)
    sceneGroup:insert(backButton)

    --Botão de avançar
    forwardButton = display.newImage('src/assets/buttons/blackButtonRight.png', display.contentWidth,
        display.contentWidth)
    forwardButton.x = display.contentWidth * 0.9
    forwardButton.y = display.contentHeight * 0.9
    forwardButton:scale(1, 1)
    sceneGroup:insert(forwardButton)
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then

        -- Carregar audio
        buttonSound = audio.loadSound("src/assets/sounds/click-button.mp3")
        metalHitSound = audio.loadSound("src/assets/sounds/metal-hit.mp3")

        -- Adiciona função aos botões de navegação
        backButton.touch = onBackPage
        backButton:addEventListener("touch", backButton)

        forwardButton.touch = onNextPage
        forwardButton:addEventListener("touch", forwardButton)

        --Inicia posições
        magnetita.x = display.contentWidth * 4 / 20
        magnetita.y = display.contentHeight * 0.8
        rock1.x = display.contentWidth * 4 / 20
        rock1.y = display.contentHeight * 0.6
        rock2.x = display.contentWidth * 8 / 20
        rock2.y = display.contentHeight * 0.7
        rock3.x = display.contentWidth * 10 / 20
        rock3.y = display.contentHeight * 0.9

        --Adiciona física
        physics.start()
        physics.setGravity(0, 0)
        physics.addBody(metal, "static", { radius = 128, friction = 1 })
        physics.addBody(magnetita, "dinamic", { density = 3.0, friction = 1, radius = 60 })
        magnetita.isFixedRotation = true
        physics.addBody(rock1, "dinamic", { density = 3.0, friction = 1, radius = 50 })
        physics.addBody(rock2, "dinamic", { density = 3.0, friction = 1, radius = 30 })
        physics.addBody(rock3, "dinamic", { density = 3.0, friction = 1, radius = 60 })

        -- Adiciona eventos para os objetos
        magnetita:addEventListener("touch", onMagnetitaTouch)
        magnetita:addEventListener("collision", onCollision)
        rock1:addEventListener("touch", onRock1Touch)
        rock2:addEventListener("touch", onRock2Touch)
        rock3:addEventListener("touch", onRock3Touch)
        Runtime:addEventListener("enterFrame", atractObj)
    elseif (phase == "did") then
        
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        physics.stop()

        Runtime:removeEventListener("enterFrame", atractObj)
        backButton:removeEventListener("touch", backButton)
        forwardButton:removeEventListener("touch", forwardButton)
        background:removeEventListener("tap", background)
        magnetita:removeEventListener("touch", onMagnetitaTouch)
        magnetita:removeEventListener("collision", onCollision)
        rock1:removeEventListener("touch", onRock1Touch)
        rock2:removeEventListener("touch", onRock2Touch)
        rock3:removeEventListener("touch", onRock3Touch)
    elseif (phase == "did") then

    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
