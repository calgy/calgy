defmodule CalgyApi.CalendarControllerTest do
  use CalgyApi.ConnCase

  alias Plug.Conn
  alias CalgyApi.Calendar

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")

    {:ok, %{conn: conn}}
  end

  test "POST creates a pending calendar by default", %{conn: conn} do
    conn = post conn, calendar_path(conn, :create), %{}
    body = json_response(conn, 201)

    assert body["id"]
    assert body["state"] == "pending"
    assert Repo.get(Calendar, body["id"])

    location = Conn.get_resp_header(conn, "location") |> List.first
    assert location == calendar_url(conn, :show, body["id"])
  end

  test "GET shows information about a calendar", %{conn: conn} do
    {:ok, calendar} = Repo.insert(%Calendar{})
    conn = get conn, calendar_path(conn, :show, calendar)
    body = json_response(conn, 200)

    assert body["id"]
    assert body["state"]
  end

  test "GET returns 404 if uuid is invalid", %{conn: conn} do
    {:ok, _calendar} = Repo.insert(%Calendar{})
    conn = get conn, calendar_path(conn, :show, "teapot")
    body = json_response(conn, 404)
    assert body["error"]
  end

  test "GET retuns 404 if calendar is not found", %{conn: conn} do
    {:ok, _calendar} = Repo.insert(%Calendar{})
    conn = get conn, calendar_path(conn, :show, Ecto.UUID.generate)
    body = json_response(conn, 404)
    assert body["error"]
  end

end
