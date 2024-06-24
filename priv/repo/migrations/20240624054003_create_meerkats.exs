defmodule Meow.Repo.Migrations.CreateMeerkats do
  use Ecto.Migration

  def change do
    create table(:meerkats) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
