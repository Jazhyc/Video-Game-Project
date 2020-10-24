Enemy = Class{}

local Gravity = love.graphics.getHeight() * 1.25
local Holeabsorb = 300

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
    table.insert(self.ENEMIES, {x = x, y = y, dx = dx, size = 24, xdir = 1, scale = 1, dead = false, dtime = 0})
end

function Enemy:update(dt)

    for i, v in ipairs(self.ENEMIES) do
        -- move towards player
        
        if not v.dead then
            if v.x < player.x then
                v.x = v.x + v.dx
                v.xdir = 1
            else
                v.x = v.x - v.dx
                v.xdir = -1
            end
        end
        -- collision
        if not v.dead then
            if v.x >= player.x - player.width / 2 and v.x <= player.x + player.width / 2 then
                -- y collision broken
                if v.y >= player.y - player.height / 2 and v.y <= player.y + player.height / 2 then
                    self.sounds['damage']:play()
                    player.hp = player.hp - 1
                    table.remove(self.ENEMIES, i)
                end
            end
        end


        -- Checks for collsion with the power circle
        if power.Waves then
            for _, circle in ipairs(power.Waves) do
                if v.x + v.size / 2 > circle.x - circle.r and v.x - v.size / 2 < circle.x + circle.r then
                    if v.y < circle.y + circle.r and v.y > circle.y - circle.r then
                        self.sounds['damage']:play()
                        table.remove(self.ENEMIES, i)
                    end
                end
            end
        end

        -- Checks for collisions with Ladoo Balls
        if power.Balls then
            for _, ball in ipairs(power.Balls) do
                if v.x + v.size / 2 > ball.x and v.x - v.size / 2 < ball.x then -- Magic Numbers?
                    if v.y < ball.y + ball.r and v.y > ball.y - ball.r then
                        self.sounds['damage']:play()

                        if not v.dead then
                            ball.state = 'detonate'
                            v.y = ball.y + ball.r / 3 + 24
                            v.x = (v.x + 12) + 1 * v.xdir
                            v.dead = true
                            v.rotation = math.random(-3.14, 3.14)
                        end
                    end
                end

                if v.dead then
                    self.sounds['damage']:play()

                    -- Makes enemies go crazy when inside black hole, should prevent them from escaping
                    if v.x > ball.x then
                        v.x = v.x + v.dx * dt
                    elseif v.x < ball.x then
                        v.x = v.x - v.dx * dt
                    end


                    v.rotation = v.rotation + Holeabsorb * ball.atime * dt
                    v.scale = 1 * (3 - ball.atime) / 3

                    if ball.atime > 3 then
                        table.remove(self.ENEMIES, i)
                    end
                end
            end
        end

        -- applying gravity to enemies
        if not v.dead then
            v.y = v.y + Gravity * dt
            v.y = math.floor(math.min(v.y, Virtual_Height - v.size))
        end
    end 

end

function Enemy:render()
    for i, v in ipairs(self.ENEMIES) do
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.images['troll'], math.floor(v.x + v.size / 2 * v.xdir), math.floor(v.y - v.size), -- Need to change position later
        v.rotation, v.xdir, v.scale, v.size * 2) -- Wierd hitbox
    end
end 