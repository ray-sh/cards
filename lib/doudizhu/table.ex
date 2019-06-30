defmodule Ddz.Table do
  @moduledoc """
  Table which where user play cards
  """
  use GenServer
  @max_sits 3
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
  
end
