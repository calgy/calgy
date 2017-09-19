defmodule Calgy.Calendars.Calendar do
  use Ecto.Schema
  import Ecto.Changeset

  alias Calgy.Calendars.Calendar

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "calendars" do
    field :state, :string, default: "pending"
    field :title, :string
    field :description, :string
    field :admin_id, Ecto.UUID
    has_many :events, Calgy.Calendars.Event

    timestamps()
  end

  def try_state_transition(changeset, %{} = attrs) do
    case attrs do
      %{:state  => state} -> try_state_transition(changeset, state)
      %{"state" => state} -> try_state_transition(changeset, state)
      _attrs              -> changeset
    end
  end
  def try_state_transition(changeset, requested_state) do
    case {changeset.data.state, requested_state} do
      # No state change was requested, do nothing
      {^requested_state, ^requested_state} -> changeset

      # Any calendar can be deleted, once deleted the state cannot change
      {"deleted", _req_state}  -> changeset
      {_orig_state, "deleted"} -> set_state(changeset, "deleted")

      # Any non-deleted calendar can be made anonymous and then cannot change
      {"anonymous", _req_state}  -> changeset
      {_orig_state, "anonymous"} -> set_state(changeset, "anonymous")

      # Unknown transition, ignore
      {_orig_state, _req_state} -> changeset
    end
  end

  @doc false
  def changeset(%Calendar{} = calendar, attrs \\ %{}) do
    calendar
    |> set_defaults
    |> cast(attrs, [:title, :description])
    |> validate_length(:title, max: 100, message: "too_long")
    |> validate_length(:description, max: 2000, message: "too_long")
    |> try_state_transition(attrs)
  end

  defp set_defaults(calendar_or_changeset) do
    changeset = cast(calendar_or_changeset, %{}, [])

    case Ecto.get_meta(changeset.data, :state) do
      :built -> # new record
        changeset
        |> Ecto.Changeset.put_change(:admin_id, Ecto.UUID.generate)
      _ -> changeset
    end
  end

  defp set_state(orig_changeset, new_state) do
    changeset = Ecto.Changeset.put_change(orig_changeset, :state, new_state)

    case new_state do
      "anonymous"  -> Ecto.Changeset.put_change(changeset, :admin_id, nil)
      _other_state -> changeset
    end
  end

end
