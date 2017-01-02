defmodule CalgyApi.ErrorView do
  use CalgyApi.Web, :view

  def render("404.json", _assigns) do
    %{error: "not found"}
  end

  def render("422.json", changeset) do
    errors = for {field, {msg, _}} <- changeset.errors,
      do: %{ path: "#/#{field}", code: msg }

    %{ errors: errors }
  end

  def render("500.json", _assigns) do
    %{error: "server error"}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
