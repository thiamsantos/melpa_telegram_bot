defmodule PackagesBot.Melpa.Packages do
  alias PackagesBot.Melpa.Client
  alias PackagesBot.Melpa.Packages.{Loader, Package}
  alias PackagesBot.{CurrentTime, Repo}

  def renew_packages do
    Client.archive()
    |> parse_packages()
    |> insert_all_packages()
  end

  def renew_download_counts do
    Client.download_counts()
    |> parse_download_counts()
    |> insert_all_download_counts()
  end

  defdelegate search_package(pattern), to: Loader

  defp parse_packages({:error, reason}), do: {:error, reason}

  defp parse_packages({:ok, raw_packages}) do
    packages =
      Enum.map(raw_packages, fn {name, meta} ->
        %{
          name: name,
          description: Map.get(meta, "desc"),
          recipe: "https://github.com/melpa/melpa/blob/master/recipes/#{name}",
          homepage: get_in(meta, [Access.key("props", %{}), "url"]),
          inserted_at: CurrentTime.naive_now(),
          updated_at: CurrentTime.naive_now()
        }
      end)

    {:ok, packages}
  end

  defp parse_download_counts({:error, reason}), do: {:error, reason}

  defp parse_download_counts({:ok, raw_download_counts}) do
    download_counts =
      Enum.map(raw_download_counts, fn {name, total_downloads} ->
        %{
          name: name,
          recipe: "https://github.com/melpa/melpa/blob/master/recipes/#{name}",
          total_downloads: total_downloads,
          inserted_at: CurrentTime.naive_now(),
          updated_at: CurrentTime.naive_now()
        }
      end)

    {:ok, download_counts}
  end

  defp insert_all_packages({:error, reason}), do: {:error, reason}

  defp insert_all_packages({:ok, packages}) do
    {entries, _result} =
      Repo.insert_all(Package, packages,
        conflict_target: :name,
        on_conflict: {:replace, [:description, :recipe, :homepage, :updated_at]}
      )

    {:ok, entries}
  end

  defp insert_all_download_counts({:error, reason}), do: {:error, reason}

  defp insert_all_download_counts({:ok, download_counts}) do
    {entries, _result} =
      Repo.insert_all(Package, download_counts,
        conflict_target: :name,
        on_conflict: {:replace, [:recipe, :total_downloads, :updated_at]}
      )

    {:ok, entries}
  end
end
