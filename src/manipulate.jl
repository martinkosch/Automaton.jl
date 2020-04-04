function set_initial!(state_machine::StateMachine, intial_state_key::Symbol)
    if haskey(state_machine.states, intial_state_key)
        if isa(state_machine.states[intial_state_key], State)
            state_machine.initial = intial_state_key
        else
            error("$intial_state_key does already exist but is not of type State!")
        end
    else
        add_state!(state_machine, intial_state_key)
        state_machine.initial = intial_state_key
    end
    return intial_state_key
end

function _add_state!(
state_machine::StateMachine,
type::Type{<:AbstractState},
state_key::Symbol;
callbacks::Union{StateCallback,Nothing}=nothing,
overwrite::Bool=false)
    if haskey(state_machine.states, state_key) && !overwrite
            error("$state_key already exists! Use overwrite keyword to replace current entry.")
    end
    if type == State
        state_machine.states[state_key] = State(;callbacks=callbacks)
    elseif type == Junction
        state_machine.states[state_key] = Junction()
    end
    return state_key
end

function add_state!(
state_machine::StateMachine,
state_key::Symbol;
callbacks::Union{StateCallback,Nothing}=nothing,
overwrite::Bool=false)
    _add_state!(state_machine,
    State,
    state_key;
    callbacks=callbacks,
    overwrite=overwrite)
end

function add_state!(state_machine; callbacks=nothing)
    state_key = new_unique_key(state_machine, State)
    _add_state!(state_machine, State, state_key; callbacks=callbacks)
end

function add_junction!(state_machine::StateMachine,
junction::Symbol;
overwrite::Bool=false)
    _add_state!(state_machine,
    Junction,
    junction;
    overwrite=overwrite)
end

function add_junction!(state_machine)
    junction_key = new_unique_key(state_machine, Junction)
    _add_state!(state_machine, Junction, junction_key)
end


function remove_state!(
state_machine::StateMachine,
state_key::Symbol)
    if haskey(state_machine.states, state_key)
        delete!(state_machine.states, state_key)
        affected_transitions = all_adjacent_transitions(state_machine, state_key)
        for transition in affected_transitions
            remove_transition!(state_machine, transition)
        end
        return state_key
    else
        error("$state_key does not exist!")
    end
end

function add_transition!(
state_machine::StateMachine,
transition_key::Symbol,
from_key::Symbol,
to_key::Symbol;
callbacks::Union{TransitionCallback,Nothing}=nothing,
conditions::Union{OrderedDict{Symbol,Any},Nothing}=nothing,
overwrite::Bool=false)
    if haskey(state_machine.transitions, transition_key) && !overwrite
        error("$transition_key already exists! Use overwrite keyword to replace current entry.")
    end
    has_from = haskey(state_machine.states, from_key)
    has_to = haskey(state_machine.states, to_key)
    if !has_from && !has_to
        error("States $from_key and $to_key do not exist! They need to be created before they can be connected.")
    elseif !has_from || !has_to
        error("State $(!has_from ? from_key : to_key) does not exist! It has to be created first.")
    else
        state_machine.transitions[transition_key] = Transition(from_key, to_key;callbacks=callbacks, conditions=conditions)
        return transition_key
    end
end

function add_transition!(
state_machine::StateMachine,
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
    return transition_key
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
