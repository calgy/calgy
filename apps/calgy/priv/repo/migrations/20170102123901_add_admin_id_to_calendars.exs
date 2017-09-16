defmodule Calgy.Repo.Migrations.AddAdminIdToCalendars do
  use Ecto.Migration

  def change do
    alter table(:calendars) do
      add :admin_id, :uuid
    end

    create unique_index(:calendars, [:admin_id])
  end
end
