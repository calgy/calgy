defmodule CalgyApi.ErrorViewTest do
  use CalgyApi.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(CalgyApi.ErrorView, "404.json", []) ==
           %{error: "not found"}
  end

  test "render 500.json" do
    assert render(CalgyApi.ErrorView, "500.json", []) ==
           %{error: "server error"}
  end

  test "render any other" do
    assert render(CalgyApi.ErrorView, "505.json", []) ==
           %{error: "server error"}
  end
end
