defmodule CalgyApi.CalendarController do
  use CalgyApi.Web, :controller
  alias CalgyApi.Calendar

  def create(conn, _) do
    {:ok, calendar} = Repo.insert(%Calendar{})

    conn
    |> put_status(201)
    |> render("calendar.json", %{calendar: calendar})
  end

end
