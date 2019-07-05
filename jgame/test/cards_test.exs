defmodule CardsTest do
  use ExUnit.Case

  test "one round test" do
    cards = Cards.get_cards()
    player1_cards = Enum.slice(cards, 0..25) |> :queue.from_list()
    player2_cards = Enum.slice(cards, 26..51) |> :queue.from_list()
    {:ok, player1} = GenServer.start_link(Player, player1_cards, name: :player1)
    assert player1
    {:ok, player2} = GenServer.start_link(Player, player2_cards, name: :player2)
    assert player2
    Game.oneplay(:player1, :player2, 1)
    Game.oneplay(:player1, :player2, 10)
    Game.oneplay(:player1, :player2, 2)
  end

  test "full play" do
    cards = Cards.get_cards()
    player1_cards = Enum.slice(cards, 0..25) |> :queue.from_list()
    player2_cards = Enum.slice(cards, 26..51) |> :queue.from_list()
    {:ok, _} = GenServer.start_link(Player, player1_cards, name: :player1)
    {:ok, _} = GenServer.start_link(Player, player2_cards, name: :player2)
    Game.fullplay(:player1, :player2)
  end
end
