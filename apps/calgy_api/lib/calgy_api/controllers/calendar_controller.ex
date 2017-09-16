defmodule CalgyApi.CalendarController do
  use CalgyApi, :controller
  alias Calgy.Calendars.Calendar
  alias Calgy.Repo

  plug :find_calendar! when action in [:show, :update]

  def create(conn, params) do
    changeset = Calendar.changeset(%Calendar{}, params)

    case Repo.insert(changeset) do
      {:ok, calendar} ->
        admin_url = calendar_url(conn, :show, calendar.admin_id) <> ";admin"

        conn
        |> put_status(201)
        |> put_resp_header("location", admin_url)
        |> render("calendar.json", %{calendar: calendar})
      {:error, changeset} ->
        render_changeset_errors(conn, changeset)
    end
  end

  def show(conn, _params) do
    calendar = conn.assigns.calendar
    render(conn, "calendar.json", %{calendar: calendar})
  end

  def update(conn, params) do
    calendar = conn.assigns.calendar
    changeset = Calendar.changeset(calendar, params)

    case Repo.update(changeset) do
      {:ok, calendar} ->
        render(conn, "calendar.json", %{calendar: calendar})
      {:error, changeset} ->
        render_changeset_errors(conn, changeset)
    end
  end

  defp find_calendar(id) do
    {id, field} = case String.split_at(id, 36) do
      {id, ""}       -> {id, :id}
      {id, ";admin"} -> {id, :admin_id}
      _ ->              {nil, nil} # invalid uuid
    end

    case Ecto.UUID.cast(id) do
      {:ok, id} -> Repo.get_by(Calendar, [{field,id}])
      :error -> nil # invalid uuid
    end
  end

  defp find_calendar!(conn, _opts) do
    case find_calendar(conn.params["id"]) do
      nil -> render_not_found(conn)
      cal -> assign(conn, :calendar, cal)
    end
  end

  defp render_not_found(conn) do
    conn
    |> put_status(404)
    |> render(CalgyApi.ErrorView, "404.json", %{})
    |> halt()
  end

  defp render_changeset_errors(conn, changeset) do
    conn
    |> put_status(422)
    |> render(CalgyApi.ErrorView, "422.json", changeset)
    |> halt()
  end

end
