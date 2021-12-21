defmodule DOMSegServerWeb.ErrorView do
  use DOMSegServerWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  def render("404.json", _assigns) do
    get_json_error(404, "Not Found")
  end

  def render("422.json", _assigns) do
    get_json_error(422, "Unprocessable Entity")
  end

  def render("500.json", _assigns) do
    get_json_error(500, "Internal Server Error")
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end

  defp get_json_error(code, msg) do
    %{errors:
      %{
        status: code,
        detail: msg
      }
    }
  end

end
