defmodule WhosInBot.Release do
  @moduledoc false

  alias WhosInBot.Repo
  alias Ecto.Migrator

  def migrate do
    load_app()

    path = Application.app_dir(:whos_in_bot, "priv/repo/migrations")
    Migrator.run(Repo, path, :up, all: true)
  end

  defp load_app do
    Application.ensure_all_started(:whos_in_bot)
  end
end
