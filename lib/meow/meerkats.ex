defmodule Meow.Meerkats do
  import Ecto.Query, warn: false
  alias Meow.Repo
  alias Meow.Meerkats.Meerkat

  def list_meerkats(opts) do
    from(m in Meerkat)
    |> sort(opts)
    |> Repo.all()
  end

  defp sort(query, %{sort_by: sort_by, sort_dir: sort_dir})
  when sort_by in [:id, :name] and
  sort_dir in [:asc, :desc] do
      order_by(query, {^sort_dir, ^sort_by})
  end

  defp sort(query, _opts), do: query


  def get_meerkat!(id), do: Repo.get!(Meerkat, id)


  def create_meerkat(attrs \\ %{}) do
    %Meerkat{}
    |> Meerkat.changeset(attrs)
    |> Repo.insert()
  end


  def update_meerkat(%Meerkat{} = meerkat, attrs) do
    meerkat
    |> Meerkat.changeset(attrs)
    |> Repo.update()
  end


  def delete_meerkat(%Meerkat{} = meerkat) do
    Repo.delete(meerkat)
  end


  def change_meerkat(%Meerkat{} = meerkat, attrs \\ %{}) do
    Meerkat.changeset(meerkat, attrs)
  end
end
