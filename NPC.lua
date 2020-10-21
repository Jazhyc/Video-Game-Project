NPC = Class{}

function NPC:init()

    self.width = 64
    self.height = 64
    self.inrange = false
    self.inconvo = false -- In Conversation Boolean

    self.x = 0 - self.width
    self.y = Virtual_Height - self.height

    self.images = {
        ['llama'] = love.graphics.newImage('Images/Llama.png'),
        ['texticon'] = love.graphics.newImage('Images/Text icon.png')
    }

end

function NPC:update(dt)
    if love.keyboard.wasPressed('c') then
        if self.inrange then
            if self.inconvo then self.inconvo = false else self.inconvo = true end
        end
    end

    if not self.inrange then self.inconvo = false end
end

function NPC:render()
    self.inrange = false
    love.graphics.draw(self.images['llama'], self.x, self.y)

    -- Llama isn't centered yet, detects if player is within range of npc
    if self.x + self.width * 2 > player.x and self.x - self.width < player.x then
        if self.y + self.height * 2 > player.y and self.y - self.height < player.y then
            self.inrange = true
        end
    end

    if self.inrange and not self.inconvo then
        love.graphics.draw(self.images['texticon'], self.x + self.width, self.y)
    end

    if self.inconvo then
        love.graphics.setFont(fonts['font1'])
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.rectangle('fill', self.x - self.width - 10, self.y - self.width - 5, 265, 40)
        love.graphics.setColor(0.2, 0.2, 1)
        love.graphics.rectangle('fill', self.x - self.width - 5, self.y - self.width, 255, 30) -- Magic Values for now
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Baaaaaaaaa, I'm a Sheep, No wait I'm a Llama, Llaaaaamaa", self.x - self.width, self.y - self.height, 250)
    end
end

