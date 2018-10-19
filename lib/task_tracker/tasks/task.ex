defmodule TaskTracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :completed, :boolean, default: false
    field :description, :string
    field :time_worked, :integer
    field :title, :string
    belongs_to :user, TaskTracker.Users.User

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :user_id, :time_worked, :completed])
    |> validate_required([:title, :description, :user_id, :time_worked, :completed])
    |> validate_inclusion(:time_worked, Enum.map(0..1000000, fn i -> i * 15 end), message: "time worked has to be in 15 minute intervals")
  end
end
