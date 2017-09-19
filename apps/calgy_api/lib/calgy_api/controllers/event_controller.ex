defmodule CalgyApi.EventController do
  use CalgyApi, :controller

  alias Calgy.Calendars

  action_fallback CalgyApi.FallbackController

  def create(conn, %{"calendar_id" => calendar_id} = params) do
    with {:ok, calendar} <- Calendars.get_calendar(calendar_id),
         {:ok, event}    <- Calendars.create_event(calendar, params)
      do conn
         |> put_status(:created)
         |> put_resp_header("location", event_url(conn, :show, event))
         |> render("event.json", %{event: event})
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, event} <- Calendars.get_event(id)
      do render(conn, "event.json", %{event: event})
    end
  end

  def update(conn, %{"id" => id} = params) do
    with {:ok, existing} <- Calendars.get_event(id),
         {:ok, event}    <- Calendars.update_event(existing, params)
      do render(conn, "event.json", %{event: event})
    end
  end

end
