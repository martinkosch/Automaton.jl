module Automaton

using OrderedCollections

export State, Junction, Transition, StateMachine
export is_connected, is_switchable, is_conditions_fulfilled,
next_transitions, preceeding_transitions, adjacent_transitions,
all_source_states, all_sink_states, all_unconnected_states
export run!, fire!, fire_unambiguous!
export set_initial!, free_initial!,
add_state!, add_junction!, remove_state!, remove_junction!,
add_transition!, remove_transition!,
add_state_machine_callbacks!, replace_state_machine_callbacks!, remove_state_machine_callbacks!,
add_transition_callbacks!, replace_transition_callbacks!, remove_transition_callbacks!,
add_state_callbacks!, replace_state_callbacks!, remove_state_callbacks!,
add_conditions!, replace_conditions!, remove_conditions!

include("types.jl")
include("manipulate.jl")
include("analyze.jl")
include("actions.jl")

end # module
