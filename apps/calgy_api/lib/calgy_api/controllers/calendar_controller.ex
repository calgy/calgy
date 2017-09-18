defmodule CalgyApi.CalendarController do
  use CalgyApi, :controller

  alias Calgy.Calendars

  action_fallback CalgyApi.FallbackController

  def create(conn, params) do
    with {:ok, calendar} <- Calendars.create_calendar(params)
      do admin_url = calendar_admin_url(conn, :show, calendar)
         conn
         |> put_status(:created)
         |> put_resp_header("location", admin_url)
         |> render("calendar.json", %{calendar: calendar})
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, field, id} <- parse_calendar_id(id),
         {:ok, calendar}  <- Calendars.get_calendar(id, field)
      do render(conn, "calendar.json", %{calendar: calendar})
    end
  end

  def update(conn, %{"id" => id} = params) do
    with {:ok, :admin_id, id} <- parse_calendar_id(id),
         {:ok, existing} <- Calendars.get_calendar(id, :admin_id),
         {:ok, calendar} <- Calendars.update_calendar(existing, params)
      do render(conn, "calendar.json", %{calendar: calendar})
    else
      {:ok, :id, _id} -> {:error, :not_found} # Not an admin url, unauthorized
      fallback        -> fallback # Let pass to fallback controller
    end
  end

  defp parse_calendar_id(id) do
    case String.split_at(id, 36) do
      {id, ""}       -> {:ok, :id, id}
      {id, ";admin"} -> {:ok, :admin_id, id}
      _invalid_id    -> {:error, :not_found}
    end
  end

end
