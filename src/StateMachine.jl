module StateMachine

using OrderedCollections

abstract type AbstractState end
abstract type AbstractTransition end

struct State <: AbstractState
    callbacks::StateCallback
end

struct Transition <: AbstractTransition
    from::State
    to::State
    callbacks::TransitionCallback
end

mutable struct StateMachine
    states::Dict{Symbol,<:AbstractState}
    transitions::Dict{Symbol,<:AbstractTransition}
    callbacks::StateMachineCallback
    current::Symbol
    terminal::Union{Symbol, Nothing}
    function StateMachine(states, transitions, callbacks, current, terminal=nothing)

    end
end

mutable struct StateCallbacks
    enter_state::OrderedDict{}
    leave_state::OrderedDict{}
end

mutable struct TransitionCallbacks
    start_transition::OrderedDict{}
    end_transition::OrderedDict{}
end

mutable struct StateMachineCallbacks
    initial::OrderedDict{}
    final::OrderedDict{}
    start_any_transition::OrderedDict{}
    end_any_transition::OrderedDict{}
    enter_any_state::OrderedDict{}
    leave_any_state::OrderedDict{}
end

function fire!(state_machine::StateMachine, transition::Symbol)

end

function is_reachable(state_machine::StateMachine, to::Symbol, from::Symbol=state_machine.current)

end

end # module
