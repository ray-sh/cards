defmodule TableTest do
  use ExUnit.Case
  alias Ddz.Table
  alias Ddz.Player
  import Ddz.Helper
  require Logger
  test "Next player" do
    assert next_player({1, 2, 3}, 0) == 1
    assert next_player({1, 2, 3}, 1) == 2
    assert next_player({1, 2, 3}, 2) == 3
    assert next_player({1, 2, 3}, 3) == 1
  end

  test "bigger" do
    assert bigger("a1", "d2") == false
    assert bigger("b2", "d2") == false
    assert bigger("c3", "d2") == true
    assert bigger("c12", "d10") == true
  end

  test "chupai" do
    assert Player.chupai(["a10"], ["d2"]) == ["a10"]
    assert Player.chupai(["a1", "b2", "c3"], ["d2"]) == ["c3"]
    assert Player.chupai(["a1", "b2", "c3"], ["d4"]) == []
    assert Player.chupai(["a1", "b2", "c3"], [])
  end

  test "ddz.player test" do
    cards = Cards.get_cards()
    GenServer.start_link(Player, nil, name: :player1)
    GenServer.start_link(Player, nil, name: :player2)
    GenServer.start_link(Player, nil, name: :player3)
    GenServer.cast(:player1, {:fapai, ["a1", "b11", "c9"]})
    GenServer.cast(:player2, {:fapai, Enum.slice(cards, 5..9)})
    GenServer.cast(:player3, {:fapai, Enum.slice(cards, 10..14)})

    {:play, out_cards, 2} = GenServer.call(:player1, {:chupai, ["a1"]})
    assert out_cards

    {:play, out_cards, 2} = GenServer.call(:player1, {:chupai, ["a12"]})
    assert out_cards == []
    # {:play,out_cards,0} = GenServer.call(:player1,:chupai)
    # assert out_cards

    # {:play,out_cards,0} = GenServer.call(:player1,:chupai)
    # assert out_cards
  end

  test "Table GenServer" do
    cards = Cards.get_cards()
    GenServer.start_link(Player, nil, name: Player1)
    GenServer.start_link(Player, nil, name: Player2)
    GenServer.start_link(Player, nil, name: Player3)
    GenServer.cast(Player1, {:fapai, Enum.slice(cards, 0..4)})
    GenServer.cast(Player2, {:fapai, Enum.slice(cards, 5..9)})
    GenServer.cast(Player3, {:fapai, Enum.slice(cards, 10..14)})
    start_game({Player1, Player2, Player3}, 0, [[]])
  end

  test "User join in table" do
    GenServer.start_link(Ddz.Server,nil, name: Server)
    {:ok, tables} = GenServer.call( Server, {:login, Player1})
    :ok = GenServer.call(Player1, {:join, tables}, :infinity)
    tables = GenServer.call(Server, :tables)
    IO.inspect(tables)
  end
end
