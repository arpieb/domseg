defmodule DOMSegServerWeb.ModalComponent do
  use DOMSegServerWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div id={@id} class="modal fade phx-modal"
    phx-hook="BsModal"
    phx-target={@myself}
    phx-page-loading>

    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title"><%= @opts[:title] %></h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <%= live_component @socket, @component, @opts %>
        </div>
      </div>
    </div>
  </div>
  """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
