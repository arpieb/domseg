defmodule DOMSegServer.DatasetsTest do
  use DOMSegServer.DataCase

  alias DOMSegServer.Datasets

  describe "datasets" do
    alias DOMSegServer.Datasets.Dataset

    import DOMSegServer.DatasetsFixtures

    @invalid_attrs %{config: nil, description: nil, is_active: nil, name: nil}

    test "list_datasets/0 returns all datasets" do
      dataset = dataset_fixture()
      assert Datasets.list_datasets() == [dataset]
    end

    test "get_dataset!/1 returns the dataset with given id" do
      dataset = dataset_fixture()
      assert Datasets.get_dataset!(dataset.id) == dataset
    end

    test "create_dataset/1 with valid data creates a dataset" do
      valid_attrs = %{description: "some description", is_active: true, name: "some name"}

      assert {:ok, %Dataset{} = dataset} = Datasets.create_dataset(valid_attrs)
      assert dataset.segment_types == []
      assert dataset.description == "some description"
      assert dataset.is_active == true
      assert dataset.name == "some name"
    end

    test "create_dataset/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Datasets.create_dataset(@invalid_attrs)
    end

    test "update_dataset/2 with valid data updates the dataset" do
      dataset = dataset_fixture()
      update_attrs = %{description: "some updated description", is_active: false, name: "some updated name"}

      assert {:ok, %Dataset{} = dataset} = Datasets.update_dataset(dataset, update_attrs)
      assert dataset.segment_types == []
      assert dataset.description == "some updated description"
      assert dataset.is_active == false
      assert dataset.name == "some updated name"
    end

    test "update_dataset/2 with invalid data returns error changeset" do
      dataset = dataset_fixture()
      assert {:error, %Ecto.Changeset{}} = Datasets.update_dataset(dataset, @invalid_attrs)
      assert dataset == Datasets.get_dataset!(dataset.id)
    end

    test "delete_dataset/1 deletes the dataset" do
      dataset = dataset_fixture()
      assert {:ok, %Dataset{}} = Datasets.delete_dataset(dataset)
      assert_raise Ecto.NoResultsError, fn -> Datasets.get_dataset!(dataset.id) end
    end

    test "change_dataset/1 returns a dataset changeset" do
      dataset = dataset_fixture()
      assert %Ecto.Changeset{} = Datasets.change_dataset(dataset)
    end
  end
end
