defmodule CalgyApi.CalendarControllerTest do
  use CalgyApi.ConnCase
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
  end

end
