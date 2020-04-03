abstract type AbstractState end
abstract type AbstractTransition end

mutable struct StateCallback
    enter_state::OrderedDict{Symbol,Any}
    leave_state::OrderedDict{Symbol,Any}
    function StateCallback(enter_state::OrderedDict{}=OrderedDict(),
        leave_state::OrderedDict{}=OrderedDict())
        return new(enter_state, leave_state)
    end
end

mutable struct TransitionCallback
    start_transition::OrderedDict{Symbol,Any}
    end_transition::OrderedDict{Symbol,Any}
    function TransitionCallback(start_transition::OrderedDict{}=OrderedDict(),
        end_transition::OrderedDict{}=OrderedDict())
        return new(start_transition, end_transition)
    end
end

mutable struct StateMachineCallback
    start_any_transition::OrderedDict{Symbol,Any}
    end_any_transition::OrderedDict{Symbol,Any}
    enter_any_state::OrderedDict{Symbol,Any}
    leave_any_state::OrderedDict{Symbol,Any}
    function StateMachineCallback(start_any_transition::OrderedDict{}=OrderedDict(),
        end_any_transition::OrderedDict=OrderedDict(),
        enter_any_state::OrderedDict=OrderedDict(),
        leave_any_state::OrderedDict=OrderedDict())
        return new(start_any_transition, end_any_transition, enter_any_state, leave_any_state)
    end
end

mutable struct State <: AbstractState
    callbacks::Union{StateCallback,Nothing}
    function State(;callbacks=nothing)
        return new(callbacks)
    end
end

mutable struct Transition <: AbstractTransition
    from::Symbol
    to::Symbol
    conditions::Union{OrderedDict{Symbol,Any},Nothing}
    callbacks::Union{TransitionCallback,Nothing}
    function Transition(from::Symbol, to::Symbol; conditions=nothing, callbacks=nothing)
        return new(from, to, conditions, callbacks)
    end
end

mutable struct StateMachine
    states::Dict{Symbol,<:AbstractState}
    transitions::Dict{Symbol,<:AbstractTransition}
    initial::Symbol
    callbacks::Union{StateMachineCallback,Nothing}
    current::Union{Symbol, Nothing}
    function StateMachine(states::Dict{Symbol,<:AbstractState},
        transitions::Dict{Symbol,<:AbstractTransition},
        initial::Union{Symbol,Nothing};
        callbacks=nothing,
        current=nothing)
        return new(states, transitions, initial, callbacks, current)
    end
end

function StateMachine(transitions::Dict{Symbol,<:AbstractTransition},
    initial::Symbol;
    callbacks=nothing,
    current=nothing)
    states = extract_states(transitions)
    return StateMachine(states, transitions, initial, callbacks=callbacks; current=current)
end

function extract_states(transitions::Dict{Symbol,<:AbstractTransition})
    states = Dict{Symbol,State}()
    for value in values(transitions)
        haskey(states, value.from) || (states[value.from] = State())
        haskey(states, value.to) || (states[value.to] = State())
    end
    return states
end
