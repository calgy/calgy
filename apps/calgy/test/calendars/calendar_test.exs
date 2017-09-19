defmodule Calgy.Calendars.CalendarTest do
  use Calgy.DataCase

  alias Calgy.Calendars.Calendar

  @valid_attrs %{title: "my calendar", description: "horse eats radish"}

  defp changeset(struct \\ %Calendar{}, attrs) do
    attrs = Map.merge(@valid_attrs, attrs)
    Calendar.changeset(struct, attrs)
  end

  describe "changeset/2" do
    test "is valid when attributes are valid" do
      changeset = Calendar.changeset(%Calendar{}, @valid_attrs)
      assert changeset.valid?
    end

    test "is invalid when attributes are invalid" do
      invalid_attrs = %{title: String.duplicate("x", 101)}
      changeset = Calendar.changeset(%Calendar{}, invalid_attrs)
      refute changeset.valid?
    end

    test "limits title to 100 characters" do
      assert changeset(%{title: String.duplicate("x", 100)}).valid?

      attrs = Map.put(@valid_attrs, :title, String.duplicate("x", 101))
      assert {:title, ["too_long"]} in errors_on(changeset(attrs))
    end

    test "limits description to 2000 characters" do
      assert changeset(%{description: String.duplicate("x", 2000)}).valid?

      attrs = Map.put(@valid_attrs, :description, String.duplicate("x", 2001))
      assert {:description, ["too_long"]} in errors_on(changeset(attrs))
    end

    test "generates a default :admin_id for new calendars" do
      changeset = Calendar.changeset(%Calendar{}, %{})
      assert Ecto.Changeset.apply_changes(changeset).admin_id
    end

    test "does not overwrite :admin_id for existing calendars" do
      calendar =
        %Calendar{admin_id: "orig-uuid"}
        |> Ecto.put_meta(state: :loaded)
        |> Calendar.changeset(%{})
        |> Ecto.Changeset.apply_changes

      assert calendar.admin_id == "orig-uuid"
    end

    test "does not generate new :admin_id if existing is nil" do
      calendar =
        %Calendar{}
        |> Ecto.put_meta(state: :loaded)
        |> Calendar.changeset(%{})
        |> Ecto.Changeset.apply_changes

      refute calendar.admin_id
    end

    test "applies valid state transitions" do
      calendar =
        %Calendar{state: "pending"}
        |> Calendar.changeset(%{state: "anonymous"})
        |> Ecto.Changeset.apply_changes
      assert calendar.state == "anonymous"
    end

    test "does not apply invalid state transitions" do
      calendar =
        %Calendar{state: "deleted"}
        |> Calendar.changeset(%{state: "anonymous"})
        |> Ecto.Changeset.apply_changes
      assert calendar.state == "deleted"
    end
  end

  describe "#try_state_transition/2" do
    @all_states ~w[pending anonymous deleted]

    @valid_transitions [
      {"pending",   "anonymous"},
      {"pending",   "deleted"  },
      {"anonymous", "deleted"  },
    ]

    test "applies state transition when given a string/binary state" do
      calendar =
        changeset(%{})
        |> Calendar.try_state_transition("anonymous")
        |> Ecto.Changeset.apply_changes
      assert calendar.state == "anonymous"
    end

    test "applies state transition when given a map of args with a state key" do
      calendar_w_symbol_keys =
        changeset(%{})
        |> Calendar.try_state_transition(%{state: "anonymous"})
        |> Ecto.Changeset.apply_changes
      assert calendar_w_symbol_keys.state == "anonymous"

      calendar_w_string_keys =
        changeset(%{})
        |> Calendar.try_state_transition(%{"state" => "anonymous"})
        |> Ecto.Changeset.apply_changes
      assert calendar_w_string_keys.state == "anonymous"
    end

    test "does not apply state transition if given a map without a state key" do
      calendar =
        changeset(%{})
        |> Calendar.try_state_transition(%{})
        |> Ecto.Changeset.apply_changes
      assert calendar.state == %Calendar{}.state
    end

    test "allows valid state transitions" do
      for {s1, s2} <- @valid_transitions do
        calendar =
          changeset(%Calendar{state: s1}, %{})
          |> Calendar.try_state_transition(s2)
          |> Ecto.Changeset.apply_changes
        assert calendar.state == s2
      end
    end

    test "ignores invalid state transitions" do
      all_transitions =
        for s1 <- @all_states,
            s2 <- @all_states,
            s1 != s2, # Exclude transition to same state
            do: {s1, s2}

      invalid_transitions = all_transitions -- @valid_transitions

      for {s1, s2} <- invalid_transitions do
        calendar =
          changeset(%Calendar{state: s1}, %{})
          |> Calendar.try_state_transition(s2)
          |> Ecto.Changeset.apply_changes
        refute calendar.state == s2
        assert calendar.state == s1
      end
    end

    test "clears the admin_id when transitioning to the 'anonymous' state" do
      calendar = Ecto.Changeset.apply_changes(changeset(%{}))
      refute calendar.admin_id == nil

      transitioned =
        Calendar.changeset(calendar)
        |> Calendar.try_state_transition("anonymous")
        |> Ecto.Changeset.apply_changes
      assert transitioned.admin_id == nil
    end
  end

end
