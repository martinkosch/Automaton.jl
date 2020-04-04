function is_connected(state_machine::StateMachine, to_key::Symbol, from_key::Symbol=state_machine.current)
    for value in values(state_machine.transitions)
        haskey(states, value.from_key) && haskey(states, value.to_key) && return true
    end
    return false
end

function is_switchable(state_machine::StateMachine, transition_key::Symbol)
    (state_machine.transitions[transition_key].from == state_machine.current) || return false
    is_conditions_fulfilled(state_machine, transition_key) || return false
    return true
end

function is_conditions_fulfilled(state_machine::StateMachine, transition_key::Symbol)
    if isa(state_machine.transitions[transition_key].conditions, OrderedDict)
        for condition in values(state_machine.transitions[transition_key].conditions)
            condition() || return false # Test all conditions #TODO: Specify condition arguments
        end
    end
    return true
end

function next_transitions(state_machine::StateMachine, state_key::Symbol=state_machine.current)
    res = Vector{Symbol}()
    for (key, value) in state_machine.transitions
        (value.from == state_key) && push!(res, key)
    end
    return res
end

function preceeding_transitions(state_machine::StateMachine, state_key::Symbol=state_machine.current)
    res = Vector{Symbol}()
    for (key, value) in state_machine.transitions
        (value.to == state_key) && push!(res, key)
    end
    return res
end

function adjacent_transitions(state_machine::StateMachine, state_key::Symbol=state_machine.current)
    return [preceeding_transitions(state_machine, state_key); next_transitions(state_machine, state_key)]
end

function all_source_states(state_machine::StateMachine)
    res = Vector{Symbol}()
    for key in state_machine.states
        (length(preceeding_transitions(state_machine, key)) == 0) && push!(res, key)
    end
    return res
end

function all_sink_states(state_machine::StateMachine)
    res = Vector{Symbol}()
    for key in state_machine.states
        (length(next_transitions(state_machine, key)) == 0) && push!(res, key)
    end
    return res
end

function all_unconnected_states(state_machine::StateMachine)
    res = Vector{Symbol}()
    for key in state_machine.states
        (length(all_adjacent_transitions(state_machine, key)) == 0) && push!(res, key)
    end
    return res
end
