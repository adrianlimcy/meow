defmodule MeowWeb.MeerkatLive.FormComponent do
  use MeowWeb, :live_component

  alias Meow.Meerkats

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage meerkat records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="meerkat-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Meerkat</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{meerkat: meerkat} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Meerkats.change_meerkat(meerkat))
     end)}
  end

  @impl true
  def handle_event("validate", %{"meerkat" => meerkat_params}, socket) do
    changeset = Meerkats.change_meerkat(socket.assigns.meerkat, meerkat_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"meerkat" => meerkat_params}, socket) do
    save_meerkat(socket, socket.assigns.action, meerkat_params)
  end

  defp save_meerkat(socket, :edit, meerkat_params) do
    case Meerkats.update_meerkat(socket.assigns.meerkat, meerkat_params) do
      {:ok, meerkat} ->
        notify_parent({:saved, meerkat})

        {:noreply,
         socket
         |> put_flash(:info, "Meerkat updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_meerkat(socket, :new, meerkat_params) do
    case Meerkats.create_meerkat(meerkat_params) do
      {:ok, meerkat} ->
        notify_parent({:saved, meerkat})

        {:noreply,
         socket
         |> put_flash(:info, "Meerkat created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
