defmodule MeowWeb.MeerkatLive.Show do
  use MeowWeb, :live_view

  alias Meow.Meerkats

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:meerkat, Meerkats.get_meerkat!(id))}
  end

  defp page_title(:show), do: "Show Meerkat"
  defp page_title(:edit), do: "Edit Meerkat"
end
