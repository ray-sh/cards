defmodule DouzhizhuWeb.PageController do
  use DouzhizhuWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def tables(conn, %{"player" => name}) do
    conn
    |> assign(:player,name)
    |>IO.inspect()
    |> render("tables.html")
  end

  def table(conn, %{"table" => table}) do
    IO.inspect(conn)
    GenServer.call(String.to_existing_atom(table), {:join, conn.assigns[:player]})
    render(conn, "table.html")
  end
end
