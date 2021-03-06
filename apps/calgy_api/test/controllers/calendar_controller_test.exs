defmodule CalgyApi.CalendarControllerTest do
  use CalgyApi.ConnCase

  alias Plug.Conn
  alias Calgy.Calendars

  setup %{conn: orig_conn} do
    conn =
      orig_conn
      |> put_req_header("accept", "application/json")
    {:ok, %{conn: conn}}
  end

  test "POST creates a pending calendar by default", %{conn: conn} do
    conn = post conn, calendar_url(conn, :create), %{}
    body = json_response(conn, 201)

    {:ok, calendar} = Calendars.get_calendar(body["id"])
    assert calendar

    location = Conn.get_resp_header(conn, "location") |> List.first
    assert location == calendar_admin_url(conn, :show, calendar)

    assert body["state"] == "pending"
    assert body["public_url"] == calendar_url(conn, :show, calendar)
    assert body["admin_url"] == calendar_admin_url(conn, :show, calendar)
  end

  test "POST ignores attempts to set the id", %{conn: conn} do
    id = Ecto.UUID.generate
    conn = post conn, calendar_url(conn, :create), %{id: id}
    assert json_response(conn, 201)["id"] != id
  end

  test "POST allows setting :title and :description", %{conn: conn} do
    attrs = %{title: "my title", description: "my description"}
    conn = post conn, calendar_url(conn, :create), attrs
    body = json_response(conn, 201)

    assert body["title"] == "my title"
    assert body["description"] == "my description"
  end

  test "POST response does not include nil values", %{conn: conn} do
    conn = post conn, calendar_url(conn, :create), %{}
    body = json_response(conn, 201)

    refute Map.has_key?(body, "title")
    refute Map.has_key?(body, "description")
  end

  test "POST returns an error if any attributes are invalid", %{conn: conn} do
    attrs = %{title: String.duplicate("x", 101)}
    conn = post conn, calendar_url(conn, :create), attrs
    body = json_response(conn, 422)
    error = List.first(body["errors"])

    assert error["path"] == "#/title"
    assert error["code"] == "too_long"
  end

  test "GET shows information about a calendar", %{conn: conn} do
    {:ok, calendar} = Calendars.create_calendar()
    conn = get conn, calendar_url(conn, :show, calendar)
    body = json_response(conn, 200)

    assert body["id"]
    assert body["state"]
  end

  test "GET returns 404 if uuid is invalid", %{conn: conn} do
    {:ok, _calendar} = Calendars.create_calendar()
    conn = get conn, calendar_url(conn, :show, "teapot")
    body = json_response(conn, 404)
    assert body["error"]
  end

  test "GET retuns 404 if calendar is not found", %{conn: conn} do
    {:ok, _calendar} = Calendars.create_calendar()
    conn = get conn, calendar_url(conn, :show, Ecto.UUID.generate)
    body = json_response(conn, 404)
    assert body["error"]
  end

  test "GET returns calendar info for admin calendar url", %{conn: conn} do
    {:ok, calendar} = Calendars.create_calendar()
    conn = get conn, calendar_admin_url(conn, :show, calendar)
    assert json_response(conn, 200)
  end

  test "GET does not return the calendar's admin url", %{conn: conn} do
    {:ok, calendar} = Calendars.create_calendar()
    assert calendar.admin_id # Ensure an admin_id is set

    res = get conn, calendar_url(conn, :show, calendar)
    refute json_response(res, 200)["admin_url"]

    res = get conn, calendar_admin_url(conn, :show, calendar)
    refute json_response(res, 200)["admin_url"]
  end

  test "PUT does not allow updates if public calendar url is used", %{conn: conn} do
    {:ok, calendar} = Calendars.create_calendar()

    attrs = %{title: "new title", description: "new description"}
    conn = put conn, calendar_url(conn, :update, calendar), attrs
    assert json_response(conn, 404)
  end

  test "PUT ignores attempt to set the id", %{conn: conn} do
    {:ok, calendar} = Calendars.create_calendar()

    id = Ecto.UUID.generate
    conn = put conn, calendar_admin_url(conn, :update, calendar), %{id: id}
    assert json_response(conn, 200)["id"] == calendar.id
  end

  test "PUT allows setting :title and :description", %{conn: conn} do
    {:ok, calendar} = Calendars.create_calendar()

    attrs = %{title: "new title", description: "new description"}
    conn = put conn, calendar_admin_url(conn, :update, calendar), attrs
    body = json_response(conn, 200)

    assert body["title"] == "new title"
    assert body["description"] == "new description"
  end

  test "PUT returns an error if any attributes are invalid", %{conn: conn} do
    {:ok, calendar} = Calendars.create_calendar()

    attrs = %{title: String.duplicate("x", 101)}
    conn = put conn, calendar_admin_url(conn, :update, calendar), attrs
    body = json_response(conn, 422)
    error = List.first(body["errors"])

    assert error["path"] == "#/title"
    assert error["code"] == "too_long"
  end

  test "DELETE marks calendar as deleted if admin calendar url is used", %{conn: conn} do
    {:ok, calendar} = Calendars.create_calendar()

    res = delete conn, calendar_admin_url(conn, :delete, calendar)
    assert response(res, 204)

    res = get conn, calendar_url(conn, :show, calendar)
    assert json_response(res, 404)

    res = get conn, calendar_admin_url(conn, :show, calendar)
    assert json_response(res, 200)["state"] == "deleted"
  end

  test "DELETE does not allow deletion if public calendar url is used", %{conn: conn} do
    {:ok, calendar} = Calendars.create_calendar()

    res = delete conn, calendar_url(conn, :delete, calendar)
    assert json_response(res, 404)
  end

end
