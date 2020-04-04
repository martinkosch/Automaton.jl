function add_initial!(state_machine::StateMachine, intial_state_key::Symbol)
    state_machine.initial = intial_state_key
    return true
end

function add_state!(state_machine::StateMachine,
    state_key::Symbol;
    callbacks::Union{StateCallback,Nothing}=nothing,
    overwrite::Bool=false,
    only_if_new::Bool=false)
    if haskey(state_machine.states, state_key) && !overwrite
        if only_if_new
            return state_key
        else
            error("$state_key already exists! Use overwrite keyword to replace current entry.")
        end
    end
    state_machine.states[state_key] = State(;callbacks=callbacks)
    return state_key
end

function add_state!(state_machine; callbacks=nothing)
    state_key = new_unique_key(state_machine, State)
    add_state!(state_machine, state_key; callbacks=callbacks)
end

function remove_state!(state_machine::StateMachine,
    state_key::Symbol)
    if haskey(state_machine.states, state_key)
        delete!(state_machine.states, state_key)
        affected_transitions = all_adjacent_transitions(state_machine, state_key)
        for transition in affected_transitions
            remove_transition!(state_machine, transition)
        end
        return true
    else
        return false
    end
end

function add_transition!(state_machine::StateMachine,
    transition_key::Symbol,
    from_key::Symbol,
    to_key::Symbol;
    callbacks::Union{TransitionCallback,Nothing}=nothing,
    conditions::Union{OrderedDict{Symbol,Any},Nothing}=nothing,
    overwrite::Bool=false)
    if haskey(state_machine.transitions, transition_key) && !overwrite
        error("$transition_key already exists! Use overwrite keyword to replace current entry.")
    end
    state_machine.transitions[transition_key] = Transition(from_key, to_key;callbacks=callbacks, conditions=conditions)
    add_state!(state_machine, from_key; only_if_new=true)
    add_state!(state_machine, to_key; only_if_new=true)
    return transition_key
end

function add_transition!(state_machine,
    from_key::Symbol,
    to_key::Symbol;
    callbacks=nothing,
    conditions=nothing)
    transition_key = new_unique_key(state_machine, Transition)
    add_transition!(state_machine, transition_key, from_key, to_key;
    callbacks=callbacks, conditions=conditions)
end

function remove_transition!(state_machine::StateMachine, transition_key::Symbol)
    delete!(state_machine.transitions, transition_key)
    return true
end

function add_state_machine_callbacks!(state_machine::StateMachine,
    callbacks::StateMachineCallback)

end

function replace_state_machine_callbacks!(state_machine::StateMachine,
    callbacks::Union{StateMachineCallback,Nothing})

end

remove_state_machine_callbacks!(state_machine::StateMachine) =
replace_state_machine_callbacks!(state_machine, nothing)

function add_transition_callbacks!(state_machine::StateMachine,
    transition_key::Symbol,
    callbacks::TransitionCallback)

end

function replace_transition_callbacks!(state_machine::StateMachine,
    transition_key::Symbol,
    callbacks::Union{TransitionCallback,Nothing})

end

remove_transition_callbacks!(state_machine::StateMachine, transition_key::Symbol) =
replace_transition_callbacks!(state_machine, transition_key, nothing)

function add_state_callbacks!(state_machine::StateMachine,
    state_key::Symbol,
    callbacks::StateCallback)

end

function replace_state_callbacks!(state_machine::StateMachine,
    state_key::Symbol,
    callbacks::Union{StateCallback,Nothing})

end

remove_state_callbacks!(state_machine::StateMachine, state_key::Symbol) =
replace_state_callbacks!(state_machine, state_key, nothing)

function add_conditions!(state_machine::StateMachine,
    transition_key::Symbol,
    conditions::OrderedDict{Symbol,Any})

end

function replace_conditions!(state_machine::StateMachine,
    transition_key::Symbol,
    conditions::Union{OrderedDict{Symbol,Any},Nothing})

end

remove_conditions!(state_machine::StateMachine, transition_key::Symbol) =
replace_conditions!(state_machine, transition_key, nothing)

function new_unique_key(state_machine::StateMachine, type::Type; identifier::AbstractString="")
    dict = Dict{Symbol,Any}()
    default_identifier = '_'
    if type == State
        default_identifier = "S"
        dict = state_machine.states
    elseif type == Junction
        default_identifier =  "J"
        dict = state_machine.states
    elseif type == Transition
        default_identifier =  "T"
        dict = state_machine.transitions
    else
        error("No identifier defined for $type.")
    end
    return new_unique_key(dict, type, isempty(identifier) ? default_identifier : identifier)
end

function new_unique_key(dict::Dict{Symbol,<:Any}, type, identifier::AbstractString)
    number = count([isa(value,type) for value in values(dict)]) + 1
    while haskey(dict, Symbol(identifier, number))
        number = number + 1
    end
    return Symbol(identifier, number)
end
