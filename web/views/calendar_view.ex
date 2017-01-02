defmodule CalgyApi.CalendarView do
  use CalgyApi.Web, :view

  def render("calendar.json", %{calendar: calendar}) do
    case calendar do
      %{state: "pending"} -> render_pending(calendar)
    end
  end

  defp reject_nils(map) do
    for {k,v} <- map, v != nil, into: %{}, do: {k,v}
  end

  defp render_pending(calendar) do
    reject_nils %{
      id: calendar.id,
      state: calendar.state,
      title: calendar.title,
      description: calendar.description,
    }
  end

end
