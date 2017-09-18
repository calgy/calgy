defmodule CalgyApi.Helpers.UrlHelpers do
  import CalgyApi.Router.Helpers

  alias Calgy.Calendars.Calendar

  def calendar_admin_url(_conn, _action, nil), do: nil
  def calendar_admin_url(conn, action, %Calendar{} = calendar),
    do: calendar_admin_url(conn, action, calendar.admin_id)
  def calendar_admin_url(conn, action, admin_id),
    do: calendar_url(conn, action, admin_id) <> ";admin"

end
