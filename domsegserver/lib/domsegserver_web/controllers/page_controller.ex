defmodule DOMSegServerWeb.PageController do
  use DOMSegServerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
