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
  def next_player(players, active_player) do
    elem(players, rem(active_player, tuple_size(players)))
  end

  @doc """
  Compare single card, return true if card1 > card2
  """
  def bigger(card1, nil) when is_binary(card1) do
    true
  end

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
  def bigger([card1, card1], [card2, card2]) do
    Logger.debug("card1 #{card1}, card2 #{card2}")
    num_of_card(card1) > num_of_card(card2)
  end

  defp num_of_card(card) do
    card
    |> String.slice(1..10)
    |> String.to_integer()
  end
end
