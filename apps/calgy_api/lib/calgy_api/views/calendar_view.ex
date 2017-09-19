defmodule CalgyApi.CalendarView do
  use CalgyApi, :view
  import CalgyApi.Helpers.ViewHelpers, only: [reject_nils: 1]

  def render("calendar.json", %{conn: conn, calendar: calendar}) do
    # Only newly created events can include an admin_url in body
    admin_url = case conn.status do
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
