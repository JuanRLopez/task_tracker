defmodule TaskTracker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :manager_id, references(:users), default: -1, null: false

      timestamps()
    end

     create index(:users, [:manager_id])
  end
end
