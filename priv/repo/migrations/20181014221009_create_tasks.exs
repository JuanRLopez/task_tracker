defmodule TaskTracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :text
      add :assigned_user, :string
      add :assigned_on, :utc_datetime
      add :completed, :boolean, default: false, null: false

      timestamps()
    end

  end
end
