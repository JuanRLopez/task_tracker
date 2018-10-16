defmodule TaskTracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :text
      add :user_id, references(:users, on_delete: :delete_all)
      add :time_worked, :integer
      add :completed, :boolean, default: false, null: false

      timestamps()
    end

  end
end
