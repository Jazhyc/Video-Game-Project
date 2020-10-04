Sky = Class{}

local rate = 0.2

function Sky:init()
    self.aradius = 300 -- Radius from anchor
    self.cradius = 64 -- Radius from Centre
    self.angle = -3.14 -- Radians

    self.images = {
        ['night'] = love.graphics.newImage('Images/night1.png'),
        ['day'] = love.graphics.newImage('Images/day.png'),
        ['moon'] = love.graphics.newImage('Images/moon.png'),
        ['sun'] = love.graphics.newImage('Images/sun.png')
    }

    self.state = 'day' -- Initial State
end

function Sky:update(dt)
    self.angle = self.angle + dt * rate
end

function Sky:render()

    local ox = Virtual_Width / 2 - self.cradius / 2 -- center
    local oy = Virtual_Height - self.cradius / 2
    local x = self.aradius * math.cos(self.angle) + ox
    local y = self.aradius * math.sin(self.angle) + oy

    if self.state == 'night' then
        love.graphics.draw(self.images['night'], 0, 0)
        love.graphics.draw(self.images['moon'], x, y)
    elseif self.state == 'day' then
        love.graphics.draw(self.images['day'], 0, 0)
        love.graphics.draw(self.images['sun'], x, y)
    end

    if self.angle > 0 then
        if self.state == 'night' then
            self.state = 'day'
        elseif self.state == 'day' then
            self.state = 'night'
        end
        self.angle = -3.14
    end
end