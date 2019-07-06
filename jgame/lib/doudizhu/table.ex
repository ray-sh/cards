defmodule Ddz.Table do
  @moduledoc """
  Table which where user play cards
  """
  use GenServer
  @max_sits 3

  def start_link(_) do
    GenServer.start(__MODULE__,nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok,[]}
  end
  
  @impl true
  def handle_call({:join, player}, _from, players) when length(players) < @max_sits do
    {:reply,{:ok, length(players)}, [player | players]}
  end

  @impl true
  def handle_call({:join, player}, _from, players) when length(players) == @max_sits do
    {:reply,{:table_full, @max_sits}, players}
  end

  @impl true
  def handle_call(:player_num, _from, players) do
    {:reply, {:ok, length(players)}, players}
  end
  
end
