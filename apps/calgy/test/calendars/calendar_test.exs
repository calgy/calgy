defmodule Calgy.Calendars.CalendarTest do
  use Calgy.DataCase

  alias Calgy.Calendars.Calendar

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
    assert {:title, ["too_long"]} in errors_on(changeset(attrs))
  end

  test "changeset limits description to 2000 characters" do
    assert changeset(%{description: String.duplicate("x", 2000)}).valid?

    attrs = Map.put(@valid_attrs, :description, String.duplicate("x", 2001))
    assert {:description, ["too_long"]} in errors_on(changeset(attrs))
  end

  test "changeset generates a default :admin_id for new calendars" do
    changeset = Calendar.changeset(%Calendar{}, %{})
    assert Ecto.Changeset.apply_changes(changeset).admin_id
  end

  test "changeset does not overwrite :admin_id for existing calendars" do
    calendar =
      %Calendar{admin_id: "orig-uuid"}
      |> Ecto.put_meta(state: :loaded)
      |> Calendar.changeset(%{})
      |> Ecto.Changeset.apply_changes

    assert calendar.admin_id == "orig-uuid"
  end

  test "changeset does not generate new :admin_id if existing is nil" do
    calendar =
      %Calendar{}
      |> Ecto.put_meta(state: :loaded)
      |> Calendar.changeset(%{})
      |> Ecto.Changeset.apply_changes

    refute calendar.admin_id
  end

end
