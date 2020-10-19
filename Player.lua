Player = Class{}

local Gravity = love.graphics.getHeight() * 1.25
local xGravity = love.graphics.getWidth() * 1.25
local Speed = 180
local Jump_Velocity = love.graphics.getHeight() / 2
local Jump_limit = 2 -- Number of times player can jump
local Dash_xVelocity = love.graphics.getWidth() / 2 * 2
local Dash_yVelocity = 0 -- For now
local Dash_limit = 1
local Dash_time = 0.3
local Dash_Reset = 0.8

function Player:init()

    -- Some wierd bug with zero values can happen
    self.hp = 10
    self.mp = 100

    -- Physical Parameters
    self.x = 30
    self.y = 30
    self.xdir = 1

    -- Need to finalize this
    self.width = 96
    self.height = 96
    self.dx = 0
    self.dy = 0

    -- State Parameters
    self.state = 'walking'
    self.jumpval = 0
    self.dash = 0
    self.dashTimer = 0
    self.dashResetTimer = 0
    self.dTStart = false
    self.canDash = true

    self.texture = love.graphics.newImage('Images/hero.png')
    self.frames = generateQuads(self.texture, 96, 96)
    
    self.animations = {
        ['hole'] = Animation {
            texture = self.texture,
            frames = {unpack(self.frames, 1, 3)}, -- Remember that indexing starts from 1 in lua
            interval = 0.3
        },
        ['dummy'] = 1
    }

    self.animation = self.animations['hole']

    self.behaviours = {
        ['walking'] = function(dt)
            self.dash = 0
            self.jumpval = 0

            if love.keyboard.wasPressed('space') then
                self:Jump()
            end

            if love.keyboard.wasPressed('lshift') and self.canDash then
                self.state = 'dashing'
                self.sounds['dash']:play()
            end
        end,

        ['jumping'] = function(dt)
            if self.y == Virtual_Height - self.height / 2 then
                self.state = 'walking'
            end

            if love.keyboard.wasPressed('lshift') and self.canDash then
                self.state = 'dashing'
                self.sounds['dash']:play()
            end

            if self.jumpval < Jump_limit and love.keyboard.wasPressed('space') then
                self:Jump()
            end
        end,

        ['dashing'] = function(dt)  

            if love.keyboard.wasPressed('space') then
                self:Jump()
            end

            self.dx = Dash_xVelocity * self.xdir
            self.dy = -Dash_yVelocity
            self.dTStart = true
            self.canDash = false
            -- make t = 0 for shake function to activate
            shake = 20

        end
    }

    self.sounds = {
        ['jump'] = love.audio.newSource('Sounds/jump.wav', 'static'),
        ['dash'] = love.audio.newSource('Sounds/dash.wav', 'static')
    }

    self.sounds['jump']:setVolume(0.5)
end

function Player:control()
    -- self.xdir keeps track of direction
    if (love.keyboard.isDown('a') or love.keyboard.isDown('left')) and self.dTStart == false then
        self.dx = -Speed
        self.xdir = -1
    elseif (love.keyboard.isDown('d') or love.keyboard.isDown('right')) and self.dTStart == false then
        self.dx = Speed
        self.xdir = 1
    end  
end

function Player:update(dt)

    self.animation:update(dt) -- Change later on
    self.x = self.x + self.dx * dt
    self.mp = math.max(math.min(self.mp + dt * 10, 100), 10)
    self.hp = math.max(math.min(self.hp + dt, 10), 1)

    -- Flooring prevents Blurring
    self.y = math.floor(math.min(self.y + self.dy * dt, Virtual_Height - self.height / 2))

    self.behaviours[self.state](dt)

    -- restoring force for dash
    if self.state == 'dashing' then
        if self.xdir > 0 and self.dx > 0 then
            self.dx = self.dx - xGravity * dt
        elseif self.xdir < 0 and self.dx < 0 then
            self.dx = self.dx + xGravity * dt
        end
    else
        self.dx = 0
    end
    self.dy = self.dy + Gravity * dt

    -- start timer for 0.3 seconds
    if player.dTStart == true then
        player.dashTimer = player.dashTimer + dt
    end
     -- ignore input for 0.3 seconds when dashed to prevent weird movement issues
    if player.dashTimer > Dash_time then
        player.dTStart = false
        player.dashTimer = 0
        
        if player.y <= Virtual_Height - player.width / 2 then
            self.state = 'jumping'
        else
            self.state = 'walking'
        end
    end

    -- Detects if player cannot dash and resets canDash bool when dash_Reset time has passed
    if not self.canDash then
        self.dashResetTimer = self.dashResetTimer + dt

        if self.dashResetTimer > Dash_Reset then
            self.canDash = true
            self.dashResetTimer = 0
        end
    end
end

function Player:render() -- Changed Player Orgin to Center, Need to make it adaptable later
    love.graphics.draw(self.texture, self.animation:getCurrentFrame(),
    self.x, self.y, 0, self.xdir, 1, self.width / 2, self.height / 2)
end

function Player:Jump()
    if self.jumpval < Jump_limit then
        self.sounds['jump']:play()
        self.state = 'jumping'
        self.jumpval = self.jumpval + 1
        self.dy = -Jump_Velocity
    end
end