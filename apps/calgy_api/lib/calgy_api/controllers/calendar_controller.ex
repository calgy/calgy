defmodule CalgyApi.CalendarController do
  use CalgyApi, :controller

  alias Calgy.Calendars

  action_fallback CalgyApi.FallbackController

  def create(conn, params) do
    with {:ok, calendar} <- Calendars.create_calendar(params)
      do admin_url = calendar_url(conn, :show, calendar.admin_id) <> ";admin"
         conn
         |> put_status(:created)
         |> put_resp_header("location", admin_url)
         |> render("calendar.json", %{calendar: calendar})
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, calendar} <- find_calendar(id)
      do render(conn, "calendar.json", %{calendar: calendar})
    end
  end

  def update(conn, %{"id" => id} = params) do
    with {:ok, existing} <- find_calendar(id),
         {:ok, calendar} <- Calendars.update_calendar(existing, params)
      do render(conn, "calendar.json", %{calendar: calendar})
    end
  end

  defp find_calendar(id) do
    case String.split_at(id, 36) do
      {id, ""}       -> Calendars.get_calendar(id, :id)
      {id, ";admin"} -> Calendars.get_calendar(id, :admin_id)
      _invalid_id    -> {:error, :not_found}
    end
  end

end
