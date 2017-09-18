defmodule Calgy.Calendars do
  import Ecto.Query, warn: false

  alias Calgy.Calendars.Calendar
  alias Calgy.Repo

  def create_calendar(attrs \\ %{}) do
    changeset = Calendar.changeset(%Calendar{}, attrs)

    case Repo.insert(changeset) do
      {:ok, _calendar} = result -> result

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, :invalid, changeset_errors(changeset)}
    end
  end

  def get_calendar(id, field \\ :id) when field in [:id, :admin_id] do
    with {:ok, uuid}     <- Ecto.UUID.cast(id),
         {:ok, calendar} <- repo_get_by(Calendar, [{field, uuid}])
      do {:ok, calendar}
    else
      :error -> {:error, :not_found} # UUID is invalid
      {:error, :not_found} = err -> err # Record not found
    end
  end

  def update_calendar(%Calendar{} = calendar, attrs) do
    changeset = Calendar.changeset(calendar, attrs)

    case Repo.update(changeset) do
      {:ok, _calendar} = result -> result

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, :invalid, changeset_errors(changeset)}
    end
  end

  defp changeset_errors(%Ecto.Changeset{} = changeset) do
    Enum.map(changeset.errors, fn {field, {message, _}} ->
      {field, message}
    end)
  end

  defp repo_get_by(queryable, clauses) do
    case Repo.get_by(queryable, clauses) do
      nil    -> {:error, :not_found}
      result -> {:ok, result}
    end
  end

end
