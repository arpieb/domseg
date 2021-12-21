defmodule DOMSegServerWeb.DatasetLive.FormComponent do
  use DOMSegServerWeb, :live_component

  alias DOMSegServer.Datasets
  alias DOMSegServer.Datasets.SegmentType

  @impl true
  def update(%{dataset: dataset} = assigns, socket) do
    changeset = Datasets.change_dataset(dataset)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"dataset" => dataset_params}, socket) do
    changeset =
      socket.assigns.dataset
      |> Datasets.change_dataset(dataset_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"dataset" => dataset_params}, socket) do
    save_dataset(socket, socket.assigns.action, dataset_params)
  end

  @impl true
  def handle_event("add_segment_type", _value, socket) do
    existing_segment_types = Map.get(
      socket.assigns.changeset.changes,
      :segment_types,
      socket.assigns.dataset.segment_types
      )

    segment_types =
      existing_segment_types
      |> Enum.concat([
          SegmentType.changeset(%SegmentType{temp_id: get_temp_id()})
        ])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_embed(:segment_types, segment_types)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove_new_segment_type", %{"remove" => remove_id}, socket) do
    segment_types =
      socket.assigns.changeset.changes.segment_types
      |> Enum.reject(fn %{data: segment_type} -> segment_type.temp_id == remove_id end)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_embed(:segment_types, segment_types)

    {:noreply, assign(socket, changeset: changeset)}
  end

  defp save_dataset(socket, :edit, dataset_params) do
    case Datasets.update_dataset(socket.assigns.dataset, dataset_params) do
      {:ok, _dataset} ->
        {:noreply,
         socket
         |> put_flash(:info, "Dataset updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_dataset(socket, :new, dataset_params) do
    case Datasets.create_dataset(dataset_params) do
      {:ok, _dataset} ->
        {:noreply,
         socket
         |> put_flash(:info, "Dataset created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp get_temp_id, do: Ecto.UUID.generate()
end
