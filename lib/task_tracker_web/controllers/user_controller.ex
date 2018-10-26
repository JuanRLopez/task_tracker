defmodule TaskTrackerWeb.UserController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Users
  alias TaskTracker.Users.User

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    user = %User{}
    |> Map.put(:manager, nil)
    |> Map.put(:employees, nil)
    changeset = Users.change_user(user)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: "/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    user = Map.put(user, :manager, Users.get_user!(user.manager_id).username)
    changeset = Users.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do

    user = Users.get_user!(id)
    case Users.update_user(user, user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, Users.get_user(user.id)))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "username" => username}) do
    
    current_user = Users.get_user(id)
    user = Users.get_user_by_username(username)
    #manager = Users.get_user(user.manager_id)
    user_params = %{"manager" => current_user.username}
    case Users.update_user(user, user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, Users.get_user(current_user.id)))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "show.html", user: Users.get_user(current_user.id))
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    {:ok, _user} = Users.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
