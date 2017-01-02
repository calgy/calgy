defmodule CalgyApi.Calendar do
  use CalgyApi.Web, :model

  schema "calendars" do
    field :state, :string, default: "pending"
    field :title, :string
    field :description, :string
    timestamps
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:title, :description])
    |> validate_length(:title, max: 100, message: "too_long")
    |> validate_length(:description, max: 2000, message: "too_long")
  end

end
