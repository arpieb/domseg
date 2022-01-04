defmodule DOMSegServer.Repo.Migrations.CreateSamples do
  use Ecto.Migration

  def change do
    create table(:samples, primary_key: false) do
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false, primary_key: true
      add :dataset_id, references(:datasets, on_delete: :nothing, type: :binary_id), null: false, primary_key: true
      add :url, :text, null: false, primary_key: true
      add :html, :text, null: false

      timestamps()
    end

    create unique_index(:samples, [:dataset_id, :user_id, :url])
    
    create index(:samples, [:user_id])
    create index(:samples, [:dataset_id])
    create index(:samples, [:url])
  end
end
