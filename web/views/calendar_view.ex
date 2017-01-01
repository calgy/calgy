defmodule CalgyApi.CalendarView do
  use CalgyApi.Web, :view

  def render("calendar.json", %{state: "pending"} = calendar) do
    %{
      "id" => calendar.id,
      "state" => calendar.state,
    }
  end
end
