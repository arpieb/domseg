defmodule DOMSegServer.Repo.Migrations.CreateSamples do
  use Ecto.Migration

  def change do
    create table(:samples, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false
      add :dataset_id, references(:datasets, on_delete: :nothing, type: :binary_id), null: false
      add :url, :text, null: false
      add :html, :text, null: false

      timestamps()
    end

    create index(:samples, [:user_id])
    create index(:samples, [:dataset_id])
    create index(:samples, [:url])
  end
end
