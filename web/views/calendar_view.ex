defmodule CalgyApi.CalendarView do
  use CalgyApi.Web, :view

  def render("calendar.json", %{calendar: calendar}) do
    case calendar do
      %{state: "pending"} -> render_pending(calendar)
    end
  end

  defp render_pending(calendar) do
    %{
      id: calendar.id,
      state: calendar.state,
    }
  end

end
