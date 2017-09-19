defmodule CalgyApi.Router do
  use CalgyApi, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CalgyApi do
    pipe_through :api

    resources "/calendars", CalendarController, only: [:create, :delete, :show, :update] do
      resources "/events", EventController, only: [:create]
    end

    resources "/events", EventController, only: [:show, :update]
  end

end
