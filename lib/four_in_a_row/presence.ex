defmodule FourInARow.Presence do
  use Phoenix.Presence,
    otp_app: :four_in_a_row,
    pubsub_server: FourInARow.PubSub
end
