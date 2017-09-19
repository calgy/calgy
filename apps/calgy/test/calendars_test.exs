defmodule Calgy.CalendarsTest do
  use Calgy.DataCase

  alias Calgy.Calendars
  alias Calgy.Calendars.Calendar
  alias Calgy.Calendars.Event

  def calendar_fixture(attrs \\ %{}) do
    {:ok, calendar} =
      attrs
      |> Enum.into(%{})
      |> Calendars.create_calendar()

    calendar
  end


  ### Public Calendars Interface

  describe "create_calendar/0" do
    test "creates a new pending calendar" do
      assert {:ok, %Calendar{} = calendar} = Calendars.create_calendar()
      assert calendar.state == "pending"
    end
  end

  describe "create_calendar/1" do
    test "creates a new pending calendar when attrs are valid" do
      assert {:ok, %Calendar{} = calendar} =
        Calendars.create_calendar(%{title: "my calendar"})
      assert calendar.title == "my calendar"
    end

    test "returns an :invalid error when attrs are invalid" do
      assert {:error, :invalid, [title: "too_long"]} =
        Calendars.create_calendar(%{title: String.duplicate("x", 101)})
    end
  end

  describe "delete_calendar/1" do
    test "changes the state of the calendar to deleted" do
      existing = calendar_fixture()
      assert {:ok, %Calendar{} = calendar} = Calendars.delete_calendar(existing)
      assert calendar.state == "deleted"
    end
  end

  describe "get_calendar/1" do # get_calendar/2 with field \\ :id
    test "finds the calendar by its id" do
      existing = calendar_fixture()
      assert {:ok, %Calendar{}} = Calendars.get_calendar(existing.id)
    end
  end

  describe "get_calendar/2" do
    test "finds the calendar by its id" do
      existing = calendar_fixture()
      assert {:ok, %Calendar{}} = Calendars.get_calendar(existing.id, :id)
    end

    test "finds the calendar by its admin_id" do
      existing = calendar_fixture()
      assert {:ok, %Calendar{}} =
        Calendars.get_calendar(existing.admin_id, :admin_id)
    end

    test "returns a :not_found error if id is not a valid uuid" do
      assert {:error, :not_found} = Calendars.get_calendar("foo", :id)
    end

    test "returns a :not_found error when calendar does not exist" do
      uuid = "a75bb992-4454-40c5-af2c-60fb858e253c"
      assert {:error, :not_found} = Calendars.get_calendar(uuid, :id)
    end

    test "returns a :not_found error if id is used and state is deleted" do
      existing = calendar_fixture()
      Calendars.delete_calendar(existing)
      assert {:error, :not_found}  = Calendars.get_calendar(existing.id, :id)
    end

    test "returns the calendar if admin_id is used and state is deleted" do
      existing = calendar_fixture()
      Calendars.delete_calendar(existing)

      assert {:ok, %Calendar{} = calendar} =
        Calendars.get_calendar(existing.admin_id, :admin_id)
      assert calendar.state == "deleted"
    end

    test "does not allow matching against non-id fields" do
      existing = calendar_fixture()
      assert_raise FunctionClauseError, fn ->
        Calendars.get_calendar(existing.id, :title)
      end
    end
  end

  describe "update_calendar/2" do
    test "returns the updated calendar when attrs are valid" do
      existing = calendar_fixture()
      attrs = %{title: "updated title"}

      assert {:ok, calendar} = Calendars.update_calendar(existing, attrs)
      assert calendar.title == "updated title"

      {:ok, persisted} = Calendars.get_calendar(existing.id)
      assert persisted.title == "updated title"
    end

    test "returns an :invalid error when attrs are invalid" do
      existing = calendar_fixture()
      attrs = %{title: String.duplicate("x", 101)}

      assert {:error, :invalid, [title: "too_long"]} =
        Calendars.update_calendar(existing, attrs)
    end

    test "allows changing the state of the calendar" do
      existing = calendar_fixture()

      assert {:ok, calendar} =
        Calendars.update_calendar(existing, %{state: "anonymous"})
      assert calendar.state == "anonymous"
    end

    test "does not allow unsupported state transitions" do
      existing = calendar_fixture()

      assert {:ok, calendar} =
        Calendars.update_calendar(existing, %{state: "fire"})
      refute calendar.state == "fire"
    end
  end


  ### Public Events Interface

  @valid_event_attrs %{
    title: "Mission to Mars",
    start_at: "2022-08-17T14:47:00Z",
  }

  def event_changeset(calendar \\ calendar_fixture(), attrs) do
    calendar
    |> build_assoc(:events)
    |> Event.changeset(Map.merge(@valid_event_attrs, attrs))
  end

  def event_fixture(), do: event_fixture(%{})
  def event_fixture(calendar \\ calendar_fixture(), attrs) do
    changeset = event_changeset(calendar, attrs)
    {:ok, event} = Repo.insert(changeset)
    event
  end

  describe "create_event/2" do
    test "creates a new event associated with calendar" do
      calendar = calendar_fixture()
      assert {:ok, %Event{} = event} =
        Calendars.create_event(calendar, @valid_event_attrs)
      assert event.title == @valid_event_attrs[:title]
      assert Repo.one(assoc(event, :calendar))
    end

    test "returns an :invalid error when attrs are invalid" do
      attrs = %{@valid_event_attrs | title: nil}
      assert {:error, :invalid, [title: "required"]} =
        Calendars.create_event(calendar_fixture(), attrs)
    end
  end

  describe "get_event/1" do
    test "finds the event by its id" do
      existing = event_fixture()
      assert {:ok, %Event{}} = Calendars.get_event(existing.id)
    end

    test "returns a :not_found error if id is not a valid uuid" do
      assert {:error, :not_found} = Calendars.get_event("foo")
    end

    test "returns a :not_found error wen event does not exist" do
      uuid = "68af8148-cabf-45dd-9670-58408f762e29"
      assert {:error, :not_found} = Calendars.get_calendar(uuid)
    end
  end

  describe "update_event/2" do
    test "returns the updated event when attrs are valid" do
      existing = event_fixture()
      attrs = %{title: "updated title"}

      assert {:ok, event} = Calendars.update_event(existing, attrs)
      assert event.title == "updated title"

      {:ok, persisted} = Calendars.get_event(existing.id)
      assert persisted.title == "updated title"
    end

    test "returns an :invalid error when attrs are invalid" do
      existing = event_fixture()
      attrs = %{title: String.duplicate("x", 101)}

      assert {:error, :invalid, [title: "too_long"]} =
        Calendars.update_event(existing, attrs)
    end
  end

end
