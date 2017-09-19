defmodule Calgy.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :text, null: false
      add :start_at, :utc_datetime, null: false
      add :end_at, :utc_datetime
      add :description, :text
      add :calendar_id, references(:calendars, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:events, [:calendar_id, :start_at, :end_at])
  end
end
