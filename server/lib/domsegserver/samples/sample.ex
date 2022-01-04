defmodule DOMSegServer.Samples.Sample do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "samples" do
    field :user_id, :binary_id, primary_key: true
    field :dataset_id, :binary_id, primary_key: true
    field :url, :string, primary_key: true
    field :html, :string

    timestamps()
  end

  @doc false
  def changeset(sample, attrs \\ %{}) do
    fields = [
      :dataset_id,
      :user_id,
      :url,
      :html
    ]
    sample
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:dataset_id)
    |> unique_constraint([:dataset_id, :user_id, :url])
  end
end
