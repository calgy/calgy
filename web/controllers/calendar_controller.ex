defmodule CalgyApi.CalendarController do
  use CalgyApi.Web, :controller
  alias CalgyApi.Calendar

  def create(conn, %{} = params) do
    changeset = Calendar.changeset(%Calendar{}, params)
    {:ok, calendar} = Repo.insert(changeset)

    conn
    |> put_status(201)
    |> render("calendar.json", calendar)
  end

end
