local composer = require("composer")
local physics = require("physics")

local scene = composer.newScene()

local backButton
local forwardButton
local background
local magnet
local knife
local newMagnet1
local newMagnet2
local newMagnet3
local newMagnet4
local newMagnet5
local newMagnet6

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
        audio.play( buttonSound, buttonSoundOptions)
        composer.gotoScene("src.pages.page2", "slideRight")

        return true
    end
end

local function onNextPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        audio.play( buttonSound, buttonSoundOptions)
        composer.gotoScene(string.format("src.pages.page4"), "slideLeft")

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

function onLocalCollision(self, event)
    if (event.phase == "began") then
        local other = event.other
        if (self.id == "knife") then
            if (other.id == "magnet" and other.isVisible) then
                print("Colidiu com ", other.id)
                timer.performWithDelay(1, function()
                    newMagnet1.x = magnet.x
                    newMagnet1.y = magnet.y + 80
                    magnet.isVisible = false
                    newMagnet1.isVisible = true

                    newMagnet2.x = magnet.x
                    newMagnet2.y = magnet.y - 80
                    newMagnet2.isVisible = true

                    audio.play(magnetHitSound, magnetHitSoundOptions)
                    physics.removeBody( magnet )
                    physics.addBody(newMagnet1, "dinamic", { radius = 50, friction = 1 })
                    newMagnet1.isFixedRotation = true
                    physics.addBody(newMagnet2, "dinamic", { radius = 50, friction = 1 })
                    newMagnet2.isFixedRotation = true
                end)
            end
            if (other.id == "newMagnet1" and other.isVisible) then
                print("Colidiu com ", other.id)
                timer.performWithDelay(1, function()
                    newMagnet1.isVisible = false

                    newMagnet3.x = newMagnet1.x
                    newMagnet3.y = newMagnet1.y - 26
                    newMagnet3.isVisible = true

                    newMagnet4.x = newMagnet1.x
                    newMagnet4.y = newMagnet1.y + 26
                    newMagnet4.isVisible = true

                    audio.play(magnetHitSound, magnetHitSoundOptions)
                    physics.removeBody(newMagnet1)
                    physics.addBody(newMagnet3, "dinamic", { radius = 25, friction = 1 })
                    newMagnet3.isFixedRotation = true
                    physics.addBody(newMagnet4, "dinamic", { radius = 25, friction = 1 })
                    newMagnet4.isFixedRotation = true
                end)
            end
            if (other.id == "newMagnet2" and other.isVisible) then
                print("Colidiu com ", other.id)
                timer.performWithDelay(1, function()
                    newMagnet2.isVisible = false

                    newMagnet5.x = newMagnet2.x
                    newMagnet5.y = newMagnet2.y - 26
                    newMagnet5.isVisible = true

                    newMagnet6.x = newMagnet2.x
                    newMagnet6.y = newMagnet2.y + 26
                    newMagnet6.isVisible = true

                    audio.play(magnetHitSound, magnetHitSoundOptions)
                    physics.removeBody(newMagnet2)
                    physics.addBody(newMagnet5, "dinamic", { radius = 25, friction = 1 })
                    newMagnet5.isFixedRotation = true
                    physics.addBody(newMagnet6, "dinamic", { radius = 25, friction = 1 })
                    newMagnet6.isFixedRotation = true
                end)
            end
        end
    end
end

