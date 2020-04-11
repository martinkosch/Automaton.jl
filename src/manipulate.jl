function set_initial!(sm::StateMachine, intial_state_key::Symbol)
    if haskey(sm.states, intial_state_key)
        if isa(sm.states[intial_state_key], State)
            sm.initial = intial_state_key
        else
            error("$intial_state_key does already exist but is not of type State.")
        end
    else
        error("$intial_state_key does not exist. It needs to be created before it can be set as initial state.")
    end
    return intial_state_key
end

function free_initial!(sm::StateMachine)
    sm.initial = nothing
end

function _add_state!(
sm::StateMachine,
type::Type{<:AbstractState},
state_key::Symbol;
callbacks::Union{StateCallback,Nothing}=nothing,
overwrite::Bool=false)
    if haskey(sm.states, state_key) && !overwrite
            error("$state_key already exists. Use overwrite keyword to replace current entry.")
    end
    if type == State
        sm.states[state_key] = State(;callbacks=callbacks)
    elseif type == Junction
        sm.states[state_key] = Junction()
    end
    return state_key
end

function add_state!(
sm::StateMachine,
state_key::Symbol;
callbacks::Union{StateCallback,Nothing}=nothing,
overwrite::Bool=false)
    _add_state!(sm,
    State,
    state_key;
    callbacks=callbacks,
    overwrite=overwrite)
end

function add_state!(sm; callbacks=nothing)
    state_key = new_unique_key(sm, State)
    _add_state!(sm, State, state_key; callbacks=callbacks)
end

function add_junction!(sm::StateMachine,
junction::Symbol;
overwrite::Bool=false)
    _add_state!(sm,
    Junction,
    junction;
    overwrite=overwrite)
end

function add_junction!(sm)
    junction_key = new_unique_key(sm, Junction)
    _add_state!(sm, Junction, junction_key)
end


function remove_state!(
sm::StateMachine,
state_key::Symbol)
    if haskey(sm.states, state_key)
        delete!(sm.states, state_key)
        if sm.initial == state_key
            sm.initial = nothing
        end

        affected_transitions = adjacent_transitions(sm, state_key)
        for transition in affected_transitions
            remove_transition!(sm, transition)
        end
        return state_key
    else
        error("$state_key does not exist.")
    end
end

remove_junction!(sm::StateMachine, junction_key::Symbol) =
remove_state!(sm, junction_key)

function add_transition!(
sm::StateMachine,
transition_key::Symbol,
from_key::Symbol,
to_key::Symbol;
callbacks::Union{TransitionCallback,Nothing}=nothing,
conditions::Union{OrderedDict{Symbol,Any},Nothing}=nothing,
overwrite::Bool=false)
    if haskey(sm.transitions, transition_key) && !overwrite
        error("$transition_key already exists. Use overwrite keyword to replace current entry.")
    end
    has_from = haskey(sm.states, from_key)
    has_to = haskey(sm.states, to_key)
    if !has_from && !has_to
        error("States $from_key and $to_key do not exist. They need to be created before they can be connected.")
    elseif !has_from || !has_to
        error("State $(!has_from ? from_key : to_key) does not exist. It has to be created first.")
    else
        sm.transitions[transition_key] = Transition(from_key, to_key;callbacks=callbacks, conditions=conditions)
        return transition_key
    end
end

function add_transition!(
sm::StateMachine,
from_key::Symbol,
to_key::Symbol;
callbacks=nothing,
conditions=nothing)
    transition_key = new_unique_key(sm, Transition)
    add_transition!(sm, transition_key, from_key, to_key;
    callbacks=callbacks, conditions=conditions)
end

function remove_transition!(sm::StateMachine, transition_key::Symbol)
    delete!(sm.transitions, transition_key)
    return transition_key
end

function add_state_machine_callbacks!(sm::StateMachine,
    callbacks::StateMachineCallback)

end

function replace_state_machine_callbacks!(sm::StateMachine,
    callbacks::Union{StateMachineCallback,Nothing})

end

remove_state_machine_callbacks!(sm::StateMachine) =
replace_state_machine_callbacks!(sm, nothing)

function add_transition_callbacks!(sm::StateMachine,
    transition_key::Symbol,
    callbacks::TransitionCallback)

end

function replace_transition_callbacks!(sm::StateMachine,
    transition_key::Symbol,
    callbacks::Union{TransitionCallback,Nothing})

end

remove_transition_callbacks!(sm::StateMachine, transition_key::Symbol) =
replace_transition_callbacks!(sm, transition_key, nothing)

function add_state_callbacks!(sm::StateMachine,
    state_key::Symbol,
    callbacks::StateCallback)

end

function replace_state_callbacks!(sm::StateMachine,
    state_key::Symbol,
    callbacks::Union{StateCallback,Nothing})

end

remove_state_callbacks!(sm::StateMachine, state_key::Symbol) =
replace_state_callbacks!(sm, state_key, nothing)

function add_conditions!(sm::StateMachine,
    transition_key::Symbol,
    conditions::OrderedDict{Symbol,Any})

end

function replace_conditions!(sm::StateMachine,
    transition_key::Symbol,
    conditions::Union{OrderedDict{Symbol,Any},Nothing})

end

remove_conditions!(sm::StateMachine, transition_key::Symbol) =
replace_conditions!(sm, transition_key, nothing)

function new_unique_key(sm::StateMachine, type::Type; identifier::AbstractString="")
    dict = Dict{Symbol,Any}()
    default_identifier = '_'
    if type == State
        default_identifier = "S"
        dict = sm.states
    elseif type == Junction
        default_identifier =  "J"
        dict = sm.states
    elseif type == Transition
        default_identifier =  "T"
        dict = sm.transitions
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
