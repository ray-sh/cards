defmodule DouzhizhuWeb.PageView do
  use DouzhizhuWeb, :view

  def player_name(conn) do
    conn.assigns[:player]
  end

  def players(table) do
    GenServer.call(table, :players)
    |> Enum.join(",")
     |> IO.inspect()
  end

  def all_tables do
    Supervisor.which_children(TableSup) |> Enum.map(&elem(&1,0)) |>IO.inspect()
  end
end
