function run!(sm::StateMachine)
    is_ready_to_run(sm)
    sm.current = sm.initial
    while true # TODO: while running pause stop reset
        fired_t = wait_current_conditions(sm)
        fire!(sm, fired_t)
    end
end

function fire!(sm::StateMachine, t::Symbol)
    is_switchable(sm, t) || return false
    switch_unsafe!(sm, t)
    return true
end

function fire_unambiguous!(sm::StateMachine)
    if isnothing(sm.current)
        initialize!(sm)
    elseif length(next_transitions(sm)) == 1
        fire!(sm, next_transitions(sm)[1])
    end
end

function switch_unsafe!(sm::StateMachine, t::Symbol)
    sm_cb = sm.callbacks
    t = sm.transitions[t]
    t_cb = t.callbacks
    from_state_cb = sm.states[t.from]
    to_state_cb = sm.states[t.to]
    call_callbacks_before(sm_cb, t_cb, from_state_cb)
    sm.current = t.to # State change
    call_callbacks_after(sm_cb, t_cb, to_state_cb)
end

function is_ready_to_run(sm::StateMachine)
    if isnothing(sm.initial)
        error("The inital state has not been set yet.")
    end
end
