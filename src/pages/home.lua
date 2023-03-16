local composer = require("composer")
local scene = composer.newScene()

local forwardButton

local function onNextPage(self, event)
	if event.phase == "ended" or event.phase == "cancelled" then
		composer.gotoScene("src.pages.page1", "fade")

		return true
	end
end

function scene:create(event)
	local sceneGroup = self.view

	local background = display.newImageRect(sceneGroup, "src/assets/images/HomeBackground.png",
	display.actualContentWidth, display.actualContentHeight)
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0
	background.y = 0
	sceneGroup:insert(background)

	local title = display.newImageRect('src/assets/texts/HomeTitle.png', display.contentWidth, display.contentWidth)
	title.x = display.contentWidth * 1/2
	title.y = display.contentHeight * 13/20
	title:scale(0.6, 0.4)
	sceneGroup:insert(title)



	forwardButton = display.newImageRect('src/assets/buttons/lightButtonRight.png', display.contentWidth,
	display.contentWidth)
	forwardButton.x = display.contentWidth * 0.9
	forwardButton.y = display.contentHeight * 0.9
	forwardButton:scale(0.1, 0.1)
	sceneGroup:insert(forwardButton)
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "will") then

	elseif (phase == "did") then
		forwardButton.touch = onNextPage
		forwardButton:addEventListener("touch", forwardButton)
	end
end

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
