defmodule Calgy.Calendars.EventTest do
  use Calgy.DataCase

  alias Calgy.Calendars.Event

  @valid_attrs %{
    title: "Mission to Mars",
    start_at: "2022-08-17T14:47:00Z",
  }

  defp changeset(struct \\ %Event{}, attrs) do
    attrs = Map.merge(@valid_attrs, attrs)
    Event.changeset(struct, attrs)
  end

  describe "changeset/2" do
    test "is valid when attributes are valid" do
      changeset = Event.changeset(%Event{}, @valid_attrs)
      assert changeset.valid?
    end

    test "is invalid when attributes are invalid" do
      invalid_attrs = %{title: String.duplicate("x", 101)}
      changeset = Event.changeset(%Event{}, invalid_attrs)
      refute changeset.valid?
    end

    test "requires title to be present" do
      attrs = Map.put(@valid_attrs, :title, nil)
      assert {:title, ["required"]} in errors_on(changeset(attrs))
    end

    test "requires start_at to be present" do
      attrs = Map.put(@valid_attrs, :start_at, nil)
      assert {:start_at, ["required"]} in errors_on(changeset(attrs))
    end

    test "limits title to 100 characters" do
      attrs = Map.put(@valid_attrs, :title, String.duplicate("x", 101))
      assert {:title, ["too_long"]} in errors_on(changeset(attrs))
    end

    test "limits description to 5000 characters" do
      attrs = Map.put(@valid_attrs, :description, String.duplicate("x", 5001))
      assert {:description, ["too_long"]} in errors_on(changeset(attrs))
    end
  end

end
