defmodule DouzhizhuWeb.PageView do
  use DouzhizhuWeb, :view

  def player_name(conn) do
    conn.assigns[:player]
  end

  def players(table) do
    {:ok, num} = GenServer.call(table, :players)
    num
  end
end
