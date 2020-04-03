module Automaton

using OrderedCollections

export State, Transition, StateMachine

abstract type AbstractState end
abstract type AbstractTransition end

const StateSym = Symbol
const TransitionSym = Symbol
const FunctionSym = Symbol

mutable struct StateCallback
    enter_state::OrderedDict{}
    leave_state::OrderedDict{}
    function StateCallback(enter_state::OrderedDict{}=OrderedDict(),
        leave_state::OrderedDict{}=OrderedDict())
        return new(enter_state, leave_state)
    end
end

mutable struct TransitionCallback
    start_transition::OrderedDict{}
    end_transition::OrderedDict{}
    function TransitionCallback(start_transition::OrderedDict{}=OrderedDict(),
        end_transition::OrderedDict{}=OrderedDict())
        return new(start_transition, end_transition)
    end
end

mutable struct StateMachineCallback
    start_any_transition::OrderedDict{}
    end_any_transition::OrderedDict{}
    enter_any_state::OrderedDict{}
    leave_any_state::OrderedDict{}
    function TransitionCallback(start_any_transition::OrderedDict{}=OrderedDict(),
        end_any_transition::OrderedDict{}=OrderedDict(),
        enter_any_state::OrderedDict{}=OrderedDict(),
        leave_any_state::OrderedDict{}=OrderedDict())
        return new(start_any_transition, end_any_transition, enter_any_state, leave_any_state)
    end
end

mutable struct State <: AbstractState
    callbacks::StateCallback
    function State(callbacks::StateCallback=StateCallback())
        return new(callbacks)
    end
end

mutable struct Transition <: AbstractTransition
    from::StateSym
    to::StateSym
    callbacks::TransitionCallback
    function Transition(from::StateSym, to::StateSym, callbacks::TransitionCallback=TransitionCallback())
        return new(from, to, callbacks)
    end
end

mutable struct StateMachine
    states::Dict{StateSym,<:AbstractState}
    transitions::Dict{TransitionSym,<:AbstractTransition}
    callbacks::StateMachineCallback
    current::Union{StateSym, Nothing}
    function StateMachine(states::Dict{StateSym,<:AbstractState},
        transitions::Dict{TransitionSym,<:AbstractTransition},
        callbacks::StateMachineCallback=StateMachineCallback(),
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
