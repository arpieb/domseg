defmodule DOMSegServerWeb.SampleView do
  use DOMSegServerWeb, :view
  alias DOMSegServerWeb.SampleView

  def render("show.json", %{sample: sample}) do
    %{data: render_one(sample, SampleView, "sample.json")}
  end

  def render("sample.json", %{sample: sample}) do
    %{
      id: sample.id,
      dataset_id: sample.dataset_id,
      user_id: sample.user_id,
      url: sample.url,
      html: sample.html
    }
  end
end
