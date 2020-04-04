
mutable struct StateCallback
    arrival::OrderedDict{Symbol,Any}
    during::OrderedDict{Symbol,Any}
    departure::OrderedDict{Symbol,Any}
    function StateCallback(arrival::OrderedDict{}=OrderedDict(),
        during::OrderedDict{}=OrderedDict(),
        departure::OrderedDict{}=OrderedDict())
        return new(arrival, during, departure)
    end
end

mutable struct TransitionCallback
    takeoff::OrderedDict{Symbol,Any}
    landing::OrderedDict{Symbol,Any}
    function TransitionCallback(takeoff::OrderedDict{}=OrderedDict(),
        landing::OrderedDict{}=OrderedDict())
        return new(takeoff, landing)
    end
end

mutable struct StateMachineCallback
    any_arrival::OrderedDict{Symbol,Any}
    any_departure::OrderedDict{Symbol,Any}
    any_takeoff::OrderedDict{Symbol,Any}
    any_landing::OrderedDict{Symbol,Any}
    function StateMachineCallback(any_arrival::OrderedDict{}=OrderedDict(),
        any_departure::OrderedDict=OrderedDict(),
        any_takeoff::OrderedDict=OrderedDict(),
        any_landing::OrderedDict=OrderedDict())
        return new(any_arrival, any_departure, any_takeoff, any_landing)
    end
end


abstract type AbstractState end

mutable struct State <: AbstractState
    callbacks::Union{StateCallback,Nothing}
end

function State(;callbacks=nothing)
    return State(callbacks)
end

struct Junction <: AbstractState end


abstract type AbstractTransition end

mutable struct Transition <: AbstractTransition
    from::Symbol
    to::Symbol
    conditions::Union{OrderedDict{Symbol,Any},Nothing}
    callbacks::Union{TransitionCallback,Nothing}
end

function Transition(from::Symbol, to::Symbol; conditions=nothing, callbacks=nothing)
    return Transition(from, to, conditions, callbacks)
end

mutable struct StateMachine
    states::Dict{Symbol,<:AbstractState}
    transitions::Dict{Symbol,<:AbstractTransition}
    initial::Symbol
    callbacks::Union{StateMachineCallback,Nothing}
    current::Symbol
end

function StateMachine(states::Dict{Symbol,<:AbstractState},
    transitions,
    initial;
    callbacks=nothing,
    current=initial)
    return StateMachine(states, transitions, initial, callbacks, current)
end

function StateMachine(transitions::Dict{Symbol,<:AbstractTransition},
    initial;
    callbacks=nothing,
    current=initial)
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
