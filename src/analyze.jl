function is_connected(state_machine::StateMachine, to::Symbol, from::Symbol=state_machine.current)
    for value in values(state_machine.transitions)
        haskey(states, value.from) && haskey(states, value.to) && return true
    end
    return false
end

function is_switchable(state_machine::StateMachine, transition::Symbol)
    (state_machine[:transition].from == state_machine.current) || return false
    is_conditions_fulfilled(state_machine, transition) || return false
    return true
end

function is_conditions_fulfilled(state_machine::StateMachine, transition::Symbol)
    if isa(state_machine[:transition].conditions, OrderedDict)
        for condition in values(state_machine[:transition].conditions)
            condition() || return false # Test all conditions #TODO: Specify condition arguments
        end
    end
end

function next_transitions(state_machine::StateMachine, state::Symbol=state_machine.current)
    res = Vector{Symbol}()
    for (key, value) in state_machine.transitions
        (value.from == state) && push!(res, key)
    end
    return res
end

function preceeding_transitions(state_machine::StateMachine, state::Symbol=state_machine.current)
    res = Vector{Symbol}()
    for (key, value) in state_machine.transitions
        (value.to == state) && push!(res, key)
    end
    return res
end
