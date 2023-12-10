defmodule FourInARow.GameTest do
  use FourInARowWeb.ConnCase, async: true
  alias FourInARow.Game

  test "get_blank_board" do
    board = Game.new_board()
    # test we get empty tiles
    assert Game.get_position(board, {0, 0}) == 0
    assert Game.get_position(board, {6, 5}) == 0
    # test the bounds
    assert Game.get_position(board, {7, 5}) == nil
    assert Game.get_position(board, {6, 6}) == nil
    assert Game.check_win(board) == nil
  end

  test "update_board" do
    board = Game.new_board()
    # test we can update the board
    assert Game.get_position(board, {0, 0}) == 0
    board = Game.update_position(board, {0, 0}, 1)
    assert Game.get_position(board, {0, 0}) == 1
    # test the bounds
    board = Game.update_position(board, {7, 5}, 1)
    assert Game.get_position(board, {7, 5}) == nil
    assert Game.get_position(board, {6, 6}) == nil
  end

  test "check_horizontal_win" do
    board = Game.new_board()
    # test we can win horizontally
    board = Game.update_position(board, {0, 0}, 1)
            |> Game.update_position({1, 0}, 1)
            |> Game.update_position({2, 0}, 1)
            |> Game.update_position({3, 0}, 1)
    assert Game.check_win(board) == {:won, 1}
  end

  test "check_vertical_win" do
    board = Game.new_board()
    # test we can win vertically
    board = Game.update_position(board, {0, 0}, 1)
    |> Game.update_position({0, 1}, 1)
    |> Game.update_position({0, 2}, 1)
    |> Game.update_position({0, 3}, 1)
    assert Game.check_win(board) == {:won, 1}
  end

  test "check_diagonal_bl_tr_win" do
    board = Game.new_board()
    # test we can win diagonally
    board = Game.update_position(board, {0, 0}, 1)
    |> Game.update_position({1, 1}, 1)
    |> Game.update_position({2, 2}, 1)
    |> Game.update_position({3, 3}, 1)
    assert Game.check_win(board) == {:won, 1}
  end

  test "check_diagonal_tl_br_win" do
    board = Game.new_board()
    # test we can win diagonally
    board = Game.update_position(board, {0, 3}, 1)
    |> Game.update_position({1, 2}, 1)
    dbg(board)

    assert(Game.check_win(board) == nil)

    board = Game.update_position(board, {2, 1}, 1)
    |> Game.update_position({3, 0}, 1)
    assert Game.check_win(board) == {:won, 1}
  end

  test "drop_token" do
    {:ok, board} = Game.new_board()
    |> Game.drop_token(3, 1)

    assert Game.get_position(board, {3, 0}) == 0
    assert Game.get_position(board, {3, 5}) == 1
  end

  test "drop multiple tokens" do
    board = Game.new_board()
    {:ok, board} = Game.drop_token(board, 3, 1)
    {:ok, board} = Game.drop_token(board, 3, 1)
    {:ok, board} = Game.drop_token(board, 3, 1)
    {:ok, board} = Game.drop_token(board, 3, 1)
    {:ok, board} = Game.drop_token(board, 3, 1)
    {:ok, board} = Game.drop_token(board, 3, 1)
    {:error, :no_space} = Game.drop_token(board, 3, 1)
    assert Game.get_position(board, {3, 0}) == 1
    assert Game.get_position(board, {3, 5}) == 1
  end

  test "check_tie" do
    board = [
      [1, 2, 1, 2, 1, 2, 1],
      [1, 2, 1, 2, 1, 2, 1],
      [2, 1, 2, 1, 2, 1, 2],
      [2, 1, 2, 1, 2, 1, 2],
      [1, 2, 1, 2, 1, 2, 1],
      [1, 2, 1, 2, 1, 2, 1],
    ]
    assert Game.check_win(board) == {:tie}
  end
end
