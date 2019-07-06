defmodule DouzhizhuWeb.PageController do
  use DouzhizhuWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def tables(conn, %{"player" => name}) do
    render(conn, "tables.html", player: name)
  end

  def table(conn, %{"table" => _}) do
    render(conn, "table.html")
  end
end
