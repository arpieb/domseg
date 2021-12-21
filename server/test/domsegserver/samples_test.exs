defmodule DOMSegServer.SamplesTest do
  use DOMSegServer.DataCase

  alias DOMSegServer.Samples

  describe "samples" do
    alias DOMSegServer.Samples.Sample

    import DOMSegServer.SamplesFixtures

    @invalid_attrs %{html: nil, url: nil}

    test "list_samples/0 returns all samples" do
      sample = sample_fixture()
      assert Samples.list_samples() == [sample]
    end

    test "get_sample!/1 returns the sample with given id" do
      sample = sample_fixture()
      assert Samples.get_sample!(sample.id) == sample
    end

    test "create_sample/1 with valid data creates a sample" do
      valid_attrs = %{html: "some html", url: "some url"}

      assert {:ok, %Sample{} = sample} = Samples.create_sample(valid_attrs)
      assert sample.html == "some html"
      assert sample.url == "some url"
    end

    test "create_sample/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Samples.create_sample(@invalid_attrs)
    end

    test "update_sample/2 with valid data updates the sample" do
      sample = sample_fixture()
      update_attrs = %{html: "some updated html", url: "some updated url"}

      assert {:ok, %Sample{} = sample} = Samples.update_sample(sample, update_attrs)
      assert sample.html == "some updated html"
      assert sample.url == "some updated url"
    end

    test "update_sample/2 with invalid data returns error changeset" do
      sample = sample_fixture()
      assert {:error, %Ecto.Changeset{}} = Samples.update_sample(sample, @invalid_attrs)
      assert sample == Samples.get_sample!(sample.id)
    end

    test "delete_sample/1 deletes the sample" do
      sample = sample_fixture()
      assert {:ok, %Sample{}} = Samples.delete_sample(sample)
      assert_raise Ecto.NoResultsError, fn -> Samples.get_sample!(sample.id) end
    end

    test "change_sample/1 returns a sample changeset" do
      sample = sample_fixture()
      assert %Ecto.Changeset{} = Samples.change_sample(sample)
    end
  end
end
