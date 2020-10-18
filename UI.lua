UI = Class{}

function UI:init()
end

-- Draws UI that shows player attributes like health, mana, etc.. WIP
function UI:render()
    
    love.graphics.setColor(0.2, 0.2, 0.2)
    -- Relies on magic values a bit too much
    love.graphics.polygon('fill', {8, 8, 114, 8, 102, 22, 8, 22})
    love.graphics.polygon('fill', {8, 22, 102, 22, 90, 33, 8, 33})
    love.graphics.setColor(0, 0.9, 0)

    -- Syntax (Mode, Variable Vertices) Provide vertices in clockwise direction to prevent wierdness
    if player.hp == 10 then
        love.graphics.polygon('fill', {10, 10, 10 * player.hp + 10, 10, 10 * player.hp, 20, 10, 20})
    elseif player.hp > 0 then
        love.graphics.polygon('fill', {10, 10, 10 * player.hp, 10, 10 * player.hp, 20, 10, 20})
    end

    love.graphics.setColor(0.30, 0.30, 1)
    love.graphics.polygon('fill', {10, 22, 9.8 * player.mp, 22, 8.8 * player.mp, 31, 10, 31})
end