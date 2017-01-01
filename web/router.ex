defmodule CalgyApi.Router do
  use CalgyApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CalgyApi do
    pipe_through :api
  end
end
