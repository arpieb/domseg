defmodule DOMSegServer.Datasets do
  @moduledoc """
  The Datasets context.
  """

  import Ecto.Query, warn: false
  import DOMSegServer.Guards

  alias DOMSegServer.Repo
  alias DOMSegServer.Datasets.Dataset

  @doc """
  Returns the list of datasets.

  ## Examples

      iex> list_datasets()
      [%Dataset{}, ...]

  """
  def list_datasets do
    Repo.all(Dataset)
  end

  @doc """
  Gets a single dataset.

  Raises `Ecto.NoResultsError` if the Dataset does not exist.

  ## Examples

      iex> get_dataset!(123)
      %Dataset{}

      iex> get_dataset!(456)
      ** (Ecto.NoResultsError)

  """
  def get_dataset!(id) when is_uuid(id), do: Repo.get!(Dataset, id)
  def get_dataset!(_id), do: nil

  def get_dataset(id) when is_uuid(id), do: Repo.get(Dataset, id)
  def get_dataset(_id), do: nil

  @doc """
  Creates a dataset.

  ## Examples

      iex> create_dataset(%{field: value})
      {:ok, %Dataset{}}

      iex> create_dataset(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_dataset(attrs \\ %{}) do
    %Dataset{}
    |> Dataset.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a dataset.

  ## Examples

      iex> update_dataset(dataset, %{field: new_value})
      {:ok, %Dataset{}}

      iex> update_dataset(dataset, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_dataset(%Dataset{} = dataset, attrs) do
    dataset
    |> Dataset.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a dataset.

  ## Examples

      iex> delete_dataset(dataset)
      {:ok, %Dataset{}}

      iex> delete_dataset(dataset)
      {:error, %Ecto.Changeset{}}

  """
  def delete_dataset(%Dataset{} = dataset) do
    Repo.delete(dataset)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking dataset changes.

  ## Examples

      iex> change_dataset(dataset)
      %Ecto.Changeset{data: %Dataset{}}

  """
  def change_dataset(%Dataset{} = dataset, attrs \\ %{}) do
    Dataset.changeset(dataset, attrs)
  end

  @doc """
  Extract sample stats for the given dataset ID
  """
  def get_dataset_stats(id) do
    ds_query = from s in DOMSegServer.Samples.Sample, where: s.dataset_id == ^id

    num_samples = Repo.aggregate(ds_query, :count)

    query = from s in ds_query, distinct: true, select: s.url
    num_urls = Repo.aggregate(query, :count)

    query = from s in ds_query, distinct: true, select: s.user_id
    num_users = Repo.aggregate(query, :count)

    query = from s in ds_query, select: fragment("avg(length(?))", s.html)
    avg_html_len = Repo.one(query)

    %{
      num_urls: num_urls,
      num_users: num_users,
      num_samples: num_samples,
      avg_html_len: avg_html_len
    }
  end

end
