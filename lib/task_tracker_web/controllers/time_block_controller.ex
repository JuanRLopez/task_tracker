defmodule TaskTrackerWeb.TimeBlockController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.TimeBlocks
  alias TaskTracker.TimeBlocks.TimeBlock

  action_fallback TaskTrackerWeb.FallbackController

  def index(conn, %{"task_id" => task_id}) do
    time_blocks = TimeBlocks.list_time_blocks(task_id)
    render(conn, "index.json", time_blocks: time_blocks)
  end

  def index(conn, _params) do
    time_blocks = TimeBlocks.list_time_blocks()
    render(conn, "index.json", time_blocks: time_blocks)
  end
  
  def create(conn, %{"time_block_params" => time_block_params}) do
    with {:ok, %TimeBlock{} = time_block} <- TimeBlocks.create_time_block(time_block_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.time_block_path(conn, :show, time_block))
      |> render("show.json", time_block: time_block)
    end
  end

  def create(conn, params) do
    params = Map.get(params, "time_block")
    {d1, start_datetime} = NaiveDateTime.new(elem(Date.from_iso8601(Map.get(params, "start_date")), 1), elem(Time.from_iso8601(Map.get(params, "start_time") <> ":00"), 1))
    {d2, end_datetime} = NaiveDateTime.new(elem(Date.from_iso8601(Map.get(params, "end_date")), 1), elem(Time.from_iso8601(Map.get(params, "end_time") <> ":00"), 1))      

    time_block_params = %{}
    |> Map.put("user_id", Map.get(params, "user_id"))
    |> Map.put("task_id", Map.get(params, "task_id"))
    |> Map.put("start", start_datetime)
    |> Map.put("end", end_datetime)
    with {:ok, %TimeBlock{} = time_block} <- TimeBlocks.create_time_block(time_block_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.time_block_path(conn, :show, time_block))
      |> render("show.json", time_block: time_block)
    end
  end

  def show(conn, %{"id" => id}) do
    time_block = TimeBlocks.get_time_block!(id)
    render(conn, "show.json", time_block: time_block)
  end

  def update(conn, %{"id" => id, "time_block" => time_block_params}) do
    time_block = TimeBlocks.get_time_block!(id)

    with {:ok, %TimeBlock{} = time_block} <- TimeBlocks.update_time_block(time_block, time_block_params) do
      render(conn, "show.json", time_block: time_block)
    end
  end

  def delete(conn, %{"id" => id}) do
    time_block = TimeBlocks.get_time_block!(id)

    with {:ok, %TimeBlock{}} <- TimeBlocks.delete_time_block(time_block) do
      send_resp(conn, :no_content, "")
    end
  end
end