function scene:create(event)
    local sceneGroup = self.view
    buttonSound = audio.loadSound( "src/assets/sounds/click-button.mp3")

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
    text.y = display.contentHeight * 0.15
    sceneGroup:insert(text)

    magnet = display.newImage('src/assets/images/squareMagnet.png', display.contentWidth,
        display.contentWidth)
    magnet.id = 'magnet'
    magnet.x = display.contentWidth * 0.6
    magnet.y = display.contentHeight * 0.6
    magnet:scale(1,2)
    sceneGroup:insert(magnet)
    magnet.isVisible = false

    newMagnet1 = display.newImage('src/assets/images/squareMagnet.png', display.contentWidth,
        display.contentWidth)
    newMagnet1.id = 'newMagnet1'    
    newMagnet1.isVisible = false
    newMagnet1:scale(1, 1)
    sceneGroup:insert(newMagnet1)    

    newMagnet2 = display.newImage('src/assets/images/squareMagnet.png', display.contentWidth,
        display.contentWidth)
    newMagnet2.id = 'newMagnet2'
    newMagnet2.isVisible = false
    newMagnet2:scale(1, 1)
    sceneGroup:insert(newMagnet2)


    newMagnet3 = display.newImage('src/assets/images/squareMagnet.png', display.contentWidth,
        display.contentWidth)
    newMagnet3.id = 'newMagnet3'
    newMagnet3.isVisible = false
    newMagnet3:scale(1, 0.5)
    sceneGroup:insert(newMagnet3)

    newMagnet4 = display.newImage('src/assets/images/squareMagnet.png', display.contentWidth,
        display.contentWidth)
    newMagnet4.id = 'newMagnet4'
    newMagnet4.isVisible = false
    newMagnet4:scale(1, 0.5)
    sceneGroup:insert(newMagnet4)


    newMagnet5 = display.newImage('src/assets/images/squareMagnet.png', display.contentWidth,
        display.contentWidth)
    newMagnet5.id = 'newMagnet5'
    newMagnet5.isVisible = false
    newMagnet5:scale(1, 0.5)
    sceneGroup:insert(newMagnet5)

    newMagnet6 = display.newImage('src/assets/images/squareMagnet.png', display.contentWidth,
        display.contentWidth)
    newMagnet6.id = 'newMagnet6'
    newMagnet6:scale(1, 0.5)
    sceneGroup:insert(newMagnet6)
    newMagnet6.isVisible = false

    knife = display.newImage('src/assets/images/Knife.png', display.contentWidth,
        display.contentWidth)
    knife.id = 'knife'
    knife:scale(-0.03, 0.03)
    knife.isVisible = false
    sceneGroup:insert(knife)


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
        buttonSound = audio.loadSound( "src/assets/sounds/click-button.mp3")
        magnetHitSound = audio.loadSound("src/assets/sounds/knife-hit.mp3")
        backButton.touch = onBackPage
        backButton:addEventListener("touch", backButton)

        --Reiniciar estado
        knife.x = display.contentWidth * 0.2
        knife.y = display.contentHeight * 0.6
        knife:toFront()
        knife.isVisible = true
        newMagnet6.isVisible = false
        newMagnet5.isVisible = false
        newMagnet4.isVisible = false
        newMagnet3.isVisible = false
        newMagnet2.isVisible = false
        newMagnet1.isVisible = false
        magnet.isVisible = true

        --Iniciar física
        physics.start()
        physics.setGravity(0, 0)
        physics.addBody(knife, "dinamic", { isSensor = true, radius = 10 })
        knife.isFixedRotation = true
        physics.addBody(magnet, "dinamic", { radius = 20, friction = 1 })
        magnet.isFixedRotation = true

        forwardButton.touch = onNextPage
        forwardButton:addEventListener("touch", forwardButton)
        knife.touch = onDragObj
        knife:addEventListener("touch", knife)
        knife.collision = onLocalCollision
        knife:addEventListener("collision")

        magnet.touch = onDragObj
        magnet:addEventListener("touch", magnet)
        magnet.collision = onLocalCollision
        magnet:addEventListener("collision")

        newMagnet1.touch = onDragObj
        newMagnet1:addEventListener("touch", newMagnet1)
        newMagnet1.collision = onLocalCollision
        newMagnet1:addEventListener("collision")

        newMagnet2.touch = onDragObj
        newMagnet2:addEventListener("touch", newMagnet2)
        newMagnet2.collision = onLocalCollision
        newMagnet2:addEventListener("collision")

        newMagnet3.touch = onDragObj
        newMagnet3:addEventListener("touch", newMagnet3)
        newMagnet3.collision = onLocalCollision
        newMagnet3:addEventListener("collision")

        newMagnet4.touch = onDragObj
        newMagnet4:addEventListener("touch", newMagnet4)
        newMagnet4.collision = onLocalCollision
        newMagnet4:addEventListener("collision")

        newMagnet5.touch = onDragObj
        newMagnet5:addEventListener("touch", newMagnet5)
        newMagnet5.collision = onLocalCollision
        newMagnet5:addEventListener("collision")

        newMagnet6.touch = onDragObj
        newMagnet6:addEventListener("touch", newMagnet6)
        newMagnet6.collision = onLocalCollision
        newMagnet6:addEventListener("collision")
    elseif (phase == "did") then
 
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        backButton:removeEventListener("touch", backButton)
        forwardButton:removeEventListener("touch", forwardButton)
        background:removeEventListener("tap", background)
        knife:removeEventListener("touch", onDragObj)
        magnet:removeEventListener("touch", onDragObj)

        physics.stop()
    elseif (phase == "did") then

    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
