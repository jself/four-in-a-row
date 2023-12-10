import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :four_in_a_row, FourInARowWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "a8RuX+81zQBQfYYsvIpDFJPM2B0YPGe2mvsWsj1nZHAJs0NCd95drhzt+tXWEzL2",
  server: false

# In test we don't send emails.
config :four_in_a_row, FourInARow.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
