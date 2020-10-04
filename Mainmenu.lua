Mainmenu = Class{}

function Mainmenu:init()
    self.pointer = 1
    self.pointers = {'start', 'credits', 'quit'}

    self.options = { -- Uses magic values
        ['start'] = function() love.graphics.rectangle('fill', Virtual_Width / 2 - 90, 151, 175, 26) end,
        ['credits'] = function() love.graphics.rectangle('fill', Virtual_Width / 2 - 90, 191, 175, 26) end,
        ['quit'] = function() love.graphics.rectangle('fill', Virtual_Width / 2 - 90, 231, 175, 26) end
    }

    self.sounds = {
        ['select'] = love.audio.newSource('Sounds/select.wav', 'static'),
        ['lock'] = love.audio.newSource('Sounds/lock.wav', 'static')
    }
end

function Mainmenu:select()

    -- Mainmenu Controls
    if gameState == 'title' then
        if love.keyboard.wasPressed('s') or love.keyboard.wasPressed('down') then
            if self.pointer ~= 3 then
                self.pointer = self.pointer + 1
                self.sounds['select']:play()
            end
        end

        if love.keyboard.wasPressed('w') or love.keyboard.wasPressed('up') then
            if self.pointer ~= 1 then
                self.pointer = self.pointer - 1
                self.sounds['select']:play()
            end
        end
    end

    -- Returns player to title screen after credits
    if gameState == 'credits' then
        if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space') then
            gameState = 'title'
            self.sounds['select']:play()
            return -- Prevents interruptions with below events, Not really applicable right now
        end
    end

    if gameState == 'title' then -- Should modify the syntax for readability later on
        if (love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space')) and self.pointer == 3 then
            self.sounds['lock']:play()
            love.event.quit()
            
        elseif (love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space')) and self.pointer == 2 then
            gameState = 'credits'
            self.sounds['lock']:play()

        elseif (love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space')) and self.pointer == 1 then
            gameState = 'play'
            self.sounds['lock']:play()
            love.keyboard.keysPressed = {}
        end
    end
end

function Mainmenu:render()
    if gameState == 'title' then
        --love.graphics.draw(self.images['background'], 0, 0, 0,
        --    Virtual_Width / self.menuWidth, VIRTUAL_HEIGHT / self.menuHeight)
        updateMenu()
        love.graphics.setFont(fonts['font2'])
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("Ambitious Project", 0, 80, Virtual_Width, 'center')

        love.graphics.printf("New Game", 0, 150, Virtual_Width, 'center')
        love.graphics.printf("Credits", 0, 190, Virtual_Width, 'center')
        love.graphics.printf("Quit", 0, 230, Virtual_Width, 'center')

    elseif gameState == 'credits' then
        love.graphics.clear(150 / 255, 45 / 255, 60 / 255, 255 / 255)
        love.graphics.setFont(fonts['font1'])
        love.graphics.printf("Programming by JazHyc, TheWeakNinja", 0, 10, Virtual_Width, 'center')
        love.graphics.printf("Sprites by DragonBuster206, Tsuki", 0, 40, Virtual_Width, 'center')
        love.graphics.printf("Press Space to return to Title", 0, 300, Virtual_Width, 'center')
    end
end

function updateMenu()
    love.graphics.setColor(1, 1, 1, 0.5)
    mainmenu.options[mainmenu.pointers[mainmenu.pointer]]() -- Self doesn't work
    love.graphics.setColor(1, 1, 1, 1)
end