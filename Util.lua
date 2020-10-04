-- Generates sprites parameters
-- This function gets the chunk textures from the sprite sheet
function generateQuads(atlas, tilewidth, tileheight) -- atlas refers to the png file, atlas maps the png
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    -- Keeps tracks of quads, acts as an index
    local sheetCounter = 1 
    -- Quads are chunks of texture, this stores all the quads chunk after chunk
    local quads = {} -- Indexing starts at 1

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do -- Each quad is x * width X y * tileheight, creates a grid, atlas gets some values for low level stuff
            quads[sheetCounter] = love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth, tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1 -- Increments
        end
    end

    return quads
end