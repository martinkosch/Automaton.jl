function is_connected(sm::StateMachine, to_key::Symbol, from_key::Symbol=sm.current)
    for value in values(sm.transitions)
        haskey(states, value.from_key) && haskey(states, value.to_key) && return true
    end
    return false
end

function is_switchable(sm::StateMachine, transition_key::Symbol)
    (sm.transitions[transition_key].from == sm.current) || return false
    is_conditions_fulfilled(sm, transition_key) || return false
    return true
end

function is_conditions_fulfilled(sm::StateMachine, transition_key::Symbol)
    if isa(sm.transitions[transition_key].conditions, OrderedDict)
        for condition in values(sm.transitions[transition_key].conditions)
            condition() || return false # Test all conditions #TODO: Specify condition arguments
        end
    end
    return true
end

function next_transitions(sm::StateMachine, state_key::Symbol=sm.current)
    res = Vector{Symbol}()
    for (key, value) in sm.transitions
        (value.from == state_key) && push!(res, key)
    end
    return res
end

function preceeding_transitions(sm::StateMachine, state_key::Symbol=sm.current)
    res = Vector{Symbol}()
    for (key, value) in sm.transitions
        (value.to == state_key) && push!(res, key)
    end
    return res
end

function adjacent_transitions(sm::StateMachine, state_key::Symbol=sm.current)
    return [preceeding_transitions(sm, state_key); next_transitions(sm, state_key)]
end

function all_source_states(sm::StateMachine)
    res = Vector{Symbol}()
    for key in keys(sm.states)
        if (length(preceeding_transitions(sm, key)) == 0) &&
            (length(next_transitions(sm, key)) > 0)
            push!(res, key)
        end
    end
    return res
end

function all_sink_states(sm::StateMachine)
    res = Vector{Symbol}()
    for key in keys(sm.states)
        if (length(next_transitions(sm, key)) == 0) &&
            (length(preceeding_transitions(sm, key)) > 0)
            push!(res, key)
        end
    end
    return res
end

function all_unconnected_states(sm::StateMachine)
    res = Vector{Symbol}()
    for key in keys(sm.states)
        (length(adjacent_transitions(sm, key)) == 0) && push!(res, key)
    end
    return res
end
