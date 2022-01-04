defmodule DOMSegServer.Samples do
  @moduledoc """
  The Samples context.
  """

  import Ecto.Query, warn: false
  import DOMSegServer.Guards

  alias DOMSegServer.Repo
  alias DOMSegServer.Samples.Sample

  defguard has_sample_keys(sample) when
    is_map(sample) and
    is_uuid(sample.dataset_id) and
    is_uuid(sample.user_id) and
    is_binary(sample.url)

  def extract_keys(attrs) do
    %{}
    |> Map.put(:dataset_id, attrs[:dataset_id] || attrs["dataset_id"])
    |> Map.put(:user_id, attrs[:user_id] || attrs["user_id"])
    |> Map.put(:url, attrs[:url] || attrs["url"])
  end

  @doc """
  Returns the list of samples.

  ## Examples

      iex> list_samples()
      [%Sample{}, ...]

  """
  def list_samples do
    Repo.all(Sample)
  end

  @doc """
  Gets a single sample.
  """
  def get_sample!(sample) when has_sample_keys(sample) do
    Repo.get_by!(Sample, dataset_id: sample.dataset_id, user_id: sample.user_id, url: sample.url)
  end
  def get_sample!(_sample), do: nil

  def get_sample(sample) when has_sample_keys(sample) do
    Repo.get_by(Sample, dataset_id: sample.dataset_id, user_id: sample.user_id, url: sample.url)
  end
  def get_sample(_sample), do: nil

  @doc """
  Performs upsert on dataset/user/url composite key
  """
  def upsert_sample(keys, attrs) when has_sample_keys(keys) do
    case get_sample(keys) do
      nil  -> Sample.changeset(%Sample{}, attrs) |> Ecto.Changeset.apply_changes()
      sample -> sample
    end
    |> Sample.changeset(attrs)
    |> Repo.insert_or_update()
  end

  def upsert_sample(keys, attrs) do
    changeset = Sample.changeset(%Sample{}, attrs)
      |> Ecto.Changeset.add_error(:unique_key, "Invalid unique key provided", keys: keys)

    {:error, changeset}
  end

end
