defmodule DOMSegServer.Repo.Migrations.CreateDatasets do
  use Ecto.Migration

  def change do
    create table(:datasets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :text
      add :is_active, :boolean, default: true, null: false
      add :segment_types, :map

      timestamps()
    end
  end
end
