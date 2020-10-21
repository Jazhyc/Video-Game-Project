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
        ['sun'] = love.graphics.newImage('Images/sun.png'),
        ['forest'] = love.graphics.newImage('Images/forest.png'), -- Forest w/o back layer
        ['forestbl'] = love.graphics.newImage('Images/forestbl.png') -- Forest Back Layer
    }

    self.state = 'night' -- Initial State
end

function Sky:update(dt)
    self.angle = self.angle + dt * rate
end

function Sky:render()

    local shade = 0.7
    local transparency = 1

    local ox = Virtual_Width / 2 - self.cradius / 2 -- center
    local oy = Virtual_Height - self.cradius / 2
    local x = self.aradius * math.cos(self.angle) + ox
    local y = self.aradius * math.sin(self.angle) + oy

    -- Believe in Math and all will be clear, both celestial bodies are the brightest at their zenith?
    if self.state == 'night' then
        shade = 0.3 + 0.2 * (((3.14 / 2) - math.abs(self.angle + (3.14 / 2))) / (3.14 / 2))
    elseif self.state == 'day' then
        shade = 0.3 + 0.7 * (((3.14 / 2) - math.abs(self.angle + (3.14 / 2))) / (3.14 / 2))
    end

    love.graphics.setColor(shade, shade, shade)

    if self.state == 'night' then
        love.graphics.draw(self.images['night'], 0, 0)
        love.graphics.draw(self.images['moon'], x, y)
    elseif self.state == 'day' then
        love.graphics.draw(self.images['day'], 0, 0)
        love.graphics.draw(self.images['sun'], x, y)
    end
 
    love.graphics.draw(self.images['forest'], 0, 0)

    if self.state == 'day' then
        transparency = 1 - 1 * (((3.14 / 2) - math.abs(self.angle + (3.14 / 2))) / (3.14 / 2))
        love.graphics.setColor(shade, shade, shade, transparency)
    end
    love.graphics.draw(self.images['forestbl'], 0, 0)

    if self.angle > 0 then
        if self.state == 'night' then
            self.state = 'day'
        elseif self.state == 'day' then
            self.state = 'night'
        end
        self.angle = -3.14
    end

    love.graphics.setColor(1,1,1,1)
end