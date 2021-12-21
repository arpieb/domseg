defmodule DOMSegServerWeb.DatasetView do
  use DOMSegServerWeb, :view
  alias DOMSegServerWeb.DatasetView

  def render("index.json", %{datasets: datasets}) do
    %{data: render_many(datasets, DatasetView, "dataset.json")}
  end

  def render("show.json", %{dataset: dataset}) do
    %{data: render_one(dataset, DatasetView, "dataset.json")}
  end

  def render("dataset.json", %{dataset: dataset}) do
    segment_types = for st <- dataset.segment_types, do: %{name: st.name, color: st.color}

    %{
      id: dataset.id,
      name: dataset.name,
      is_active: dataset.is_active,
      segment_types: segment_types
    }
  end
end
