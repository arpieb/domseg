defmodule DOMSegServer.Datasets.Dataset do
  use Ecto.Schema
  import Ecto.Changeset
  alias DOMSegServer.Datasets.SegmentType

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "datasets" do
    field :name, :string
    field :description, :string
    field :is_active, :boolean, default: false
    embeds_many :segment_types, SegmentType

    timestamps()
  end

  @doc false
  def changeset(dataset, attrs \\ %{}) do
    dataset
    |> cast(attrs, [:name, :description, :is_active])
    |> validate_required([:name, :description, :is_active])
    |> cast_embed(:segment_types, with: &SegmentType.changeset/2)
  end

end
