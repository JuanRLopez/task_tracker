defmodule TaskTracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :assigned_on, :utc_datetime
    field :assigned_user, :string
    field :completed, :boolean, default: false
    field :description, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :assigned_user, :assigned_on, :completed])
    |> validate_required([:title, :description, :assigned_user, :assigned_on, :completed])
  end
end
