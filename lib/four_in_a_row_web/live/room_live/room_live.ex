defmodule FourInARowWeb.RoomLive do
  # this is the live view for an active game room
  use FourInARowWeb, :live_view

  alias FourInARow.Presence
  alias FourInARow.Game

  embed_templates "components/*.html"

  @impl true
  def mount(%{"room_id" => room_id}, _session, socket) do
    if connected?(socket) do
      # generate a player id and find connected users
      player_id = gen_player_id()
      user_ids = connected_users(room_id)

      # see if the room is full or not
      if length(user_ids) < 2 do
        {:ok, _} = Presence.track(self(), "room/#{room_id}", player_id, %{})

        Phoenix.PubSub.subscribe(
          FourInARow.PubSub,
          "room/#{room_id}"
        )

        # update it since we're now tracking
        user_ids = connected_users(room_id)

        {:ok,
         socket
         |> assign(player_id: player_id)
         |> assign(room_id: room_id)
         |> assign(game: Game.new_board())
         |> assign(connected: true)
         |> assign(connected_users: user_ids)
         |> assign(turn: nil)
         |> assign(game_over: false)
       |> assign(i_won: false)
         |> assign_state()}
      else
        {:ok,
         socket
         |> put_flash(:error, "This room is full. Returning you to the lobby")
         |> push_navigate(to: ~p"/")}
      end
    else
      # This is the server generated view, need to wait for connected users
      {:ok,
       socket
       |> assign(room_id: room_id)
       |> assign(game: Game.new_board())
       |> assign(connected: false)
       |> assign(connected_users: [])
       |> assign(turn: nil)
       |> assign(game_over: false)
       |> assign(i_won: false)
       |> assign_state()}
    end
  end

  defp connected_users(room_id) do
    # transform from presence struct
    users =
      for user <- Presence.list("room/#{room_id}"), reduce: [] do
        acc ->
          {player_id, _} = user
          acc ++ [player_id]
      end
  end

  defp assign_state(socket) do
    case socket.assigns.connected_users do
      [player1] ->
        socket
        |> assign(state: "waiting")
        |> assign(player1: player1)
        |> assign(player2: nil)

      [player1, player2] ->
        socket
        |> assign(state: "playing")
        |> assign(player1: player1)
        |> assign(player2: player2)
        |> assign(turn: player1)

      _ ->
        socket
        |> assign(state: "waiting")
        |> assign(player1: nil)
        |> assign(player2: nil)
    end
  end

  defp send_game_updated(room_id, game, turn) do
    Phoenix.PubSub.broadcast!(
      FourInARow.PubSub,
      "room/#{room_id}",
      {:game_updated, %{game: game, turn: turn}}
    )
  end

  def new_turn(socket) do
    cond do
      socket.assigns.turn == socket.assigns.player1 ->
        socket.assigns.player2
      true ->
        socket.assigns.player1
    end
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    # update the connected users
    user_ids = connected_users(socket.assigns.room_id)

    {:noreply,
     socket
     |> assign(connected_users: user_ids)
     |> assign(game: Game.new_board())
     |> assign(game_over: false)
     |> assign_state()}
  end

  @impl true
  def handle_info({:game_updated, %{game: game, turn: turn}}, socket) do
    case Game.check_win(game) do
      nil -> 
        {:noreply,
         socket
         |> assign(game: game)
         |> assign(turn: turn)
        }
      {:won, player} ->
        {:noreply,
         socket
         |> assign(game_over: true)
         |> assign(i_won: player == player_number(socket.assigns))
        }
    end
  end

  
  @impl true
  def handle_event("clicked", %{"x" => x}, socket) do
    x = String.to_integer(x)

    case Game.drop_token(socket.assigns.game, x, player_number(socket.assigns)) do
      {:ok, game} ->
        turn = new_turn(socket)
        send_game_updated(socket.assigns.room_id, game, turn)
        {:noreply, socket
         |> assign(game: game)
         |> assign(turn: turn)}
      {:error, :no_space} ->
        {:noreply, socket
          |> put_flash(:error, "No space in that column")}
    end
  end

  defp gen_player_id() do
    :crypto.strong_rand_bytes(3) |> Base.encode16(case: :lower)
  end

  defp player_number(assigns) do
    cond do
      assigns.player_id == assigns.player1 ->
        1
      true ->
        2
    end
  end
    
  defp cell_value(x, y, game) do
    Game.get_position(game, {x, y})
  end
end
