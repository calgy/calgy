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

    timestamps()
  end

  @doc false
  def changeset(%Calendar{} = calendar, attrs) do
    calendar
    |> cast(attrs, [:title, :description])
    |> validate_length(:title, max: 100, message: "too_long")
    |> validate_length(:description, max: 2000, message: "too_long")
    |> set_defaults
  end

  defp set_defaults(changeset) do
    case Ecto.get_meta(changeset.data, :state) do
      :built -> # new record
        changeset
        |> Ecto.Changeset.put_change(:admin_id, Ecto.UUID.generate)
      _ -> changeset
    end
  end

end
