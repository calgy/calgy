defmodule CalgyApi.Calendar do
  use CalgyApi.Web, :model

  schema "calendars" do
    field :state, :string
    timestamps
  end

  def changeset(_struct, _params) do
    %CalgyApi.Calendar{state: "pending"}
  end

end
