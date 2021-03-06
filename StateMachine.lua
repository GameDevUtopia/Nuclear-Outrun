Class=require "class"
StateMachine=Class{}

function StateMachine:init(states)
    self.empty={
        draw=function()end,
        update=function()end,
        enter=function()end,
        exit=function()end,
        mousewasPressed=function()end
    }
    self.states=states or {}
    self.current=self.empty
end

function StateMachine:change(stateName,enterParams)
    assert(self.states[stateName])
    self.current:exit()
    self.current=self.states[stateName]()
    self.current:enter(enterParams)
end

function StateMachine:mousewasPressed(button)
    self.current:mousewasPressed(button) 
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:draw()
    self.current:draw()
end