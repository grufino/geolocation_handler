defmodule GeolocationHandler.CsvParser.Persist do
  alias GeolocationHandler.Geolocation

  def persist_and_generate_metadata(geolocation_stream) do
    geolocation_stream
    |> Stream.map(&put_on_changeset/1)
    |> Enum.map(&IO.inspect/1)
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
    %Geolocation{}
    |> Geolocation.changeset(%{
      ip_address: ip_address,
      country_code: country_code,
      country: country,
      city: city,
      latitude: latitude,
      longitude: longitude,
      mystery_value: mystery_value
    })
  end
end
