defmodule DOMSegServerWeb.DatasetController do
  use DOMSegServerWeb, :controller

  alias DOMSegServer.Datasets
  alias DOMSegServer.Datasets.Dataset
  alias DOMSegServerWeb.ErrorView

  action_fallback DOMSegServerWeb.FallbackController

  def index(conn, _params) do
    datasets = Datasets.list_datasets()
    render(conn, "index.json", datasets: datasets)
  end

  def show(conn, %{"id" => id}) do
    with dataset = %Dataset{} <- Datasets.get_dataset(id) do
      render(conn, "show.json", dataset: dataset)
    else
      _ ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorView)
        |> render("404.json", error: "Not found")
    end
  end
end
