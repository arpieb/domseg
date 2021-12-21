defmodule DOMSegServerWeb.LayoutView do
  use DOMSegServerWeb, :view

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def get_avatar(email) do
    Exgravatar.gravatar_url(email)
    |> img_tag(alt: email, title: email)
  end
end
