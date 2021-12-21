defmodule DOMSegServerWeb.PageControllerTest do
  use DOMSegServerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to DOMSeg!"
  end
end
