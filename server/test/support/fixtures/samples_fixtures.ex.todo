defmodule DOMSegServer.SamplesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DOMSegServer.Samples` context.
  """

  @doc """
  Generate a sample.
  """
  def sample_fixture(attrs \\ %{}) do
    {:ok, sample} =
      attrs
      |> Enum.into(%{
        html: "some html",
        url: "some url"
      })
      |> DOMSegServer.Samples.create_sample()

    sample
  end
end
