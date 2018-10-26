defmodule TaskTracker.Users.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :username, :string 
    belongs_to :manager, TaskTracker.Users.User
    has_many :employees, TaskTracker.Users.User, foreign_key: :manager_id
    has_many :tasks, TaskTracker.Tasks.Task
    has_many :time_blocks, TaskTracker.TimeBlocks.TimeBlock

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :manager_id])
    |> validate_required([:username, :manager_id])
    |> unique_constraint(:username)
  end
end
