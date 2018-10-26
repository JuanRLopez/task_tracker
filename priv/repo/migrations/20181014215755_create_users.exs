defmodule TaskTracker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :manager_id, references(:users), null: false, default: -1

      timestamps()
    end

    create index(:users, [:manager_id])
  end
end
