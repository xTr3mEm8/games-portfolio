-- StateMachine class definition
StateMachine = Class{}

-- Initialize StateMachine object
function StateMachine:init(states)
    -- Define an empty state with placeholder functions
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }

    -- Set the initial current state to be empty
    self.current = self.empty

    -- Store the states passed during initialization
    self.states = states or {}
end

-- Change to a new state
function StateMachine:change(stateName, enterParams)
    -- Ensure that the requested state exists
    assert(self.states[stateName], "State does not exist!")

    -- Exit the current state
    self.current:exit()

    -- Set the new current state to the requested state
    self.current = self.states[stateName]()

    -- Enter the new state with optional parameters
    self.current:enter(enterParams)
end

-- Update the current state
function StateMachine:update(dt)
    self.current:update(dt)
end

-- Render the current state
function StateMachine:render()
    self.current:render()
end
