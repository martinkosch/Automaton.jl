struct CallbackContext
    statemachine
    transition
end

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
    initialization::OrderedDict{Symbol,Any}
    function StateMachineCallback(any_arrival::OrderedDict{}=OrderedDict(),
        any_departure::OrderedDict=OrderedDict(),
        any_takeoff::OrderedDict=OrderedDict(),
        any_landing::OrderedDict=OrderedDict(),
        initialization::OrderedDict=OrderedDict())
        return new(any_arrival, any_departure, any_takeoff, any_landing, initialization)
    end
end


abstract type AbstractState end

mutable struct State <: AbstractState
    callbacks
    function State(;callbacks::Union{StateCallback,Nothing}=nothing)
        return new(callbacks)
    end
end


struct Junction <: AbstractState end


abstract type AbstractTransition end

mutable struct Transition <: AbstractTransition
    from
    to
    conditions
    callbacks
    function Transition(
    from::Symbol,
    to::Symbol;
    conditions::Union{OrderedDict{Symbol,Any},Nothing}=nothing,
    callbacks::Union{TransitionCallback,Nothing}=nothing)
        return new(from, to, conditions, callbacks)
    end
end


mutable struct StateMachine
    states
    transitions
    initial
    callbacks
    current::Union{Symbol,Nothing}
    function StateMachine(
    states::Dict{Symbol,<:AbstractState}=Dict{Symbol,AbstractState}(),
    transitions::Dict{Symbol,<:AbstractTransition}=Dict{Symbol,AbstractTransition}();
    initial::Union{Symbol,Nothing}=nothing,
    callbacks::Union{StateMachineCallback,Nothing}=nothing)
        return new(states, transitions, initial, callbacks, nothing)
    end
end
