defmodule FourInARowWeb.LobbyLive do
  # this is the live view for the lobby
  # Currently only allows generating a private room
  
  use FourInARowWeb, :live_view
  require Namor

  @impl true
  def handle_event("generate-room", _params, socket) do
    {:ok, name} = Namor.generate()
    {:noreply, socket |> push_navigate(to: ~p"/room/#{name}")}
  end
end
