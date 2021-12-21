defmodule Mix.Tasks.Dss.CreateUser do
  @moduledoc ~S"""
  Creates new normal user for DOMSeg Server
  dss.create_user <email> <password>
  """
  @shortdoc  "Creates new normal user for DOMSeg Server"

  use Mix.Task

  alias DOMSegServer.Accounts

  import DOMSegServerWeb.ErrorHelpers

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    [email | [password | _]] = args

    user_params = %{
      email: email,
      password: password
    }
    case Accounts.register_user(user_params) do
      {:ok, _user} ->
        Mix.shell().info("New user account created")
      {:error, %Ecto.Changeset{} = changeset} ->
        Mix.shell().info("Failed to create new user account:")
        lines = for k <- Keyword.keys(changeset.errors) do
          err = Keyword.get(changeset.errors, k)
          "- #{k} #{translate_error(err)}"
        end
        Mix.shell().info(Enum.join(lines, "\n"))
    end
  end
end
