defmodule DOMSegServerWeb.DatasetLive.Show do
  use DOMSegServerWeb, :live_view

  alias DOMSegServer.Datasets

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      assign(
        socket,
        user_token: session["user_token"]
      )
    }
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:dataset, Datasets.get_dataset!(id))
     |> assign(:stats, Datasets.get_dataset_stats(id))
    }
  end

  defp page_title(:show), do: "Show Dataset"
  defp page_title(:edit), do: "Edit Dataset"

  def get_current_user(nil), do: nil
  def get_current_user(token) do
    DOMSegServer.Accounts.get_user_by_session_token(token)
  end

  def format_int(val), do: Number.Delimit.number_to_delimited(val, precision: 0)
end
