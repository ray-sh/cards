defmodule Table do
  @moduledoc """
  The table is used to track all cards put by player
  """
  use GenServer
  require Logger
  def start_link(name) do
    GenServer.start_link(__MODULE__, nil, name: name)
  end

  @doc """
  The table's state is like this, so that user could get the current players
  and get track each player's play record
  [player: [p1, p2, p3], plays: [{p1,[c1,c2]}, {p2,[a1,a2]}]]
  """
  @impl true
  def init(_) do
    {:ok, [players: [], plays: []]}
  end

  @impl true
  def handle_call(:players, _from, table) do
    {:reply, table[:players] ,table}
  end

  @impl true
  def handle_call({:join,player}, _from, [players: players, plays: plays]) do
    Logger.info("User #{player} want to join")
    case length(players) do
      3 ->
        {:reply,:table_full,[players: players, plays: plays]}
      _ ->
        {:reply,:ok,[players: [player | players], plays: plays]}
    end
  end

  @impl true
  def handle_call({:chupai, player, cards}, _from, [players: players, plays: plays]) do
    {:reply, :ok, [players: players, plays: [{player, cards} | plays]]}
  end
end
