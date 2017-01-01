defmodule CalgyApi.Calendar do
  use CalgyApi.Web, :model

  schema "calendars" do
    field :state, :string, default: "pending"
    timestamps
  end

  def changeset(struct, _params) do
    struct
  end

end
