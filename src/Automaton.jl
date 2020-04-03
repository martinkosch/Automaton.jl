module Automaton

using OrderedCollections

export State, Transition, StateMachine
export is_connected, is_switchable
export fire!, fire_unambiguous!, initialize!
export add_state!, add_transition!, add_state_machine_callbacks!,
replace_state_machine_callbacks!, remove_state_machine_callbacks!,
add_transition_callbacks!, replace_transition_callbacks!,
remove_transition_callbacks!, add_state_callbacks!,
replace_state_callbacks!, remove_state_callbacks!,
add_conditions!, replace_conditions!, remove_conditions!

end # module
