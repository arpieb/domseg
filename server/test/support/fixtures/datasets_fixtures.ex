defmodule DOMSegServer.DatasetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DOMSegServer.Datasets` context.
  """

  @doc """
  Generate a dataset.
  """
  def dataset_fixture(attrs \\ %{}) do
    {:ok, dataset} =
      attrs
      |> Enum.into(%{
        config: %{},
        description: "some description",
        is_active: true,
        name: "some name"
      })
      |> DOMSegServer.Datasets.create_dataset()

    dataset
  end
end
