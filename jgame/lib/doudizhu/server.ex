defmodule Ddz.Server do
  @moduledoc """
  Server has the following responsibility
  login(name) :: player
  table_info(name) :: 1..3
  start_game()    
  """
  require Logger
  use GenServer
  @max_players 3
  

  @impl true
  def init(_) do
    {:ok, %{"t1" => [], "t2" =>[], "t3" => []}}
  end

  @impl true
  def handle_call({:login, player}, _from, tables) do
    GenServer.start_link(Ddz.Player, nil, name: player)
    {:reply,{:ok,tables},tables}
  end

  @impl true
  def handle_call({:join, table}, player, tables) do
    cond do
      length(tables[table]) < @max_players ->
        {:reply, :ok, %{tables | table => [player | tables[table]]}}
      true ->
        {:reply, :table_full, tables}
    end
  end
  
  @impl true
  def handle_call(:tables, _from, tables) do
    {:reply, tables, tables}
  end
end
