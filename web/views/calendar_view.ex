defmodule CalgyApi.CalendarView do
  use CalgyApi.Web, :view

  def render("calendar.json", %{conn: conn, calendar: calendar}) do
    case calendar do
      %{state: "pending"} -> render_pending(conn, calendar)
    end
  end

  def admin_url(conn, calendar) do
    case calendar.admin_id do
      nil -> nil
      id  -> calendar_url(conn, :show, id) <> ";admin"
    end
  end

  def public_url(conn, calendar) do
    calendar_url(conn, :show, calendar.id)
  end

  defp reject_nils(map) do
    for {k,v} <- map, v != nil, into: %{}, do: {k,v}
  end

  defp render_pending(conn, calendar) do
    reject_nils %{
      id: calendar.id,
      state: calendar.state,
      title: calendar.title,
      description: calendar.description,
#     admin_url: admin_url(conn, calendar),
      public_url: public_url(conn, calendar),
    }
  end

end
