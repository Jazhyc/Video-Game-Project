Window_Width, Window_Height = love.window.getDesktopDimensions()
Window_Width, Window_Height = Window_Width * 0.9, Window_Height * 0.9
Virtual_Width = 576
Virtual_Height = 324

push = require 'push'
Class = require 'class'

require 'Util'
require 'Mainmenu'
require 'Player'
require 'UI'
require 'Sky'
require 'Power'
require 'Weather'
require 'Enemy'
require 'Animation'
require 'NPC'

function love.load()

    love.window.setTitle("Project - Early Alpha")
    gameState = 'title'
    sleep = 0
    -- timer and variables for shake when dashing
    s = 0
    
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(Virtual_Width, Virtual_Height, Window_Width, Window_Height, {
        fullscreen = false,
        vsync = true,
        resizeable = false
    })

    mainmenu = Mainmenu()
    player = Player()
    ui = UI()
    -- power wave
    power = Power(100, 250)
    sky = Sky()
    weather = Weather()
    enemy = Enemy()
    npc = NPC()

    fonts = {
        ['font1'] = love.graphics.newFont('Fonts/font.ttf', 16),
        ['font2'] = love.graphics.newFont('Fonts/font.ttf', 32)
    }

    music = {
        -- Temporary music..... Is this familiar, more of a final boss theme than calming music
        ['temp'] = love.audio.newSource("Music/secret.ogg", 'static')
    }

    music['temp']:setLooping(true)
    music['temp']:setVolume(0.1)
    --music['temp']:play()
    
    love.graphics.setFont(fonts['font1'])

    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'q' then
        power:Wavespawn(player.x + player.width / 2, player.y + player.height / 2)
    end

    if key == 'f' then
        if not power.inultimate then
            power:Ballspawn(player.x, player.y)
            power.inultimate = true
        end
    end

    if key == 'r' then
        power:Pillarspawn()
    end

    if key == 'z' then
        player.hp = player.hp - 1
    end

    love.keyboard.keysPressed[key] = true

    if love.keyboard.wasPressed('e') then
        enemy:spawn(player.x - 100, player.y - 100, 2, math.random(10, 30))
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.draw()
    push:start()

    if gameState == 'title' or gameState == 'credits' then
        mainmenu:render()
    
    elseif gameState == 'play' then
        sky:render()
        --weather:render()
        getFps()

        love.graphics.translate(-player.x + Virtual_Width / 2, 0)
        --shake(s)

        line = 1 -- Divide Dimensions by 2 to preserve symmetry, Please for Sanity
        love.graphics.rectangle('fill', Virtual_Width / 2 - line / 2, 0, line, Virtual_Height)
        love.graphics.rectangle('fill', 0, Virtual_Height / 2 - line / 2, Virtual_Width, line)

        love.graphics.setColor(1,1,1,1)
        player:render()
        power:render()
        enemy:render()
        npc:render()

        -- Makes sure UI overlaps everything
        love.graphics.translate(player.x - Virtual_Width / 2, 0)
        ui:render()
    end

    push:finish()
end

function love.update(dt)
    -- add a constant fix function
    love.timer.sleep(sleep)
    -- if FPS is too high then increase sleep function's strength
    if love.timer.getFPS() >= 63 then
        sleep = sleep + 0.00001
    end
    -- if FPS is too low then decrease sleep function's strength
    if love.timer.getFPS() <= 57 then
        sleep = sleep - 0.00001
    end

    if gameState == 'title' or gameState == 'credits' then
        mainmenu:select()

    elseif gameState == 'play' then
        -- keep decreasing shake magnitude
        if s > 0 then
            s = s - 1
        end
        
        power:update(dt)
        player:update(dt)
        player:control(dt)
        --weather:update(dt)
        sky:update(dt)
        enemy:update(dt)
        npc:update(dt)
    end

    love.keyboard.keysPressed = {}
end

function getFps()
    fps = love.timer.getFPS()
    love.graphics.print(fps, fonts['font1'], 0, Virtual_Height - 12)
end

-- shake function
function shake(s)
    love.graphics.translate(s, 0)
end