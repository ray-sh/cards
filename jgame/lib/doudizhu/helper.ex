defmodule Ddz.Helper do
  @moduledoc """
  This module is a helper function which conain some logic when play douzhizhu card games
  """
  require Logger

  @doc """
  Return the player based on players and the index
  ##Example
      iex(2)> next_player {1,2}, 1
      2
  """
  @spec next_player(tuple, non_neg_integer) :: any
  def next_player(players, active_player) do
    elem(players, rem(active_player, tuple_size(players)))
  end

  @doc """
  Compare single card, return true if card1 > card2
  """
  @spec bigger(binary, nil) :: boolean
  def bigger(card1, nil) when is_binary(card1) do
    true
  end

  @spec bigger(binary,binary) :: boolean
  def bigger(card1, card2) when is_binary(card1) and is_binary(card2) do
    Logger.debug("card1 #{card1}, card2 #{card2}")
    num_of_card(card1) > num_of_card(card2)
  end

  @doc """
  Compare double cards
  ##Example
      iex(2)> Ddz.Helper.bigger ["a1","a1"] , ["b2","b2"]
      false
  """
  @spec bigger(list,list) :: boolean
  def bigger([card1, card1], [card2, card2]) do
    Logger.debug("card1 #{card1}, card2 #{card2}")
    num_of_card(card1) > num_of_card(card2)
  end


  def start_game(players, active_player, cards \\ [[]]) do
    player = next_player(players, active_player)
    {:play, new_cards, num_cards_left} = GenServer.call(player, {:chupai, List.first(cards)})
    cards = [new_cards | cards]

    Logger.info("#{player} chupai #{new_cards} with left cards num #{num_cards_left}")
    Logger.info("cards on table #{cards}")

    case num_cards_left do
      0 ->
        Logger.info("Game over, winner is #{player}")

      _ ->
        start_game(players, active_player + 1, cards)
    end
  end

  @spec num_of_card(binary) :: integer
  defp num_of_card(card) do
    card
    |> String.slice(1..10)
    |> String.to_integer()
  end
end
