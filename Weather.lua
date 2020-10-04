Weather = Class{}

function Weather:init()

    self.images = {
        ['rain'] = love.graphics.newImage('Images/rain.png')
    }

    local vertices = {
		{
			-- top-left corner
			0, 0, -- position of the vertex
			0, 0, -- texture coordinate at the vertex position
			1, 1, 1, 0.1 -- color & alpha of the vertex
		},
		{
			-- top-right corner
			self.images['rain']:getWidth(), 0,
			1, 0, -- texture coordinates are in the range of [0, 1]
			1, 1, 1, 0.1
		},
		{
			-- bottom-right corner
			self.images['rain']:getWidth(), self.images['rain']:getHeight(),
			1, 1,
			1, 1, 1, 0.1
		},
		{
			-- bottom-left corner
			0, self.images['rain']:getHeight(),
			0, 1,
			1, 1, 1, 0.1
		},
	}

    self.images['rain']:setWrap('repeat', 'repeat')

    self.meshes = {
        ['rain'] = love.graphics.newMesh(vertices, 'fan')
    }
    
    self.meshes['rain']:setTexture(self.images['rain'])
end

function Weather:render()
    love.graphics.draw(self.meshes['rain'], 0, 0, 0, Virtual_Width/self.images['rain']:getWidth(), 
    Virtual_Height/self.images['rain']:getHeight())
end


local function clamp(x,m,s) return math.max(math.min(x,s),m) end
local time = 0.0
local wave = 5.0
function Weather:update(dt) -- Magic?

    local u, v

    for i=1,4 do
		u, v = self.meshes['rain']:getVertexAttribute(i, 2)
		u, v = u-dt/5, v-dt
		self.meshes['rain']:setVertexAttribute(i, 2, u, v)
	end
end