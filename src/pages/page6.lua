local composer = require("composer")
local physics = require("physics")
local scene = composer.newScene()

-- Variáveis de maior escopo
local backButton
local forwardButton
local background
local limit_bottom
local clip1, clip2, clip3, clip4, magnet
local buttonSound

--Opções de audio
local buttonSoundOptions = {
    channel = 1,
    loops = 0,
    duration = 1000,
    fadein = 0,
    onComplete = function() audio.dispose(buttonSound) end
}

--Voltar imagem
local function onBackPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        audio.play( buttonSound, buttonSoundOptions)
        composer.gotoScene("src.pages.page5", "slideRight")

        return true
    end
end

--Avançar imagem
local function onNextPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        audio.play( buttonSound, buttonSoundOptions)
        composer.gotoScene(string.format("src.pages.page7"), "slideLeft")

        return true
    end
end

--Arrastar objeto
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

--Manter referencia dos linked joints
local myJoint
local prevLink = magnet
local nextLink

--Ao ima colidir com os clips, adicionar um joint
local function onCollision(self, event)
    if event.phase == "began" then
        if (self.id == "magnet") then
            nextLink = event.other
            if nextLink.id == "clip1" or nextLink.id == "clip2" or nextLink.id == "clip3" or nextLink.id == "clip4" then
                timer.performWithDelay(1, function()
                    if(prevLink ~= nextLink) then
                        print("Prevlink = ", prevLink.id, " NExtLink=", nextLink.id)
                        myJoint = physics.newJoint("pivot", prevLink, nextLink, prevLink.x, prevLink.y + 30, nextLink.x, nextLink.y + 20)
                        prevLink = nextLink
                    end
                end)
            end
        end
    end
end

function scene:create(event)
    local sceneGroup = self.view
    buttonSound = audio.loadSound( "src/assets/sounds/click-button.mp3")

    --Plano de fundo
    background = display.newImage('src/assets/images/page6Background.png', display.actualContentWidth, display
        .actualContentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0
    background.y = 0
    sceneGroup:insert(background)

    --Texto de instrução
    local instructionsText = display.newImage('src/assets/texts/page6Instructions.png', display.actualContentWidth,
        display.actualContentHeight)
    instructionsText.x = display.contentWidth * 0.4
    instructionsText.y = display.contentHeight * 0.48
    sceneGroup:insert(instructionsText)

    --Texto explicativo
    local text = display.newImage('src/assets/texts/page6Text.png', display.actualContentWidth,
        display.actualContentHeight)
    text.x = display.contentWidth * 5 / 10
    text.y = display.contentHeight * 0.2
    sceneGroup:insert(text)

    -- Imã
    magnet = display.newImage('src/assets/images/umagnet.png', display.actualContentWidth,
        display.actualContentHeight)
    magnet.id = "magnet"
    magnet.x = display.contentWidth * 0.5
    magnet.y = display.contentHeight * 0.6
    sceneGroup:insert(magnet)

    --Clips
    clip1 = display.newImage('src/assets/images/clip.png', display.actualContentWidth,
        display.actualContentHeight)
    clip1.id = "clip1"
    clip1.x = display.contentWidth * 0.2
    clip1.y = display.contentHeight * 0.85
    sceneGroup:insert(clip1)

    clip2 = display.newImage('src/assets/images/clip.png', display.actualContentWidth,
        display.actualContentHeight)
    clip2.id = "clip2"
    clip2.x = display.contentWidth * 0.4
    clip2.y = display.contentHeight * 0.85
    sceneGroup:insert(clip2)

    clip3 = display.newImage('src/assets/images/clip.png', display.actualContentWidth,
        display.actualContentHeight)
    clip3.id = "clip3"
    clip3.x = display.contentWidth * 0.6
    clip3.y = display.contentHeight * 0.85
    sceneGroup:insert(clip3)

    clip4 = display.newImage('src/assets/images/clip.png', display.actualContentWidth,
        display.actualContentHeight)
    clip4.id = "clip4"
    clip4.x = display.contentWidth * 0.8
    clip4.y = display.contentHeight * 0.85
    sceneGroup:insert(clip4)

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

    --Botões de navegação
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
        backButton.touch = onBackPage
        backButton:addEventListener("touch", backButton)

        --Carregar audio
        buttonSound = audio.loadSound( "src/assets/sounds/click-button.mp3")

        --Voltar para o estado inicial
        magnet.x = display.contentWidth * 0.5
        magnet.y = display.contentHeight * 0.6
        clip1.x = display.contentWidth * 0.2
        clip1.y = display.contentHeight * 0.85
        clip2.x = display.contentWidth * 0.4
        clip2.y = display.contentHeight * 0.85
        clip3.x = display.contentWidth * 0.6
        clip3.y = display.contentHeight * 0.85
        clip4.x = display.contentWidth * 0.8
        clip4.y = display.contentHeight * 0.85
        prevLink = magnet
        myJoint = {}

        --INiciar física
        physics.start()
        physics.addBody(magnet, "kinematic", { radius = 30 })
        physics.addBody(clip1, "dynamic", { radius = 20 })
        physics.addBody(clip2, "dynamic", { radius = 20 })
        physics.addBody(clip3, "dynamic", { radius = 20 })
        physics.addBody(clip4, "dynamic", { radius = 20 })
        physics.addBody(limit_bottom, "static", { density = 1.6, friction = 0.5, bounce = 0.2 })
        physics.addBody(limit_left, "static", { density = 1.6, friction = 0.5, bounce = 0.2 })
        physics.addBody(limit_right, "static", { density = 1.6, friction = 0.5, bounce = 0.2 })

        --Adicionar eventos
        forwardButton.touch = onNextPage
        forwardButton:addEventListener("touch", forwardButton)
        magnet.touch = onDragObj
        magnet:addEventListener("touch", magnet)

        magnet.collision = onCollision
        magnet:addEventListener("collision")
        clip1.collision = onCollision
        clip1:addEventListener("collision")
        clip2.collision = onCollision
        clip2:addEventListener("collision")
        clip3.collision = onCollision
        clip3:addEventListener("collision")
        clip4.collision = onCollision
        clip4:addEventListener("collision")
    elseif (phase == "did") then
       
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        --Remover eventos
        backButton:removeEventListener("touch", backButton)
        forwardButton:removeEventListener("touch", forwardButton)
        background:removeEventListener("tap", background)
        magnet:removeEventListener("touch", magnet)
        Runtime:removeEventListener("collision", onCollision)
        physics.stop()
    elseif (phase == "did") then

    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
