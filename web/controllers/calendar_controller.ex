defmodule CalgyApi.CalendarController do
  use CalgyApi.Web, :controller
  alias CalgyApi.Calendar

  def create(conn, _) do
    {:ok, calendar} = Repo.insert(%Calendar{})

    conn
    |> put_status(201)
    |> render("calendar.json", %{calendar: calendar})
  end

  def show(conn, %{"id" => id}) do
    with {:ok, uuid} <- Ecto.UUID.cast(id),
         %Calendar{} = calendar <- Repo.get(Calendar, uuid)
     do render(conn, "calendar.json", %{calendar: calendar})
    else
      _ ->
        conn
        |> put_status(404)
        |> render(CalgyApi.ErrorView, "404.json", %{})
    end
  end

end
