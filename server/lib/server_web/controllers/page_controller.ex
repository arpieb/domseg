defmodule HEAServerWeb.PageController do
  use HEAServerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
