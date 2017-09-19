defmodule Calgy.Calendars.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias Calgy.Calendars.Event

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "events" do
    field :description, :string
    field :end_at, :utc_datetime
    field :start_at, :utc_datetime
    field :title, :string
    belongs_to :calendar, Calgy.Calendars.Calendar

    timestamps()
  end

  @doc false
  def changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [:title, :start_at, :end_at, :description])
    |> validate_required([:title, :start_at], message: "required")
    |> validate_length(:title, max: 100, message: "too_long")
    |> validate_length(:description, max: 5000, message: "too_long")
  end

end
