defmodule GeolocationHandler.Geolocations.Persist do
  alias GeolocationHandler.Geolocations.Geolocation

  def persist_and_generate_metadata(geolocation_stream, repo) do
    content_row_quantity = Enum.count(geolocation_stream)

    geolocation_stream
    |> Stream.map(&put_on_changeset/1)
    |> Stream.map(fn changeset -> insert_valid(changeset, repo) end)
  end

  defp put_on_changeset(
         {:ok,
          [
            ip_address,
            country_code,
            country,
            city,
            latitude,
            longitude,
            mystery_value
          ]}
       ) do
    Geolocation.changeset(%Geolocation{}, %{
      ip_address: ip_address,
      country_code: country_code,
      country: country,
      city: city,
      latitude: latitude,
      longitude: longitude,
      mystery_value: mystery_value
    })
    |> case do
      %Ecto.Changeset{
        valid?: true
      } = changeset ->
        {:ok, changeset}

      _ ->
        :error
    end
  end

  defp put_on_changeset({:error, _}), do: :error

  defp insert_valid(:error, _repo), do: :error

  defp insert_valid(changeset, repo) do
    repo.insert(changeset)
  end
end
