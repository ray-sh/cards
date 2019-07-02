defmodule DouzhizhuWeb.PageController do
  use DouzhizhuWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
