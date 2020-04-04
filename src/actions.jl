function fire!(state_machine::StateMachine, transition::Symbol)
    is_switchable(state_machine, transition) || return false
    switch_unsafe!(state_machine, transition)
    return true
end

function fire_unambiguous!(state_machine::StateMachine)
    if isnothing(state_machine.current)
        initialize!(state_machine)
    elseif length(next_transitions(state_machine)) == 1
        fire!(state_machine, next_transitions(state_machine)[1])
    end
end

function switch_unsafe!(state_machine::StateMachine, transition::Symbol)
    state_machine_callbacks = state_machine.callbacks
    transition = state_machine.transitions[transition]
    transition_callbacks = transition.callbacks
    from_state_callbacks = state_machine.states[transition.from]
    to_state_callbacks = state_machine.states[transition.to]
    call_callbacks_before(state_machine_callbacks, transition_callbacks, from_state_callbacks)
    state_machine.current = transition.to # State change
    call_callbacks_after(state_machine_callbacks, transition_callbacks, to_state_callbacks)
end
