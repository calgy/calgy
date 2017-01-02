defmodule CalgyApi.CalendarTest do
  use CalgyApi.ModelCase

  alias CalgyApi.Calendar

  @valid_attrs %{title: "my calendar", description: "horse eats radish"}
  @invalid_attrs %{title: String.duplicate("x", 101)}

  defp changeset(attrs) do
    changeset(%Calendar{}, attrs)
  end

  defp changeset(struct, attrs) do
    attrs = Map.merge(@valid_attrs, attrs)
    Calendar.changeset(struct, attrs)
  end

  test "changeset with valid attributes" do
    changeset = Calendar.changeset(%Calendar{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invavlid attributes" do
    changeset = Calendar.changeset(%Calendar{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset limits title to 100 characters" do
    assert changeset(%{title: String.duplicate("x", 100)}).valid?

    attrs = Map.put(@valid_attrs, :title, String.duplicate("x", 101))
    assert {:title, "too_long"} in errors_on(%Calendar{}, attrs)
  end

  test "changeset limits description to 2000 characters" do
    assert changeset(%{description: String.duplicate("x", 2000)}).valid?

    attrs = Map.put(@valid_attrs, :description, String.duplicate("x", 2001))
    assert {:description, "too_long"} in errors_on(%Calendar{}, attrs)
  end

end
