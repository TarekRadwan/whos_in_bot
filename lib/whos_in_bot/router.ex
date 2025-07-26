defmodule WhosInBot.Router do
  use Plug.Router
  import Atom.Chars
  alias WhosInBot.{Repo, MessageHandler, Models}
  require Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["application/json"],
    json_decoder: Jason

  plug :match
  plug :dispatch

  # Health check endpoint
  get "/" do
    send_resp(conn, 200, "WhosInBot")
  end

  # Stats endpoint for internal checking
  get "/stats" do
    conn
    |> send_resp(200, """
    RollCalls: #{Repo.aggregate(Models.RollCall, :count, :id)}
    RollCallResponses: #{Repo.aggregate(Models.RollCallResponse, :count, :id)}
    """)
  end

  # Telegram webhook endpoint
  post "/" do
    message = Map.get(to_atom(conn.params), :message, %{})

    Logger.info("📥 Incoming Telegram message: #{inspect(message)}")

    case MessageHandler.handle_message(message) do
      {:ok, response} ->
        Logger.info("💬 Sending response: #{inspect(response)}")
        send_chat_response(message, response)

      error ->
        Logger.error("❌ Message handler failed or returned no response: #{inspect(error)}")
    end

    send_resp(conn, 200, "")
  end

  # Catch-all route
  match _ do
    send_resp(conn, 404, "WhosInBot: 404 - Page not found")
  end

  # Sends response back to Telegram user
  defp send_chat_response(%{chat: %{id: chat_id}}, response) when not is_nil(response) do
    Logger.info("✅ Sending Telegram message to chat_id #{chat_id}")
    Nadia.send_message(chat_id, response)
  end

  defp send_chat_response(_, _), do: Logger.warn("⚠️ Unable to send response: Invalid chat structure")
end
