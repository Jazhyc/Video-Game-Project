Enemy = Class{}

local Gravity = love.graphics.getHeight() * 1.25

function Enemy:init()
    self.ENEMIES = {} -- Table where enemies are stored

    self.images = {
        ['troll'] = love.graphics.newImage('Images/lenny.png')
    }

    self.sounds = {
        ['damage'] = love.audio.newSource('Sounds/edamage.wav', 'static')
    }
end

function Enemy:spawn(x, y, dx, size)
    table.insert(self.ENEMIES, {x = x, y = y, dx = dx, size = size})
end

function Enemy:update(dt)

    for i, v in ipairs(self.ENEMIES) do
        -- move towards player
        if v.x < player.x then
            v.x = v.x + v.dx
        else
            v.x = v.x - v.dx
        end
        -- collision
        if v.x >= player.x - player.width / 2 and v.x <= player.x + player.width / 2 then
            -- y collision broken
            if v.y >= player.y - player.height / 2 and v.y <= player.y + player.height / 2 then
                self.sounds['damage']:play()
                table.remove(self.ENEMIES, i)
            end
        end

        -- Checks for collsion with the power circle
        if power.POWERS then
            for _, circle in ipairs(power.POWERS) do
                if v.x + v.size > circle.x - circle.r and v.x - v.size < circle.x + circle.r then
                    if v.y < circle.y + circle.r and v.y > circle.y - circle.r then
                        self.sounds['damage']:play()
                        table.remove(self.ENEMIES, i)
                    end
                end
            end
        end

        -- applying gravity to enemies
        v.y = v.y + Gravity * dt
        v.y = math.floor(math.min(v.y, Virtual_Height - v.size))
    end 

end

function Enemy:render()
    for i, v in ipairs(self.ENEMIES) do
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.images['troll'], v.x, v.y - v.size) -- Need to change position later
    end
end 

