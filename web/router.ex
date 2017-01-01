defmodule CalgyApi.Router do
  use CalgyApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CalgyApi do
    pipe_through :api

    resources "/calendars", CalendarController, only: [:create, :show]
  end

end
