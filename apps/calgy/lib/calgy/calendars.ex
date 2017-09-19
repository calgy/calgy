defmodule Calgy.Calendars do
  import Ecto

  alias Calgy.Calendars.Calendar
  alias Calgy.Calendars.Event
  alias Calgy.Repo


  ### Public Calendars Interface

  def create_calendar(attrs \\ %{}) do
    changeset = Calendar.changeset(%Calendar{}, attrs)

    case Repo.insert(changeset) do
      {:ok, _calendar} = result -> result

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, :invalid, changeset_errors(changeset)}
    end
  end

  def delete_calendar(%Calendar{} = calendar) do
    {:ok, %Calendar{state: "deleted"}} =
      update_calendar(calendar, %{state: "deleted"})
  end

  def get_calendar(id, field \\ :id) when field in [:id, :admin_id] do
    with {:ok, uuid}     <- Ecto.UUID.cast(id),
         {:ok, calendar} <- calendar_get_by(field, uuid)
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


  ### Public Events Interface

  def create_event(%Calendar{} = calendar, attrs \\ %{}) do
    changeset =
      calendar
      |> build_assoc(:events)
      |> Event.changeset(attrs)

    case Repo.insert(changeset) do
      {:ok, _event} = result -> result

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, :invalid, changeset_errors(changeset)}
    end
  end

  def get_event(id) do
    with {:ok, uuid}      <- Ecto.UUID.cast(id),
         %Event{} = event <- Repo.get(Event, uuid)
      do {:ok, event}
    else
      :error -> {:error, :not_found} # UUID is invalid
      nil    -> {:error, :not_found} # Record not found
    end
  end

  def update_event(%Event{} = event, attrs) do
    changeset = Event.changeset(event, attrs)

    case Repo.update(changeset) do
      {:ok, _event} = result -> result

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, :invalid, changeset_errors(changeset)}
    end
  end


  defp calendar_get_by(field, id) do
    calendar = Repo.get_by(Calendar, [{field, id}])

    case calendar do
      # Only allowed to retrieve deleted events using an admin id
      %Calendar{state: "deleted", admin_id: ^id} -> {:ok, calendar}
      %Calendar{state: "deleted"}                -> {:error, :not_found}

      # Not deleted, allowed to access if found
      %Calendar{} -> {:ok, calendar}
      nil         -> {:error, :not_found}
    end
  end

  defp changeset_errors(%Ecto.Changeset{} = changeset) do
    Enum.map(changeset.errors, fn {field, {message, _}} ->
      {field, message}
    end)
  end

end
