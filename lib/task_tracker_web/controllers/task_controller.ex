defmodule TaskTrackerWeb.TaskController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Tasks
  alias TaskTracker.Tasks.Task

  def index(conn, _params) do
    tasks = Tasks.list_tasks()
    render(conn, "index.html", tasks: add_usernames(tasks))
  end

  def new(conn, _params) do
    changeset = Tasks.change_task(%Task{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    current_user = TaskTrackerWeb.Plugs.FetchSession.call(conn, %{}).assigns.current_user
    case Tasks.create_task(task_params, current_user) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: Routes.task_path(conn, :show, %Task{:id => task.id}))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    render(conn, "show.html", task: Enum.at(add_usernames([task]), 0))
  end

  def edit(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    task = Enum.at(add_usernames([task]), 0)
    changeset = Tasks.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)
    current_user = TaskTrackerWeb.Plugs.FetchSession.call(conn, %{}).assigns.current_user
    case Tasks.update_task(task, task_params, current_user) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    {:ok, _task} = Tasks.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: Routes.task_path(conn, :index))
  end

  defp add_usernames(tasks) do
    Enum.map(tasks, fn task -> Map.put(task, :assigned_user, TaskTracker.Users.get_user!(task.user_id).username) end)
  end
end
