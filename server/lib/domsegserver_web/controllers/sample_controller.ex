defmodule DOMSegServerWeb.SampleController do
  use DOMSegServerWeb, :controller

  alias DOMSegServer.Samples
  alias DOMSegServer.Samples.Sample
  alias DOMSegServerWeb.ErrorView

  action_fallback DOMSegServerWeb.FallbackController

  def upsert(conn, %{"sample" => sample_params} = data) do
    keys = Samples.extract_keys(sample_params)
    with {:ok, %Sample{} = sample} <- Samples.upsert_sample(keys, sample_params) do
      conn
      |> put_status(:ok)
      |> render("show.json", sample: sample)
    else
      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("422.json", data)
    end
  end
end
