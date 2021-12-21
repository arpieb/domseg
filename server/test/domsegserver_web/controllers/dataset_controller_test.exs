defmodule DOMSegServerWeb.DatasetControllerTest do
  use DOMSegServerWeb.ConnCase

  import DOMSegServer.DatasetsFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all datasets", %{conn: conn} do
      conn = get(conn, Routes.dataset_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

end
