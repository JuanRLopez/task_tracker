defmodule TaskTracker.TimeBlocks do
  @moduledoc """
  The TimeBlocks context.
  """

  import Ecto.Query, warn: false
  alias TaskTracker.Repo

  alias TaskTracker.TimeBlocks.TimeBlock

  @doc """
  Returns the list of time_blocks.

  ## Examples

      iex> list_time_blocks()
      [%TimeBlock{}, ...]

  """
  def list_time_blocks do
    Repo.all(TimeBlock)
  end

  def list_time_blocks(task_id) do
    Repo.all from t in TimeBlock,
      where: t.task_id == ^task_id,
      preload: [:user]
  end

  @doc """
  Gets a single time_block.

  Raises `Ecto.NoResultsError` if the Time block does not exist.

  ## Examples

      iex> get_time_block!(123)
      %TimeBlock{}

      iex> get_time_block!(456)
      ** (Ecto.NoResultsError)

  """
  def get_time_block!(id), do: Repo.get!(TimeBlock, id)

  @doc """
  Creates a time_block.

  ## Examples

      iex> create_time_block(%{field: value})
      {:ok, %TimeBlock{}}

      iex> create_time_block(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_time_block(attrs \\ %{}) do
    task_assigned = TaskTracker.Tasks.get_task!(attrs["task_id"]).user_id
    user_id = attrs["user_id"]  

    block_changeset =  %TimeBlock{}
    |> TimeBlock.changeset(attrs)
    
    block_changeset = cond do
      task_assigned != user_id -> Ecto.Changeset.add_error(block_changeset, :user_id, "This task is not assigned to you")
      NaiveDateTime.diff(attrs["start"], attrs["end"]) >= 0 ->  Ecto.Changeset.add_error(block_changeset, :user_id, "The end datetime cannot come before or at the start time")
      true -> block_changeset
    end

    Repo.insert(block_changeset)
  end

  @doc """
  Updates a time_block.

  ## Examples

      iex> update_time_block(time_block, %{field: new_value})
      {:ok, %TimeBlock{}}

      iex> update_time_block(time_block, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_time_block(%TimeBlock{} = time_block, attrs) do
    time_block
    |> TimeBlock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TimeBlock.

  ## Examples

      iex> delete_time_block(time_block)
      {:ok, %TimeBlock{}}

      iex> delete_time_block(time_block)
      {:error, %Ecto.Changeset{}}

  """
  def delete_time_block(%TimeBlock{} = time_block) do
    Repo.delete(time_block)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking time_block changes.

  ## Examples

      iex> change_time_block(time_block)
      %Ecto.Changeset{source: %TimeBlock{}}

  """
  def change_time_block(%TimeBlock{} = time_block) do
    TimeBlock.changeset(time_block, %{})
  end
end
