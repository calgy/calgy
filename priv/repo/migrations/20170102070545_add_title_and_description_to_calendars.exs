defmodule CalgyApi.Repo.Migrations.AddTitleAndDescriptionToCalendars do
  use Ecto.Migration

  def change do
    alter table(:calendars) do
      add :title, :text
      add :description, :text
    end
  end
end
