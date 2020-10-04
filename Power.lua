Power = Class{}

function Power:init(charges, speed)
    self.POWERS = {}
    self.charges = charges
    self.speed = speed

    self.sounds = {
        ['aoe'] = love.audio.newSource('Sounds/aoe.wav', 'static')
    }
end

function Power:spawn(x, y)
    if self.charges > 0 then
        self.sounds['aoe']:play()
        self.charges = self.charges - 1
        table.insert(self.POWERS, {x = x, y = y, r = 10})
    end
end

function Power:update(dt)
    for i, v in ipairs(self.POWERS) do
        v.r = v.r + self.speed * dt

        if v.r > Virtual_Width  / 4 + 20 then
            table.remove(self.POWERS, i)
        end
    end
end

function Power:render()
    for i,v in ipairs(self.POWERS) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle('line', v.x, v.y, v.r)
    end
end