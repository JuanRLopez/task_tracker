defmodule TaskTrackerWeb.SessionController do
  use TaskTrackerWeb, :controller

  def create(conn, %{"username" => username}) do
    user = TaskTracker.Users.get_user_by_username(username)
    IO.puts("\n #{inspect(user)} \n")
    if user do
      conn
      |> put_session(:username, user.username)
      |> put_flash(:info, "Welcome back #{user.username}")
      |> redirect(to: Routes.task_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Login failed.")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:username)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
