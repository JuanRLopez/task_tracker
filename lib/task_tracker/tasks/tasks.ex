defmodule TaskTracker.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias TaskTracker.Repo
  alias TaskTracker.Tasks.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}, current_user) do
    # user_id, time_worked, completed
    
    user_id = case attrs["assigned_user"] do
      "" -> -1
      _ -> TaskTracker.Users.get_user_by_username(attrs["assigned_user"]).id
    end

    attrs = attrs
    |> Map.delete("assigned_user")
    |> Map.put("user_id", user_id)
    |> Map.put("completed", false)
    |> Map.put("time_worked", 0)

    task_changeset = %Task{} |> Task.changeset(attrs)
    user_manager_id = TaskTracker.Users.get_user!(user_id).manager_id
    task_changeset = cond do
      user_manager_id == current_user.id -> task_changeset
      true -> Ecto.Changeset.add_error(task_changeset, :assigned_user, "only managers can assign tasks to their employees")
    end
    Repo.insert(task_changeset)
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs, current_user) do
    user_id = case attrs["assigned_user"] do
      "" -> -1
      _ -> TaskTracker.Users.get_user_by_username(attrs["assigned_user"]).id
    end
    attrs = Map.put(attrs, "user_id", user_id)

    task = task |> Task.changeset(attrs)
    user_manager_id = TaskTracker.Users.get_user!(user_id).manager_id
    task = cond do
      user_manager_id == current_user.id -> task
      true -> Ecto.Changeset.add_error(task, :assigned_user, "only managers can assign tasks to their employees")
    end
    Repo.update(task)
  end

  @doc """
  Deletes a Task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end
end
