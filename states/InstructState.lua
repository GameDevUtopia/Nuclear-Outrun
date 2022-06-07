Class=require "class"
InstructState= Class{__includes=BaseState}

function InstructState:init()
    back1=love.graphics.newImage("assets/back-off.png")
    back2=love.graphics.newImage("assets/back-on.png")

    backbuttonX=window_width/2-back1:getWidth()/2-50
    backbuttonY=500
    backbuttonW=back1:getWidth()
    backbuttonH=back1:getHeight()
    backbutton=back1
end


function InstructState:update(dt)
    onButton1()
end

function onButton1()
    local x=love.mouse.getX()
    local y=love.mouse.getY()

    if(x>backbuttonX and x<backbuttonX+backbuttonW and y>backbuttonY and y<backbuttonY+backbuttonH)then
        backbutton=back2
        onBackButton=true
    else
        backbutton=back1
        onBackButton=false
    end
end

function InstructState:mousewasPressed(button)
    if(button==1 and onBackButton)then
        gStateMachine:change("title")
    end
end

function InstructState:draw()
    love.graphics.draw(backbutton,backbuttonX,backbuttonY)
    love.graphics.print(love.mouse.getX())
end