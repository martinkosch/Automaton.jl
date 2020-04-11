using Automaton
using Test

@testset "Basic manipulation" begin
    sm = StateMachine()
    @test_throws ErrorException remove_state!(sm, :not_there)
    default_state_key = add_state!(sm)
    @test haskey(sm.states, default_state_key)
    remove_state!(sm, default_state_key)
    @test !haskey(sm.states, default_state_key)

    @test_throws ErrorException add_transition!(sm, :state1, :state2)
    add_state!(sm, :state1)
    @test_throws ErrorException add_transition!(sm, :state1, :state2)
    add_state!(sm, :state2)
    default_transition_key = add_transition!(sm, :state1, :state2)
    @test haskey(sm.transitions, default_transition_key)
    @test haskey(sm.states, :state1)
    @test haskey(sm.states, :state2)
    remove_transition!(sm, default_transition_key)
    @test !haskey(sm.transitions, default_transition_key)
    @test haskey(sm.states, :state1)
    @test haskey(sm.states, :state2)

    default_transition_key = add_transition!(sm, :state1, :state2)
    @test haskey(sm.transitions, default_transition_key)
    set_initial!(sm, :state1)
    @test sm.initial == :state1
    remove_state!(sm, :state1)
    @test_throws ErrorException set_initial!(sm, :state1)
    @test sm.initial == nothing
    @test !haskey(sm.transitions, default_transition_key)
    @test haskey(sm.states, :state2)

    add_junction!(sm, :junction1)
    @test_throws ErrorException set_initial!(sm, :junction1)
    add_transition!(sm, :transition1, :state2, :junction1)
    add_transition!(sm, :transition2, :junction1, :state2)
    remove_junction!(sm, :junction1)
    @test !haskey(sm.transitions, :transition1)
    @test !haskey(sm.transitions, :transition2)
end

@testset "Structure analysis" begin
    sm = StateMachine()
    @test length(all_source_states(sm)) == 0
    @test length(all_sink_states(sm)) == 0
    @test length(all_unconnected_states(sm)) == 0
    add_state!(sm, :state1)
    @test isempty(next_transitions(sm, :state1))
    @test isempty(preceeding_transitions(sm, :state1))
    @test isempty(adjacent_transitions(sm, :state1))
    @test length(all_source_states(sm)) == 0
    @test length(all_sink_states(sm)) == 0
    @test length(all_unconnected_states(sm)) == 1
    add_state!(sm, :state2)
    add_state!(sm, :state3)
    default_transition_key1 = add_transition!(sm, :state1, :state2)
    default_transition_key2 = add_transition!(sm, :state2, :state3)
    @test next_transitions(sm, :state1) == [default_transition_key1]
    @test isempty(preceeding_transitions(sm, :state1))
    @test adjacent_transitions(sm, :state1) == [default_transition_key1]
    @test next_transitions(sm, :state2) == [default_transition_key2]
    @test preceeding_transitions(sm, :state2) == [default_transition_key1]
    @test adjacent_transitions(sm, :state2) == [default_transition_key1, default_transition_key2]
    @test isempty(next_transitions(sm, :state3))
    @test preceeding_transitions(sm, :state3) == [default_transition_key2]
    @test adjacent_transitions(sm, :state3) == [default_transition_key2]
    @test length(all_source_states(sm)) == 1
    @test length(all_sink_states(sm)) == 1
    @test length(all_unconnected_states(sm)) == 0

    # next_transitions, preceeding_transitions, adjacent_transitions
    # all_source_states, all_sink_states, all_unconnected_states
end
