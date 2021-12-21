defmodule DOMSegServer.Datasets.SegmentType do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :string
    field :color, :string

    field :temp_id, :string, virtual: true, default: nil
    field :delete, :boolean, virtual: true, default: false
  end

  def changeset(segtype, attrs \\ %{}) do
    fields = [:name, :color, :delete]
    segtype
    |> cast(attrs, fields)
    |> validate_required(fields -- [:delete])
    |> maybe_mark_for_deletion()

  end

  defp maybe_mark_for_deletion(%{data: %{id: nil}} = changeset), do: changeset
  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end

end
