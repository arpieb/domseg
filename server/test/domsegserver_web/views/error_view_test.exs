defmodule DOMSegServerWeb.ErrorViewTest do
  use DOMSegServerWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(DOMSegServerWeb.ErrorView, "404.html", []) == "Not Found"
  end

  test "renders 500.html" do
    assert render_to_string(DOMSegServerWeb.ErrorView, "500.html", []) == "Internal Server Error"
  end

  test "renders 404.json" do
    assert render(DOMSegServerWeb.ErrorView, "404.json", []) ==
      %{errors: %{status: 404, detail: "Not Found"}}
  end

  test "renders 422.json" do
    assert render(DOMSegServerWeb.ErrorView, "422.json", []) ==
      %{errors: %{status: 422, detail: "Unprocessable Entity"}}
  end

  test "render 500.json" do
    assert render(DOMSegServerWeb.ErrorView, "500.json", []) ==
      %{errors: %{status: 500, detail: "Internal Server Error"}}
  end

end
