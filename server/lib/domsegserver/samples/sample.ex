defmodule DOMSegServer.Samples.Sample do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "samples" do
    field :user_id, :binary_id
    field :dataset_id, :binary_id
    field :url, :string
    field :html, :string

    timestamps()
  end

  @doc false
  def changeset(sample, attrs) do
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
  end
end
