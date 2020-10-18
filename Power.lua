Power = Class{}

function Power:init(charges, speed)
    self.Waves = {}
    self.Balls = {}
    self.charges = charges
    self.speed = speed
    self.inultimate = false

    self.sounds = {
        ['aoe'] = love.audio.newSource('Sounds/aoe.wav', 'static')
    }

    self.images = {
        ['Ladoo'] = love.graphics.newImage('Images/sbladoo.png')
    }

    self.textures = {
        ['hole'] = love.graphics.newImage('Images/bladooholemk3.png')
    }

    self.frames = {
        ['hole'] = generateQuads(self.textures['hole'], 96, 96)
    }

    self.animations = {
        ['hole'] = Animation {
            texture = self.textures['hole'],
            frames = {unpack(self.frames['hole'], 1, 70)},
            interval = 0.05
        }
    }
end

function Power:Wavespawn(x, y)
    if self.charges > 0 then
        self.sounds['aoe']:play()
        self.charges = self.charges - 1
        table.insert(self.Waves, {x = x - player.width / 2, y = y - player.height / 2, r = 10})
    end
end

function Power:Ballspawn(x, y)
    table.insert(self.Balls, {x = x, y = y + 8, r = 48, dir = player.xdir, time = 0, state = 'moving', atime = 0})
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
            end
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
end