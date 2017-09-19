defmodule CalgyApi.Helpers.ViewHelpers do

  @doc ~S"""
  Formats a DateTime to an extended ISO8601 format. Equivalent to
  DateTime.to_iso8601 but truncates to the second and allows nil.

  ## Examples

      iex> CalgyApi.Helpers.ViewHelpers.format_datetime(nil)
      nil

      iex> {:ok, dt, _} = DateTime.from_iso8601("2017-09-19T12:15:46.246277Z")
      iex> CalgyApi.Helpers.ViewHelpers.format_datetime(dt)
      "2017-09-19T12:15:46Z"
  """
  def format_datetime(nil), do: nil
  def format_datetime(dt) do
    truncated = %DateTime{dt | microsecond: {0, 0}}
    DateTime.to_iso8601(truncated, :extended)
  end

  @doc ~S"""
  Removes any key/val pairs from a map that have a nil value.

  ## Examples

      iex> map = %{foo: "", bar: false, baz: nil, qux: 0}
      iex> CalgyApi.Helpers.ViewHelpers.reject_nils(map)
      %{foo: "", bar: false, qux: 0}
  """
  def reject_nils(map) do
    for {k,v} <- map, v != nil, into: %{}, do: {k,v}
  end

end
