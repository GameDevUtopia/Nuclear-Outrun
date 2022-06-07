Class=require "class"
require "libraries/intro/intro"
TitleScreenState=Class{__includes=BaseState}

function TitleScreenState:init()
    vid=intro.init("resources/title-screen-vid.ogv")
    self.timer=0
    play1=love.graphics.newImage("assets/play-off.png")
    play2=love.graphics.newImage("assets/play-on.png")
    ins1=love.graphics.newImage("assets/INS-off.png")
    ins2=love.graphics.newImage("assets/INS-on.png")
    flag=true


    insbuttonX=window_width/2-ins1:getWidth()/2+300
    insbuttonY=500
    insbuttonW=ins1:getWidth()
    insbuttonH=ins1:getHeight()


    playbuttonX=window_width/2-play1:getWidth()/2-300
    playbuttonY=500
    playbuttonW=play1:getWidth()
    playbuttonH=play1:getHeight()

    sound=love.audio.newSource('audio/gamescreen.mp3','stream')
    sound:setLooping(true)
    sound:setVolume(0.25)
    sound:play()
end

function TitleScreenState:update(dt)
    self.timer=self.timer+dt
    onButton()
    if(flag)then
        vid:play()
    end

    if(self.timer>15)then
        flag=false
    end
end

function onButton()
    local x=love.mouse.getX()
    local y=love.mouse.getY()
    if(x>playbuttonX and x<playbuttonX+playbuttonW and y>playbuttonY and y<playbuttonY+playbuttonH)then
        playbutton=play2
        onPlayButton=true
    else
        onPlayButton=false
        playbutton=play1
    end
    if(x>insbuttonX and x<insbuttonX+insbuttonW and y>insbuttonY and y<insbuttonY+insbuttonH)then
        onInsButton=true
        insbutton=ins2
    else
        onInsButton=false
        insbutton=ins1
    end
end

function TitleScreenState:mousewasPressed(button)
    if(button==1 and onPlayButton)then
        gStateMachine:change("play")
    elseif(button==1 and onInsButton)then
        gStateMachine:change("instruct")
    end
end

function TitleScreenState:draw()
    if(vid.video:isPlaying())then
        love.graphics.draw(vid.video,0,0,0,vid.scale*1.165)
    else
        vid:play()
    end

    if(not(flag))then
        love.graphics.draw(playbutton,playbuttonX,playbuttonY)
        love.graphics.draw(insbutton,insbuttonX,insbuttonY)
    end
end
