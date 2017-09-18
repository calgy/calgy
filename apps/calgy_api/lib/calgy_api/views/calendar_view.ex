defmodule CalgyApi.CalendarView do
  use CalgyApi, :view

  def render("calendar.json", %{conn: conn, calendar: calendar}) do
    case calendar do
      %{state: "pending"} -> render_pending(conn, calendar)
    end
  end

  defp reject_nils(map) do
    for {k,v} <- map, v != nil, into: %{}, do: {k,v}
  end

  defp render_pending(%{status: status} = conn, calendar) do
    admin_url = case status do
      201 -> calendar_admin_url(conn, :show, calendar)
      _   -> nil
    end

    reject_nils %{
      id: calendar.id,
      state: calendar.state,
      title: calendar.title,
      description: calendar.description,
      admin_url: admin_url,
      public_url: calendar_url(conn, :show, calendar),
    }
  end

end
