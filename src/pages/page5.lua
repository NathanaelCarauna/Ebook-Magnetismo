local composer = require("composer")
local scene = composer.newScene()

-- Variáveis de maior escopo
local backButton
local forwardButton
local background
local canShake
local currentImageIndex = 1
local images = {}
local buttonSound, magnetHitSound

-- Opções de audio
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

--Voltar página
local function onBackPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        audio.play( buttonSound, buttonSoundOptions)
        composer.gotoScene("src.pages.page4", "slideRight")

        return true
    end
end

-- Avançar página
local function onNextPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        audio.play( buttonSound, buttonSoundOptions)
        composer.gotoScene(string.format("src.pages.page6"), "slideLeft")

        return true
    end
end

-- Trocar imagem com o shake
local function changePowderImage(event)        
    if event.isShake then
        
        if canShake == true then
            currentImageIndex = currentImageIndex + 1
            audio.play(magnetHitSound, magnetHitSoundOptions)
            canShake = false
        end

        timer.performWithDelay(1000, function ()
            canShake = true            
        end)
        if currentImageIndex > #images then            
            currentImageIndex = #images
        end
        -- exibir a nova imagem
        for i = 1, #images do
            images[i].isVisible = (i == currentImageIndex)
        end
    end
end

function scene:create(event)
    local sceneGroup = self.view
    --Carregar audio
    buttonSound = audio.loadSound( "src/assets/sounds/click-button.mp3")

    --Plano de fundo
    background = display.newImage('src/assets/images/page2BackGround.png', display.actualContentWidth, display
        .actualContentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0
    background.y = 0
    sceneGroup:insert(background)

    --Texto de instruções
    local instructionsText = display.newImage('src/assets/texts/page5Instructions.png', display.actualContentWidth,
    display.actualContentHeight)
    instructionsText.x = display.contentWidth * 0.4
    instructionsText.y = display.contentHeight * 0.02
    sceneGroup:insert(instructionsText)

    -- Texto explicativo
    local text = display.newImage('src/assets/texts/page5Text.png', display.actualContentWidth,
    display.actualContentHeight)
    text.x = display.contentWidth * 5/10
    text.y = display.contentHeight * 0.67
    sceneGroup:insert(text)

    --Imagens a serem trocadas
    magnetPowder01 = display.newImage('src/assets/images/magnetPowder01.png', display.contentWidth,
        display.contentWidth)
    magnetPowder01.x = display.contentWidth * 0.5
    magnetPowder01.y = display.contentHeight * 0.25
    magnetPowder01:scale(1.5,1.5)
    sceneGroup:insert(magnetPowder01)
    table.insert(images, magnetPowder01)

    magnetPowder02 = display.newImage('src/assets/images/magnetPowder02.png', display.contentWidth,
        display.contentWidth)
    magnetPowder02.x = display.contentWidth * 0.5
    magnetPowder02.y = display.contentHeight * 0.25
    magnetPowder02:scale(1.5,1.5)
    magnetPowder02.isVisible = false
    sceneGroup:insert(magnetPowder02)
    table.insert(images, magnetPowder02)

    magnetPowder03 = display.newImage('src/assets/images/magnetPowder03.png', display.contentWidth,
        display.contentWidth)
    magnetPowder03.x = display.contentWidth * 0.5
    magnetPowder03.y = display.contentHeight * 0.25
    magnetPowder03:scale(1.5,1.5)
    magnetPowder03.isVisible = false
    sceneGroup:insert(magnetPowder03)
    table.insert(images, magnetPowder03)

    magnetPowder04 = display.newImage('src/assets/images/magnetPowder04.png', display.contentWidth,
        display.contentWidth)
    magnetPowder04.x = display.contentWidth * 0.5
    magnetPowder04.y = display.contentHeight * 0.3
    magnetPowder04.y = display.contentHeight * 0.25
    magnetPowder04:scale(1.5,1.5)
    magnetPowder04.isVisible = false
    sceneGroup:insert(magnetPowder04)
    table.insert(images, magnetPowder04)

    magnetPowder05 = display.newImage('src/assets/images/magnetPowder05.png', display.contentWidth,
        display.contentWidth)
    magnetPowder05.x = display.contentWidth * 0.5
    magnetPowder05.y = display.contentHeight * 0.25
    magnetPowder05:scale(1.5,1.5)
    magnetPowder05.isVisible = false
    sceneGroup:insert(magnetPowder05)
    table.insert(images, magnetPowder05)

    -- Botões de navegação
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
        -- Carrega audios
        buttonSound = audio.loadSound( "src/assets/sounds/click-button.mp3")
        magnetHitSound = audio.loadSound("src/assets/sounds/powder-shake.mp3")
        
        --Inicializa variável para permitir troca de imagens
        canShake = true
        
        backButton.touch = onBackPage
        backButton:addEventListener("touch", backButton)
        
        -- Reinicia as imagens
        currentImageIndex = 1
        for i = 1, #images do
            images[i].isVisible = (i == currentImageIndex)
        end

        -- adiciona eventos
        forwardButton.touch = onNextPage
        forwardButton:addEventListener("touch", forwardButton)
        system.setAccelerometerInterval( 100 )
        Runtime:addEventListener("accelerometer", changePowderImage)
    elseif (phase == "did") then
       
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        --Remove eventos
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
