using Automaton
using Test

@testset "Basic manipulation" begin
    sm = StateMachine()
    @test_throws ErrorException remove_state!(sm, :not_there)
    default_state_key = add_state!(sm)
    @test haskey(sm.states, default_state_key)
    remove_state!(sm, default_state_key)
    @test !haskey(sm.states, default_state_key)
    @test_throws ErrorException add_transition!(sm, :not_there, :also_not_there)

    add_state!(sm, :state1)
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
    remove_state!(sm, :state1)
    @test !haskey(sm.transitions, default_transition_key)
    @test haskey(sm.states, :state2)


    set_initial!(sm, :state1)
    @test haskey(sm.states, :state1)
    set_initial!(sm, :state3)
    @test haskey(sm.states, :state3)

    add_junction!(sm)
end
