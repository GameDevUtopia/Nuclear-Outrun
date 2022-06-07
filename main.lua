require "libraries/intro/intro"
require "StateMachine"
require "states/BaseState"
require "states/TitleScreenState"
require "states/IntroState"
require "states/PlayState"
require "states/InstructState"
require "states/EndState"

window_width=1200
window_height=700

function love.load()
    love.window.setMode(window_width,window_height)
    love.window.setFullscreen(false)
    love.window.setTitle("Nuclear_Outrun")
    love.keyboard.keysPressed={}
    gStateMachine=StateMachine{
        ['intro']=function() return IntroState() end,
        ['title']=function() return TitleScreenState() end,
        ['play']=function() return PlayState() end,
        ['instruct']=function() return InstructState() end,
        ['end']=function() return EndState()end
    }
    gStateMachine:change("intro")
end

function love.mousepressed(x,y,button)
    gStateMachine:mousewasPressed(button)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key]=true
    if(key=="escape")then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end


function love.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed={}
end

function love.draw()
    gStateMachine:draw()
end
