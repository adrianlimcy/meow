defmodule MeowWeb.MeerkatLive.Index do
  use MeowWeb, :live_view
  alias Meow.Meerkats
  alias MeowWeb.Forms.SortingForm
  alias MeowWeb.Forms.FilterForm

  # alias Meow.Meerkats.Meerkat

  # @impl true
  # def mount(_params, _session, socket) do
  #   {:ok, stream(socket, :meerkats, Meerkats.list_meerkats())}
  # end

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> parse_params(params)
      |> assign_meerkats()
    {:noreply, assign_meerkats(socket)}
  end

  @impl true

  def handle_info({:update, opts}, socket) do
    # path = Routes.live_path(socket, __MODULE__, opts)
    params = merge_and_sanitize_params(socket, opts)
    path = ~p"/meerkats?#{params}"
    {:noreply, push_patch(socket, to: path, replace: true)}
  end

  defp parse_params(socket, params) do
    with {:ok, sorting_opts} <- SortingForm.parse(params),
    {:ok, filter_opts} <- FilterForm.parse(params) do
      socket
      |> assign_filter(filter_opts)
      |> assign_sorting(sorting_opts)
    else
      _error ->
        socket
        |> assign_sorting()
        |> assign_filter()
    end
  end

  defp assign_sorting(socket, overrides \\ %{}) do
    opts = Map.merge(SortingForm.default_values, overrides)
    assign(socket, :sorting, opts)
  end

  defp assign_filter(socket, overrides \\ %{}) do
    assign(socket, :filter, FilterForm.default_values(overrides))
  end

  def assign_meerkats(socket) do
    # %{sorting: sorting} = socket.assigns
    params = merge_and_sanitize_params(socket)
    assign(socket, :meerkats, Meerkats.list_meerkats(params))
  end

  defp merge_and_sanitize_params(socket, overrides \\ %{}) do
    %{sorting: sorting, filter: filter} = socket.assigns

    %{}
    |> Map.merge(sorting)
    |> Map.merge(filter)
    |> Map.merge(overrides)
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end


  # @impl true
  # def handle_params(params, _url, socket) do
  #   {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  # end

  # defp apply_action(socket, :edit, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Edit Meerkat")
  #   |> assign(:meerkat, Meerkats.get_meerkat!(id))
  # end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New Meerkat")
  #   |> assign(:meerkat, %Meerkat{})
  # end

  # defp apply_action(socket, :index, _params) do
  #   socket
  #   |> assign(:page_title, "Listing Meerkats")
  #   |> assign(:meerkat, nil)
  # end

  # @impl true
  # def handle_info({MeowWeb.MeerkatLive.FormComponent, {:saved, meerkat}}, socket) do
  #   {:noreply, stream_insert(socket, :meerkats, meerkat)}
  # end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   meerkat = Meerkats.get_meerkat!(id)
  #   {:ok, _} = Meerkats.delete_meerkat(meerkat)

  #   {:noreply, stream_delete(socket, :meerkats, meerkat)}
  # end
end
