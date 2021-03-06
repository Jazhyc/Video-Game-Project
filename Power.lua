Power = Class{}

local Wavecost = 20
local Ballcost = 50
local knivespeed = 400

function Power:init(charges, speed)
    self.Waves = {}
    self.Balls = {}
    self.Pillars = {}
    self.Knives = {}

    self.speed = speed
    self.inultimate = false

    self.sounds = {
        ['aoe'] = love.audio.newSource('Sounds/aoe.wav', 'static'),
        ['sharan'] = love.audio.newSource('Sounds/xox.mp3', 'static')
    }

    self.images = {
        ['Ladoo'] = love.graphics.newImage('Images/sbladoo.png'),
        ['knive'] = love.graphics.newImage('Images/knife.png')
    }

    self.textures = {
        ['hole'] = love.graphics.newImage('Images/bladooholemk4.png'),
        ['pillar'] = love.graphics.newImage('Images/pillarmk2.png')
    }

    self.frames = {
        ['hole'] = generateQuads(self.textures['hole'], 96, 96),
        ['pillar'] = generateQuads(self.textures['pillar'], 64, 324)
    }

    self.animations = {
        ['hole'] = Animation {
            texture = self.textures['hole'],
            frames = {unpack(self.frames['hole'], 1, 495)}, -- Are these many frames really necessary?
            interval = 0.0064
        }
    }
end

function Power:Wavespawn(x, y)
    if player.mp - 10 > Wavecost then
        self.sounds['aoe']:play()
        table.insert(self.Waves, {x = x - player.width / 2, y = y - player.height / 2, r = 10})
        player.mp = player.mp - Wavecost
    end
end

function Power:Ballspawn(x, y)
    if player.mp - 10 > Ballcost then
        table.insert(self.Balls, {x = x, y = y, r = 48, dir = player.xdir * player.sprdir, time = 0, state = 'moving', atime = 0})
        player.mp = player.mp - Ballcost
    end
end

function Power:Pillarspawn() -- Spawns each pillar with a separate animation pool
    table.insert(self.Pillars, {x = player.x + math.random(-400, 400), y = 0, time = 0, 
    animation = Animation {
        texture = self.textures['pillar'],
        frames = {unpack(self.frames['pillar'], 1, 393)},
        interval = 0.00515
    }
    })
end

function Power:Knifespawn(x, y)
    table.insert(self.Knives, {x = x, y = y, dx = 60, xdir = player.xdir * player.sprdir, time = 0})
end

function Power:update(dt)
    for i, v in ipairs(self.Waves) do
        v.r = v.r + self.speed * dt

        if v.r > Virtual_Width  / 4 + 20 then
            table.remove(self.Waves, i)
        end
    end

    for i, v in ipairs(self.Balls) do

        if v.time < 2 and v.state == 'moving' then
            v.x = v.x + 300 * dt * v.dir
            v.time = v.time + dt
        else
            v.state = 'detonate'
        end

        if v.state == 'detonate' then
            if v.atime < 3.15 then
                self.animations['hole']:update(dt)
                v.atime = v.atime + dt
            else
                table.remove(self.Balls, i)
                self.inultimate = false
                self.animations['hole']:reset()
            end
        end
    end

    for i, v in ipairs(self.Pillars) do
        v.animation:update(dt)
        v.time = v.time + dt

        if v.time > 0.04 * 50 then
            table.remove(self.Pillars, i)
        end
    end

    for i, v in ipairs(self.Knives) do
        v.x = v.x + knivespeed * v.xdir * dt
        v.time = v.time + dt

        if v.time > 5 then
            table.remove(self.Knives, i)
        end
    end
end

function Power:render()
    for i, v in ipairs(self.Waves) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle('line', v.x, v.y, v.r)
    end

    for i, v in ipairs(self.Balls) do
        if v.state == 'moving' then
            love.graphics.draw(self.images['Ladoo'], math.floor(v.x - player.width / 2), math.floor(v.y - player.height / 2))
        elseif v.state == 'detonate' then
            love.graphics.draw(self.textures['hole'], self.animations['hole']:getCurrentFrame(), 
            math.floor(v.x - player.width / 2), math.floor(v.y - player.height / 2))
        end
    end

    for i, v in ipairs(self.Pillars) do
        love.graphics.draw(self.textures['pillar'], v.animation:getCurrentFrame(), math.floor(v.x), 0)
    end

    for i, v in ipairs(self.Knives) do
        love.graphics.draw(self.images['knive'], math.floor(v.x), math.floor(v.y), 0, v.xdir * -1) -- Sprite is facing left
    end
end