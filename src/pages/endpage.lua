local composer = require("composer")
local scene = composer.newScene()

local backButton
local background

local buttonSound

-- Definir opções de audio do botão
local buttonSoundOptions = {
    channel = 1,
    loops = 0,
    duration = 1000,
    fadein = 0,
    onComplete = function() audio.dispose(buttonSound) end
}

-- Função para retornar para para página anterior
local function onBackPage(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        audio.play( buttonSound, buttonSoundOptions)
        composer.gotoScene("src.pages.page8", "slideRight")

        return true
    end
end

-- Criar objetos na cena
function scene:create(event)
    local sceneGroup = self.view
    buttonSound = audio.loadSound( "src/assets/sounds/click-button.mp3")

	local background = display.newImage(sceneGroup, "src/assets/images/HomeBackground.png",
	display.actualContentWidth, display.actualContentHeight)
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0
	background.y = 0
	sceneGroup:insert(background)

	local title = display.newImage('src/assets/texts/endPageText.png', display.contentWidth, display.contentWidth)
	title.x = display.contentWidth * 1/2
	title.y = display.contentHeight * 13/20
	sceneGroup:insert(title)


    backButton = display.newImage('src/assets/buttons/lightButtonLeft.png', display.contentWidth,
        display.contentWidth)
    backButton.x = display.contentWidth * 0.1
    backButton.y = display.contentHeight * 0.9
    sceneGroup:insert(backButton)

end

-- Função chamada ao renderizar a página
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        buttonSound = audio.loadSound( "src/assets/sounds/click-button.mp3")
        backButton.touch = onBackPage
        backButton:addEventListener("touch", backButton)
    elseif (phase == "did") then
       
    end
end

-- Função chamada ao sair da página
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        backButton:removeEventListener("touch", backButton)        
    elseif (phase == "did") then

    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
