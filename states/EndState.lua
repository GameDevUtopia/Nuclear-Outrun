Class=require "class"

EndState=Class{__includes=BaseState}

function EndState:init()
    won_img=love.graphics.newImage("assets/won-screen.png")
    lost_img=love.graphics.newImage("assets/lost-screen.png")

end

function EndState:update(dt)
    if(love.keyboard.wasPressed("return"))then
        gStateMachine:change("title")
    end
end

function EndState:draw()
    if(won)then
        love.graphics.draw(won_img)
    elseif(not(won))then
        love.graphics.draw(lost_img)
    else
        love.graphics.draw(lost_img)
    end
end
