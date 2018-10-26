defmodule TaskTracker.TimeBlocks.TimeBlock do
  use Ecto.Schema
  import Ecto.Changeset


  schema "time_blocks" do
    field :end, :naive_datetime
    field :start, :naive_datetime
    belongs_to :task, TaskTracker.Tasks.Task
    belongs_to :user, TaskTracker.Users.User

    timestamps()
  end

  @doc false
  def changeset(time_block, attrs) do
    time_block
    |> cast(attrs, [:start, :end, :task_id, :user_id])
    |> validate_required([:start, :end, :task_id, :user_id])
  end
end
