wf=require "libraries/windfield"
anim=require "libraries/anim8/anim8"
sti=require "libraries/sti"
cameraFile=require "libraries/hump/camera"
Class=require "class"
PlayState=Class{__includes =BaseState}

function PlayState:init()
    world=wf.newWorld(0,700,false)
    p2overp1=true
    p1overp2=false
    platform_image=love.graphics.newImage('maps/platform.jpeg')
    button_image = love.graphics.newImage('maps/button.png')
    cam=cameraFile()

    Background=love.graphics.newImage('assets/bg2.jpg')

    player1_won=false
    player2_won=false
    won = false

    player_sheet=love.graphics.newImage("sprites/playerSheet.png")
    world:setQueryDebugDrawing(true)
    world:addCollisionClass('ground')
    world:addCollisionClass('player1')
    world:addCollisionClass('player2')
    world:addCollisionClass('platforms')
    world:addCollisionClass('p1')
    world:addCollisionClass('B1')
    world:addCollisionClass('p2')
    world:addCollisionClass('B2')
    world:addCollisionClass('p3')
    world:addCollisionClass('B3')
    world:addCollisionClass('p4')
    world:addCollisionClass('B4')
    world:addCollisionClass('End')



    platform=world:newRectangleCollider(-3000,window_height-10,7920,30,{collision_class="ground"})
    platform:setType("static")

    player1=world:newRectangleCollider(50,window_height-170,40,70,{collision_class="player1"})
    player1:setFixedRotation(true)
    player2=world:newRectangleCollider(100,window_height-170,40,70,{collision_class="player2"})
    player2:setFixedRotation(true)
    player1.speed=200
    player2.speed=200

    local grid=anim.newGrid(614,564,player_sheet:getWidth(),player_sheet:getHeight())
    animations={}
    animations.idle=anim.newAnimation(grid('1-15',1),0.1)
    animations.jump=anim.newAnimation(grid('1-7',2),0.1)
    animations.run=anim.newAnimation(grid('1-15',3),0.08)
    player1.animation=animations.idle
    player1.direction=1
    player1.onGround=true
    player2.animation=animations.idle
    player2.direction=1
    player2.onGround=true
    loadMap()
end

function loadMap()
    gameMap=sti("maps/map.lua")
    for key,obj in pairs(gameMap.layers['Platform'].objects) do
        local collider=world:newRectangleCollider(obj.x,obj.y,obj.width,obj.height)
        collider:setType('static')
        collider:setCollisionClass('platforms')
    end

    for key,obj in pairs(gameMap.layers['platform1'].objects) do
            platformcollider1=world:newRectangleCollider(obj.x,obj.y,obj.width,obj.height)
            platformcollider1:setType('static')
            platformcollider1:setCollisionClass('p1')
            platformcollider1.speed=0
    end

    for key,obj in pairs(gameMap.layers['platform2'].objects) do
        platformcollider2=world:newRectangleCollider(obj.x,obj.y,obj.width,obj.height)
        platformcollider2:setType('static')
        platformcollider2:setCollisionClass('p2')
        platformcollider2.speed=0
    end

    for key,obj in pairs(gameMap.layers['platform3'].objects) do
        platformcollider3=world:newRectangleCollider(obj.x,obj.y,obj.width,obj.height)
        platformcollider3:setType('static')
        platformcollider3:setCollisionClass('p2')
        platformcollider3.speed=0
    end

    for key,obj in pairs(gameMap.layers['platform4'].objects) do
        platformcollider4=world:newRectangleCollider(obj.x,obj.y,obj.width,obj.height)
        platformcollider4:setType('static')
        platformcollider4:setCollisionClass('p4')
        platformcollider4.speed=0
    end

    for key,obj in pairs(gameMap.layers['Button1'].objects) do
        buttoncollider1=world:newRectangleCollider(obj.x,obj.y,obj.width,obj.height)
        buttoncollider1:setType('static')
        buttoncollider1:setCollisionClass('B1')
        buttoncollider1.speed=0
    end

    for key,obj in pairs(gameMap.layers['Button2'].objects) do
        buttoncollider2=world:newRectangleCollider(obj.x,obj.y,obj.width,obj.height)
        buttoncollider2:setType('static')
        buttoncollider2:setCollisionClass('B2')
        buttoncollider2.speed=0
    end

    for key,obj in pairs(gameMap.layers['Button3'].objects) do
        buttoncollider3=world:newRectangleCollider(obj.x,obj.y,obj.width,obj.height)
        buttoncollider3:setType('static')
        buttoncollider3:setCollisionClass('B3')
        buttoncollider3.speed=0
    end

    for key,obj in pairs(gameMap.layers['Button4'].objects) do
        buttoncollider4=world:newRectangleCollider(obj.x,obj.y,obj.width,obj.height)
        buttoncollider4:setType('static')
        buttoncollider4:setCollisionClass('B4')
        buttoncollider4.speed=0
    end

    for key,obj in pairs(gameMap.layers['ending'].objects) do
        endingPoint=world:newRectangleCollider(obj.x,obj.y,obj.width,obj.height)
        endingPoint:setType('static')
        endingPoint:setCollisionClass('End')
        end
