defmodule DOMSegServerWeb.SampleController do
  use DOMSegServerWeb, :controller

  require Logger

  alias DOMSegServer.Samples
  alias DOMSegServer.Samples.Sample
  alias DOMSegServerWeb.ErrorView

  action_fallback DOMSegServerWeb.FallbackController

  def upsert(conn, %{"sample" => %{"html" => html} = sample_params} = data) when is_nil(html) do
    Logger.debug("upsert-patching")
    keys = Samples.extract_keys(sample_params)

    with(
      %Sample{} = sample <- Samples.get_sample(keys),
      {:ok, document} <- Floki.parse_document(sample.html),
      patched_doc <- patch_document(document, sample_params),
      patched_html <- Floki.raw_html(patched_doc),
      {:ok, %Sample{} = sample} <- Samples.upsert_sample(keys, %{sample_params | "html" => patched_html})
    ) do
        conn
        |> put_status(:ok)
        |> render("show.json", sample: sample)
    else
      _err ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("422.json", data)
    end
  end

  def upsert(conn, %{"sample" => sample_params} = data) do
    Logger.debug("upsert-creating")
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

  defp patch_document(document, sample_params) do
    domseg_class = sample_params["domseg_class"]
    selector = sample_params["selector"]

    if (Floki.find(document, selector) |> Enum.count()) == 0 do
      Logger.error("Unable to patch; no matches found for #{Jason.encode!(sample_params)}")
      document
    else
      Floki.attr(document, selector, "data-domseg-class", fn (_) -> domseg_class end)
    end
  end

end
