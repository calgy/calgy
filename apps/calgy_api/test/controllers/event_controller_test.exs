defmodule CalgyApi.EventControllerTest do
  use CalgyApi.ConnCase

  alias Plug.Conn
  alias Calgy.Calendars

  @valid_attrs %{
    title: "Mission to Mars",
    start_at: "2022-08-17T14:47:00Z",
  }

  def fixture(:calendar) do
    {:ok, calendar} = Calendars.create_calendar()
    calendar
  end

  def fixture(:event) do
    {:ok, event} = Calendars.create_event(fixture(:calendar), @valid_attrs)
    event
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create event" do
    def create_url(conn) do
      calendar_event_url(conn, :create, fixture(:calendar).id)
    end

    test "persists the newly created event", %{conn: conn} do
      res = post conn, create_url(conn), @valid_attrs
      body = json_response(res, 201)

      assert {:ok, _event} = Calendars.get_event(body["id"])
    end

    test "responds with 201 created and location of event", %{conn: conn} do
      res = post conn, create_url(conn), @valid_attrs
      body = json_response(res, 201)

      location = Conn.get_resp_header(res, "location") |> List.first
      assert location == event_url(res, :show, body["id"])
    end

    test "response does not include nil values", %{conn: conn} do
      res = post conn, create_url(conn), @valid_attrs
      body = json_response(res, 201)

      refute Map.has_key?(body, "description")
      refute Map.has_key?(body, "end_at")
    end

    test "responds with 422 and errors if data is invalid", %{conn: conn} do
      invalid_attrs = %{title: String.duplicate("x", 101)}
      res = post conn, create_url(conn), Map.merge(@valid_attrs, invalid_attrs)
      body = json_response(res, 422)

      [error] = body["errors"]
      assert error["path"] == "#/title"
      assert error["code"] == "too_long"
    end
  end

  describe "show event" do
    setup [:create_event]

    test "responds with event data if event is found", %{conn: conn, event: event} do
      res = get conn, event_url(conn, :show, event)
      body = json_response(res, 200)

      assert body["title"] == @valid_attrs[:title]
      assert body["start_at"] == @valid_attrs[:start_at]

      assert body["calendar_url"] == calendar_url(conn, :show, event.calendar_id)
    end

    test "responds with 404 if event is not found", %{conn: conn} do
      res = get conn, event_url(conn, :show, Ecto.UUID.generate)
      body = json_response(res, 404)
      assert body["error"]
    end
  end

  describe "update event" do
    setup [:create_event]

    test "responds with 200 and updated event data if valid", %{conn: conn, event: event} do
      attrs = %{title: "new title", description: "new description"}
      res = put conn, event_url(conn, :update, event), attrs
      body = json_response(res, 200)

      assert body["title"] == "new title"
      assert body["description"] == "new description"
    end

    test "responds with 422 and errors if data is invalid", %{conn: conn, event: event} do
      invalid_attrs = %{title: String.duplicate("x", 101)}
      res = put conn, event_url(conn, :update, event), invalid_attrs
      body = json_response(res, 422)

      [error] = body["errors"]
      assert error["path"] == "#/title"
      assert error["code"] == "too_long"
    end
  end

  defp create_event(_) do
    event = fixture(:event)
    {:ok, event: event}
  end

end
