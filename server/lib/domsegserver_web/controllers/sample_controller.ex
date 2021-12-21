defmodule DOMSegServerWeb.SampleController do
  use DOMSegServerWeb, :controller

  alias DOMSegServer.Samples
  alias DOMSegServer.Samples.Sample
  alias DOMSegServerWeb.ErrorView

  action_fallback DOMSegServerWeb.FallbackController

  def create(conn, %{"sample" => sample_params} = data) do
    with {:ok, %Sample{} = sample} <- Samples.create_sample(sample_params) do
      conn
      |> put_status(:created)
      |> render("show.json", sample: sample)
    else
      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("422.json", data)
    end
  end

  def update(conn, %{"id" => id, "sample" => sample_params} = data) do
    with %Sample{} = sample <- Samples.get_sample(id) |> IO.inspect,
         {:ok, %Sample{} = sample} <- Samples.update_sample(sample, sample_params) |> IO.inspect do
      render(conn, "show.json", sample: sample)
    else
      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("422.json", data)
    end
  end
end
