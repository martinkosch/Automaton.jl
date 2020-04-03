module Automaton

using OrderedCollections

# export StateMachine

abstract type AbstractState end
abstract type AbstractTransition end

const StateSym = Symbol
const TransitionSym = Symbol
const FunctionSym = Symbol

mutable struct StateCallback
    enter_state::OrderedDict{}
    leave_state::OrderedDict{}
end

mutable struct TransitionCallback
    start_transition::OrderedDict{}
    end_transition::OrderedDict{}
end

mutable struct StateMachineCallback
    initial::OrderedDict{}
    final::OrderedDict{}
    start_any_transition::OrderedDict{}
    end_any_transition::OrderedDict{}
    enter_any_state::OrderedDict{}
    leave_any_state::OrderedDict{FunctionSym, }
end

struct State <: AbstractState
    callbacks::StateCallback
end

struct Transition <: AbstractTransition
    from::StateSym
    to::StateSym
    callbacks::TransitionCallback
end

mutable struct StateMachine
    states::Dict{StateSym,<:AbstractState}
    transitions::Dict{TransitionSym,<:AbstractTransition}
    callbacks::StateMachineCallback
    current::Union{StateSym, Nothing}
    terminal::Union{StateSym, Nothing}
    function StateMachine(states::Dict{StateSym,<:AbstractState},
        transitions::Dict{TransitionSym,<:AbstractTransition},
        callbacks::StateMachineCallback,
        initial::Union{StateSym, Nothing}=nothing,
        terminal::Union{StateSym, Nothing}=nothing)
        return new(states, transitions, callbacks, inital, terminal)
    end
end


function fire!(state_machine::StateMachine, transition::TransitionSym)

end

function is_reachable(state_machine::StateMachine, to::StateSym, from::StateSym=state_machine.current)

end

end # module
