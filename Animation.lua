-- This class is responsibl for all the animations of entities
Animation = Class{}

function Animation:init(params)
    self.texture = params.texture
    self.frames = params.frames
    self.interval = params.interval or 0.5 -- Set default value
    self.timer = 0
    self.currentFrame = 1
end

function Animation:getCurrentFrame() -- Return current animation
    return self.frames[self.currentFrame]
end

function Animation:reset() -- Sets animation to default, useful if want to prevent animations form occuring
    self.timer = 0
    self.currentFrame = 1
end

function Animation:update(dt)
    self.timer = self.timer + dt

    if #self.frames == 1 then -- # is a len function
        return currentFrame

    else
        while self.timer > self.interval do
            self.timer = self.timer - self.interval -- This is better instead of -0, if you want to keep track of the timer
            self.currentFrame = (self.currentFrame + 1) % (#self.frames + 1) -- +1 so that the last animation is played

            if self.currentFrame == 0 then self.currentFrame = 1 end-- If modulos returns 0 then restart. one line syntax
        end
    end
end