defmodule TableTest do
    use ExUnit.Case
    alias Ddz.Table
    alias Ddz.Player

    test "Next player" do
        assert Table.next_player({1,2,3},0) == 1
        assert Table.next_player({1,2,3},1) == 2
        assert Table.next_player({1,2,3},2) == 3
        assert Table.next_player({1,2,3},3) == 1
    end

    test "dapai" do
        assert Player.dapai("a1","d2") == false
        assert Player.dapai("b2","d2") == false
        assert Player.dapai("c3","d2") == true
    end

    test "chupai" do
        assert Player.chupai(["a10"],["d2"]) == ["a10"]
        assert Player.chupai(["a1","b2","c3"],["d2"]) == ["c3"] 
        assert Player.chupai(["a1","b2","c3"],["d4"]) == [] 

    end

    test "ddz.player test" do
        cards = Cards.get_cards()
        GenServer.start_link(Player,nil, name: :player1)
        GenServer.start_link(Player,nil, name: :player2)
        GenServer.start_link(Player,nil, name: :player3)
        GenServer.cast(:player1,{:fapai,Enum.slice(cards,0..1)})
        GenServer.cast(:player2,{:fapai,Enum.slice(cards,5..9)})
        GenServer.cast(:player3,{:fapai,Enum.slice(cards,10..14)})

        {:play,out_cards,1} = GenServer.call(:player1,:chupai)
        assert out_cards

        {:play,out_cards,0} = GenServer.call(:player1,:chupai)
        assert out_cards

        {:play,out_cards,0} = GenServer.call(:player1,:chupai)
        assert out_cards

    end

    test "Table GenServer" do
        cards = Cards.get_cards()
        GenServer.start_link(Player,nil, name: Player1)
        GenServer.start_link(Player,nil, name: Player2)
        GenServer.start_link(Player,nil, name: Player3)
        GenServer.cast(Player1,{:fapai,Enum.slice(cards,0..4)})
        GenServer.cast(Player2,{:fapai,Enum.slice(cards,5..9)})
        GenServer.cast(Player3,{:fapai,Enum.slice(cards,10..14)})
        Table.start_game({Player1,Player2,Player3}, 0, [] )
    end
end