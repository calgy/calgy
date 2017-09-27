defmodule CalgyApi.EventView do
  use CalgyApi, :view
  import CalgyApi.Helpers.ViewHelpers, only: [format_datetime: 1, reject_nils: 1]

  def render("event.json", %{conn: conn, event: event}) do
    reject_nils %{
      id: event.id,
      title: event.title,
      start_at: format_datetime(event.start_at),
      end_at: format_datetime(event.end_at),
      description: event.description,
      public_url: event_url(conn, :show, event),
      calendar_url: calendar_url(conn, :show, event.calendar_id),
    }
  end

end