end

function PlayState:update(dt)
  if player1.body and player2.body then
    checkp1p2=world:queryRectangleArea(player1:getX()-20,player1:getY()+35,40,5,{"player2"})
    if #checkp1p2>0 then
      p1overp2=true
   else
     p1overp2=false
   end
    checkp2p1=world:queryRectangleArea(player2:getX()-20,player2:getY()+35,40,5,{"player1"})
    if #checkp2p1>0 then
      p2overp1=true
   else
     p2overp1=false
   end
 end
    if player1.body and player2.body then
      if player1:getX()<player2:getX() then
        cam:lookAt(math.max(600,player1:getX()+530),math.max(350,player1:getY()-145))
      else
        cam:lookAt(math.max(600,player2:getX()+530),math.max(350,player2:getY()-145))
      end

      --[[if player1:getX()>3100 or player2:getX()>3100 then
        if player1:getX()<player2:getY() then
          cam:lookAt(3100,math.max(350,player1:getY()-145))
        else
          cam:lookAt(3100,math.max(350,player2:getY()-145))
        end
      end]]
    end
     if player1.body then
        local colliders=world:queryRectangleArea(player1:getX()-20,player1:getY()+35,40,5,{"player2","platforms","p1","B1","p2","B2","p3","B3","p4","B4","End"})
        if(#colliders>0)then
            player1.onGround=true
        else
            player1.onGround=false
        end
        if(player1.onGround)then
            player1.animation=animations.idle
        end
        if(love.keyboard.isDown("right"))then
            local px,py=player1:getPosition()
            player1:setX(px+player1.speed*dt)
            if(player1.onGround)then
                player1.animation=animations.run
            end
            player1.direction=1
        elseif(love.keyboard.isDown("left"))then
            local px,py=player1:getPosition()
            player1:setX(math.max(50,px-player1.speed*dt))
            if(player1.onGround)then
                player1.animation=animations.run
            end
            player1.direction=-1
        end

        if player1:enter('ground') then
            player1:destroy()
            won=false
            gStateMachine:change('end')
        end
    end

    if(love.keyboard.wasPressed("up") and player1.onGround)then
        player1.animation=animations.jump
        player1:applyLinearImpulse(0,-2350)
    end
    player1.animation:update(dt)
--------------------------------------------------------------------------------
   if player2.body then
        local colliders2=world:queryRectangleArea(player2:getX()-20,player2:getY()+35,40,5,{"player1","platforms","p1","B1","p2","B2","p3","B3","p4","B4","End"})
        if(#colliders2>0)then
            player2.onGround=true
        else
            player2.onGround=false
        end
        if(player2.onGround)then
            player2.animation=animations.idle
        end
        if(love.keyboard.isDown("d"))then
            local px,py=player2:getPosition()
            player2:setX(px+player2.speed*dt)
            if(player2.onGround)then
                player2.animation=animations.run
            end
            player2.direction=1
        elseif(love.keyboard.isDown("a"))then
            local px,py=player2:getPosition()
            player2:setX(px-player2.speed*dt)
            if(player2.onGround)then
                player2.animation=animations.run
            end
            player2.direction=-1
        end

        if player2:enter('ground') then
            player2:destroy()
            won=false
            gStateMachine:change("end")
        end
    end

    if(love.keyboard.wasPressed("w") and player2.onGround)then
        player2.animation=animations.jump
        player2:applyLinearImpulse(0,-2350)
    end

    if player1:enter('B1') or player2:enter('B1')  then
        platformcollider1.speed=200
        buttoncollider1.speed=200
    end

    if player1:enter('B2') or player2:enter('B2') then
        platformcollider2.speed=200
        buttoncollider2.speed=200
    end

    if player1:enter('B3') or player2:enter('B3') then
        platformcollider3.speed=200
        buttoncollider3.speed=200
    end

    if player1:enter('B4') or player2:enter('B4') then
        platformcollider4.speed=200
        buttoncollider4.speed=200
    end

    if player1:enter('End') then
        player1_won = true
    end

    if player2:enter('End') then
        player2_won = true
    end

    if player1_won and player2_won then
        won = true
        gStateMachine:change("end")
    end

    platformcollider1:setY(math.min(350,platformcollider1:getY()+platformcollider1.speed*dt))
    buttoncollider1:setY(math.min(350,buttoncollider1:getY()+buttoncollider1.speed*dt))

    platformcollider2:setY(math.max(225,platformcollider2:getY()-platformcollider2.speed*dt))
    buttoncollider2:setY(math.max(225,buttoncollider2:getY()-buttoncollider2.speed*dt))

    platformcollider3:setY(math.min(215,platformcollider3:getY()+platformcollider3.speed*dt))
    buttoncollider3:setY(math.min(400,buttoncollider3:getY()+buttoncollider3.speed*dt))

    platformcollider4:setY(math.max(330,platformcollider4:getY()-platformcollider4.speed*dt))
    buttoncollider4:setY(math.min(171,buttoncollider4:getY()+buttoncollider4.speed*dt))

     ----------------------------------------------------------
    player1.animation:update(dt)
    player2.animation:update(dt)
    gameMap:update(dt)
    world:update(dt)
end


function PlayState:draw()
    cam:attach()

        love.graphics.draw(Background,0,0,0,2.85,2.85)
        love.graphics.draw(Background,1889.55,0,0,2.85,2.85)
        love.graphics.draw(Background,3779.1,0,0,2.85,2.85)
        world:draw()
        love.graphics.draw(button_image,buttoncollider1:getX()-14,buttoncollider1:getY()-7,0,button_image:getWidth()/1900,button_image:getHeight()/150)
        love.graphics.draw(platform_image,platformcollider1:getX()-74,platformcollider1:getY()-14,0,platform_image:getWidth()/260,platform_image:getHeight()/750)
        love.graphics.draw(button_image,buttoncollider2:getX()-14,buttoncollider2:getY()-7,0,button_image:getWidth()/1900,button_image:getHeight()/150)
        love.graphics.draw(platform_image,platformcollider2:getX()-90,platformcollider2:getY()-14,0,platform_image:getWidth()/215,platform_image:getHeight()/750)
        love.graphics.draw(button_image,buttoncollider3:getX()-14,buttoncollider3:getY()-7,0,button_image:getWidth()/1900,button_image:getHeight()/150)
        love.graphics.draw(platform_image,platformcollider3:getX()-45,platformcollider3:getY()-14,0,platform_image:getWidth()/420,platform_image:getHeight()/750)
        love.graphics.draw(button_image,buttoncollider4:getX()-14,buttoncollider4:getY()-7,0,button_image:getWidth()/1900,button_image:getHeight()/150)
        love.graphics.draw(platform_image,platformcollider4:getX()-74,platformcollider4:getY()-14,0,platform_image:getWidth()/260,platform_image:getHeight()/750)
        gameMap:drawLayer(gameMap.layers['Tile Layer 2'])
        if p1overp2==true then
          if player1.body then
              if(player1.direction==1)then
                  player1.animation:draw(player_sheet,player1:getX()-20,player1:getY()-90,0,player1.direction*0.25,0.25)
              elseif(player1.direction==-1)then
                  player1.animation:draw(player_sheet,player1:getX()+20,player1:getY()-90,0,player1.direction*0.25,0.25)
              end
          end

          if player2.body then
              if(player2.direction==1)then
                  player2.animation:draw(player_sheet,player2:getX()-20,player2:getY()-90,0,player2.direction*0.25,0.25)
              elseif(player2.direction==-1)then
                  player2.animation:draw(player_sheet,player2:getX()+20,player2:getY()-90,0,player2.direction*0.25,0.25)
              end
          end
        elseif p2overp1==true then
          if player2.body then
              if(player2.direction==1)then
                  player2.animation:draw(player_sheet,player2:getX()-20,player2:getY()-90,0,player2.direction*0.25,0.25)
              elseif(player2.direction==-1)then
                  player2.animation:draw(player_sheet,player2:getX()+20,player2:getY()-90,0,player2.direction*0.25,0.25)
              end
          end

          if player1.body then
              if(player1.direction==1)then
                  player1.animation:draw(player_sheet,player1:getX()-20,player1:getY()-90,0,player1.direction*0.25,0.25)
              elseif(player1.direction==-1)then
                  player1.animation:draw(player_sheet,player1:getX()+20,player1:getY()-90,0,player1.direction*0.25,0.25)
              end
          end
        else
          if player1.body then
              if(player1.direction==1)then
                  player1.animation:draw(player_sheet,player1:getX()-20,player1:getY()-90,0,player1.direction*0.25,0.25)
              elseif(player1.direction==-1)then
                  player1.animation:draw(player_sheet,player1:getX()+20,player1:getY()-90,0,player1.direction*0.25,0.25)
              end
          end

          if player2.body then
              if(player2.direction==1)then
                  player2.animation:draw(player_sheet,player2:getX()-20,player2:getY()-90,0,player2.direction*0.25,0.25)
              elseif(player2.direction==-1)then
                  player2.animation:draw(player_sheet,player2:getX()+20,player2:getY()-90,0,player2.direction*0.25,0.25)
              end
          end
        end
        --love.graphics.print("player on ground :"..tostring(player1.onGround))
        gameMap:drawLayer(gameMap.layers['Tile Layer 1'])

    cam:detach()

end
