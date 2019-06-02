defmodule GeolocationHandler.Geolocations.PersistStream do
  alias GeolocationHandler.Geolocations.Geolocation
  alias Ecto.Changeset

  def persist_and_generate_metadata(geolocation_stream, repo, chunk_size) do
    start_time = Timex.now()
    content_row_quantity = Enum.count(geolocation_stream)

    changesets = Stream.map(geolocation_stream, &validate/1)

    error_row_quantity =
      changesets
      |> Stream.filter(&(&1 == :error))
      |> Enum.count()

    changesets
    |> Stream.reject(&(&1 == :error))
    |> Stream.chunk_every(chunk_size)
    |> Stream.each(fn chunk -> insert_chunk(chunk, repo) end)
    |> Stream.run()

    {:ok,
     %{
       total_rows: content_row_quantity,
       valid_rows: content_row_quantity - error_row_quantity,
       invalid_rows: error_row_quantity,
       elapsed_time_seconds: Timex.diff(Timex.now(), start_time, :seconds)
     }}
  end

  defp validate(
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
      %Changeset{valid?: true, changes: casted_attrs} ->
        casted_attrs

      _ ->
        :error
    end
  end

  defp validate({:error, _}), do: :error

  def insert_chunk(geolocation_chunk, repo) do
    repo.insert_all(Geolocation, geolocation_chunk, on_conflict: :nothing)
  end
end
