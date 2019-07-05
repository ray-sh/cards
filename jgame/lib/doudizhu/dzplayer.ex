defmodule Ddz.Player do
  require Logger
  use GenServer
  import Ddz.Helper

  '''
  1.The player query the latest card on the table then deceived how to play the cards
  2.The player should check if the cards out are allowed
  '''

  def chupai(cards, previous_cards) do
    Enum.filter(cards, fn x -> bigger(x, previous_cards |> List.first()) end)
    |> Enum.take_random(1)
  end

  def join_table(tables) do
    Enum.each(tables, fn {k,v} ->
      Logger.info "There are #{3 - length(v)} seats left on table #{k}"
    end)
    Logger.info("Please input which table you want to join")
    IO.read(:stdio, :line)
    |> String.trim()
  end

  def start_link(name) do
    GenServer.start(__MODULE__,nil, name: name)
  end

  @impl true
  def init(_) do
    {:ok, []}
  end

  @impl true
  def handle_cast({:fapai, new_cards}, _) do
    Logger.debug("fapai #{new_cards}")
    {:noreply, new_cards}
  end

  @impl true
  def handle_call({:chupai, previous_cards}, _from, cards) do
    Logger.debug("Player current cards #{cards}")
    out_cards = chupai(cards, previous_cards)
    Logger.debug("Player chuapai #{out_cards}")
    left_cards = cards -- out_cards
    {:reply, {:play, out_cards, length(left_cards)}, cards -- out_cards}
  end

  @impl true
  def handle_call({:join, tables}, _from, cards) do
    table = join_table(tables)
    case GenServer.call(Server, {:join, table}) do
      :ok ->
        Logger.info "join table #{table} success"
        {:reply, :ok, cards}
      :table_full ->
        Logger.info "Table #{table} is full"
        {:reply,:table_full, cards}
    end
  end
end
