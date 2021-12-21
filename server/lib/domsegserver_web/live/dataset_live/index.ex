defmodule DOMSegServerWeb.DatasetLive.Index do
  use DOMSegServerWeb, :live_view

  alias DOMSegServer.Datasets
  alias DOMSegServer.Datasets.Dataset

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      assign(
        socket,
        datasets: list_datasets(),
        user_token: session["user_token"]
      )
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    dataset = Datasets.get_dataset!(id)
    socket
    |> assign(:page_title, "Edit Dataset")
    |> assign(:dataset, dataset)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Dataset")
    |> assign(:dataset, %Dataset{segment_types: []})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Datasets")
    |> assign(:dataset, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    dataset = Datasets.get_dataset!(id)
    {:ok, _} = Datasets.delete_dataset(dataset)

    {:noreply, assign(socket, :datasets, list_datasets())}
  end

  defp list_datasets do
    Datasets.list_datasets()
  end

  def get_current_user(token) do
    DOMSegServer.Accounts.get_user_by_session_token(token)
  end
end
