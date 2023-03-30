local composer = require("composer")
local scene = composer.newScene()

local forwardButton
local buttonSound

-- Opções do audio do butão
local buttonSoundOptions = {
    channel = 1,
    loops = 0,
    duration = 1000,
    fadein = 0,
    onComplete = function() audio.dispose(buttonSound) end
}

-- Função para mudar para a próxima página
local function onNextPage(self, event)
	if event.phase == "ended" or event.phase == "cancelled" then
		audio.play( buttonSound, buttonSoundOptions)
		composer.gotoScene("src.pages.page1", "slideLeft")

		return true
	end
end

-- Função onde os objetos estão sendo criados
function scene:create(event)
	local sceneGroup = self.view
	buttonSound = audio.loadSound( "src/assets/sounds/click-button.mp3")

	-- background
	local background = display.newImage(sceneGroup, "src/assets/images/HomeBackground.png",
	display.actualContentWidth, display.actualContentHeight)
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0
	background.y = 0
	sceneGroup:insert(background)

	-- título
	local title = display.newImage('src/assets/texts/HomeTitle.png', display.contentWidth, display.contentWidth)
	title.x = display.contentWidth * 1/2
	title.y = display.contentHeight * 13/20
	title:scale(1, 1)
	sceneGroup:insert(title)


	-- Botão de avançar página
	forwardButton = display.newImage('src/assets/buttons/lightButtonRight.png', display.contentWidth,
	display.contentWidth)
	forwardButton.x = display.contentWidth * 0.9
	forwardButton.y = display.contentHeight * 0.9
	forwardButton:scale(1, 1)
	sceneGroup:insert(forwardButton)
end

--Função chamada ao renderizar uma página
function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "will") then
		forwardButton.touch = onNextPage
		forwardButton:addEventListener("touch", forwardButton)
		buttonSound = audio.loadSound( "src/assets/sounds/click-button.mp3")
	elseif (phase == "did") then
		
	end
end

--Função chamada ao sair de uma página
function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "will") then
		forwardButton:removeEventListener("touch", forwardButton)
	elseif (phase == "did") then

	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
