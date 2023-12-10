defmodule FourInARow.Game do
  # The game board module. This module gets the current tiles at a position,
  # checks for win conditions, and updates the board.
  def new_board do
    [
      # 0
      [0, 0, 0, 0, 0, 0, 0],
      # 1
      [0, 0, 0, 0, 0, 0, 0],
      # 2
      [0, 0, 0, 0, 0, 0, 0],
      # 3
      [0, 0, 0, 0, 0, 0, 0],
      # 4
      [0, 0, 0, 0, 0, 0, 0],
      # 5
      [0, 0, 0, 0, 0, 0, 0]
    ]
  end

  def get_position(board, {x, y}) do
    cond do
      x > 6 or y > 5 -> nil
      true -> Enum.at(Enum.at(board, y), x)
    end
  end

  def update_position(board, {x, y}, player) do
    cond do
      x > 6 or y > 5 -> board
      true -> put_in(board, [Access.at(y), Access.at(x)], player)
    end
  end

  def drop_token(board, x, player) do
    # need to search from the bottom of the board up
    # find the first empty space
    y = Enum.find_index(Enum.reverse(board), fn row ->
      Enum.at(row, x) == 0
    end)
    case y do
      nil -> {:error, :no_space}
      _ -> {:ok, update_position(board, {x, 5 - y}, player)}
    end
  end

  def check_win(board) do
    # iterate each square and look for a win
    # this could be more efficient by only checking possible combinations, but checking everything for now

    # iterate each row
    # iterate each column
    Enum.flat_map(0..5, fn y ->
      Enum.map(0..6, fn x ->
        check_win(board, {x, y})
      end)
    end)
    |> Enum.find(fn x ->
      case x do
        false -> false
        win -> win
      end
    end)
  end

  def check_win(board, {x, y}) do
    case get_position(board, {x, y}) do
      nil ->
        false

      0 ->
        false

      player ->
        # check vertical
        vertical = check_vertical(board, {x, y}, player)
        # check horizontal
        horizontal = check_horizontal(board, {x, y}, player)
        # check diagonal
        diagonal = check_diagonal(board, {x, y}, player)
        # check if we have 4 in a row
        if vertical or horizontal or diagonal do
          # return the player who won
          {:won, player}
        else
          # no winner
          false
        end
    end
  end

  def check(board, {x, y}, check_player, stepper_fn, count) do
    # get the current player
    player_position = get_position(board, {x, y})
    next_step = stepper_fn.({x, y})

    cond do
      x < 0 or x > 6 or y < 0 or y > 5 -> 
      count
      player_position == nil -> 
        count
      player_position == 0 -> 
        count
      player_position == check_player ->
        check(board, next_step, check_player, stepper_fn, count + 1)
      true ->
      count
    end
  end

  defp check_horizontal(board, {x, y}, player) do
    # check left
    left = check(board, {x, y}, player, fn {x, y} -> {x - 1, y} end, -1)
    # check right
    right = check(board, {x, y}, player, fn {x, y} -> {x + 1, y} end, 0)
    # check if we have 4 in a row
    if left + right >= 4 do
      true
    else
      false
    end
  end

  defp check_vertical(board, {x, y}, player) do
    # check down
    down = check(board, {x, y}, player, fn {x, y} -> {x, y - 1} end, -1)

    # check up
    up = check(board, {x, y}, player, fn {x, y} -> {x, y + 1} end, 0)

    # check if we have 4 in a row
    if down + up >= 4 do
      true
    else
      false
    end
  end

  defp check_top_left_bottom_right(board, {x, y}, player) do
    # check up and left
    up_left = check(board, {x, y}, player, fn {x, y} -> {x - 1, y - 1} end, -1)

    # check down and right
    down_right = check(board, {x, y}, player, fn {x, y} -> {x + 1, y + 1} end, 0)

    # check if we have 4 in a row
    if up_left + down_right >= 4 do
      true
    else
      false
    end
  end

  defp check_top_right_bottom_left(board, {x, y}, player) do
    # check up and right
    up_right = check(board, {x, y}, player, fn {x, y} -> {x + 1, y - 1} end, -1)

    # check down and left
    down_left = check(board, {x, y}, player, fn {x, y} -> {x - 1, y + 1} end, 0)

    # check if we have 4 in a row
    if up_right + down_left >= 4 do
      true
    else
      false
    end
  end

  defp check_diagonal(board, {x, y}, player) do
    # check top left to bottom right
    top_left_bottom_right = check_top_left_bottom_right(board, {x, y}, player)

    # check top right to bottom left
    top_right_bottom_left = check_top_right_bottom_left(board, {x, y}, player)

    # check if we have 4 in a row
    if top_left_bottom_right or top_right_bottom_left do
      true
    else
      false
    end
  end
end
