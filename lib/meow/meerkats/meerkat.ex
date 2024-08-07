defmodule Meow.Meerkats.Meerkat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "meerkats" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(meerkat, attrs) do
    meerkat
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
