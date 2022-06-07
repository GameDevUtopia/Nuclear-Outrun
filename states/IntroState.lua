Class=require "class"
require "libraries/intro/intro"
IntroState=Class{__includes=BaseState}

function IntroState:init()
    vid=intro.init("resources/intro-final.ogv")
    self.timer=0
end

function IntroState:update(dt)
    vid:play()
    self.timer=self.timer+dt
    if(self.timer>1)then
        gStateMachine:change("title")
    end
end

function IntroState:draw()
    if(vid.video:isPlaying())then
        love.graphics.draw(vid.video,0,0,0,vid.scale*1.165)
    end
end
