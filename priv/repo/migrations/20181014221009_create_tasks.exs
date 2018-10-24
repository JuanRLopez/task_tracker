defmodule TaskTracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string, null: false
      add :description, :text
      add :user_id, references(:users), default: -1
      add :time_worked, :integer
      add :completed, :boolean, default: false, null: false

      timestamps()
    end

    create index(:tasks, [:user_id])
  end
end
