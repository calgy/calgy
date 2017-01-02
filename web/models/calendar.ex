defmodule CalgyApi.Calendar do
  use CalgyApi.Web, :model

  schema "calendars" do
    field :state, :string, default: "pending"
    field :title, :string
    field :description, :string
    field :admin_id, :binary_id
    timestamps
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:title, :description])
    |> validate_length(:title, max: 100, message: "too_long")
    |> validate_length(:description, max: 2000, message: "too_long")
    |> set_defaults
  end

  def set_defaults(changeset) do
    case Ecto.get_meta(changeset.data, :state) do
      :built -> # new record
        changeset
        |> Ecto.Changeset.put_change(:admin_id, Ecto.UUID.generate)
      _ -> changeset
    end
  end

end
