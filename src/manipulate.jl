function add_state!(state_machine::StateMachine,
    state::Symbol;
    callbacks::Union{StateCallback,Nothing}=nothing,
    overwrite::Bool=false)

end

function add_transition!(state_machine::StateMachine,
    transition::Symbol;
    callbacks::Union{TransitionCallback,Nothing}=nothing,
    conditions::Union{OrderedDict{Symbol,Any},Nothing}=nothing;
    overwrite::Bool=false)

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
    transition::Symbol,
    callbacks::TransitionCallback)

end

function replace_transition_callbacks!(state_machine::StateMachine,
    transition::Symbol,
    callbacks::Union{TransitionCallback,Nothing})

end

remove_transition_callbacks!(state_machine::StateMachine, transition::Symbol) =
replace_transition_callbacks!(state_machine, transition, nothing)

function add_state_callbacks!(state_machine::StateMachine,
    state::Symbol,
    callbacks::StateCallback)

end

function replace_state_callbacks!(state_machine::StateMachine,
    state::Symbol,
    callbacks::Union{StateCallback,Nothing})

end

remove_state_callbacks!(state_machine::StateMachine, state::Symbol) =
replace_state_callbacks!(state_machine, state, nothing)

function add_conditions!(state_machine::StateMachine,
    transition::Symbol,
    conditions::OrderedDict{Symbol,Any})

end

function replace_conditions!(state_machine::StateMachine,
    transition::Symbol,
    conditions::Union{OrderedDict{Symbol,Any},Nothing})

end

remove_conditions!(state_machine::StateMachine, transition::Symbol) =
replace_conditions!(state_machine, transition, nothing)
