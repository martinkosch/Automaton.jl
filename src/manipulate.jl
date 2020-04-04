function add_state!(state_machine::StateMachine,
    state_key::Symbol,
    state_type::Type{<:AbstractState}=State;
    callbacks::Union{StateCallback,Nothing}=nothing,
    overwrite::Bool=false)
end

function add_state!(state_machine,
    state_type=State;
    callbacks=nothing)
    state_key = new_unique_key(state_machine, state_type)
    add_state!(state_machine, state_key, state_type; callbacks=callbacks)
end

function add_transition!(state_machine::StateMachine,
    transition_key::Symbol,
    transition_type::Type{<:AbstractState}=Transition;
    callbacks::Union{TransitionCallback,Nothing}=nothing,
    conditions::Union{OrderedDict{Symbol,Any},Nothing}=nothing,
    overwrite::Bool=false)
end

function add_transition!(state_machine,
    transition_type=Transition;
    callbacks=nothing,
    conditions=nothing)
    transition_key = new_unique_key(state_machine, transition_type)
    add_transition!(state_machine, transition_key, transition_type;
    callbacks=callbacks, conditions=conditions)
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

function new_unique_key(state_machine::StateMachine, type::Type; identifier::AbstractString=nothing)
    dict = Dict{Symbol,Any}()
    default_identifier = '_'
    if type == State
        default_identifier = 'S'
        dict = state_machine.states
    elseif type == Junction
        default_identifier =  'J'
        dict = state_machine.states
    elseif type == Transition
        default_identifier =  'T'
        dict = state_machine.transitions
    else
        error("No identifier defined for $type.")
    end
    return new_unique_key(dict, type, isnothing(identifier) ? default_identifier : identifier)
end

function new_unique_key(dict::Dict{Symbol,Any}, type, identifier::AbstractString)
    number = count([isa(type,value) for value in values(dict)])
    while haskey(value, identifier * string(number))
        number = number + 1
    end
    return identifier * string(number)
end
