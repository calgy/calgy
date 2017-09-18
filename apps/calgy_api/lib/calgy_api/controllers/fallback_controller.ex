defmodule CalgyApi.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use CalgyApi, :controller

  def call(conn, {:error, :invalid, errors}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(CalgyApi.ErrorView, :"422", validation_errors: errors)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(CalgyApi.ErrorView, :"404")
  end
end
