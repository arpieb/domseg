defmodule DOMSegServerWeb.SampleController do
  use DOMSegServerWeb, :controller

  alias DOMSegServer.Samples
  alias DOMSegServer.Samples.Sample
  alias DOMSegServerWeb.ErrorView

  action_fallback DOMSegServerWeb.FallbackController

  def upsert(conn, %{"sample" => %{"html" => html} = sample_params} = data) when is_nil(html) do
    IO.puts("upsert-patching")
    keys = Samples.extract_keys(sample_params) |> IO.inspect(label: "keys")
    domseg_class = sample_params["domseg_class"] |> IO.inspect(label: "domseg_class")
    selector = sample_params["selector"] |> IO.inspect(label: "selector")

    with(
      %Sample{} = sample <- Samples.get_sample(keys),
      {:ok, document} <- Floki.parse_document(sample.html),
      patched_doc <- patch_document(document, selector, domseg_class),
      patched_html <- Floki.raw_html(patched_doc),
      {:ok, %Sample{} = sample} <- Samples.upsert_sample(keys, %{sample_params | "html" => patched_html})
    ) do
        conn
        |> put_status(:ok)
        |> render("show.json", sample: sample)
    else
      err ->
        IO.inspect(err, label: "err")
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("422.json", data)
    end
  end

  def upsert(conn, %{"sample" => sample_params} = data) do
    IO.puts("upsert-creating")
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

  defp patch_document(document, selector, domseg_class) do
    # Floki.find(document, selector) |> IO.inspect(label: "patch_document matches")
    Floki.attr(document, selector, "data-domseg-class", fn (_) -> domseg_class end)
  end
end
