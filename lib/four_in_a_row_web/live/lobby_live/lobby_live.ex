defmodule FourInARowWeb.LobbyLive do
  use FourInARowWeb, :live_view

  @impl true
  def handle_event("generate-room", _params, socket) do
    name = AnonymousNameGenerator.generate_random()
    dbg(name)
    {:noreply, socket |> push_navigate(to: ~p"/room/#{name}")}
  end
end
