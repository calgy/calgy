defmodule CalgyApi.Repo.Migrations.CreateCalendarsTable do
  use Ecto.Migration

  def change do
    create table(:calendars, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :state, :text, null: false

      timestamps
    end
  end

end
