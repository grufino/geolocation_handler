defmodule GeolocationHandler.Geolocations do
  import Ecto.Query

  alias GeolocationHandler.Geolocations.Geolocation

  def geolocation_data_by_field_query(condition_field, value) do
    from(g in Geolocation,
      where: field(g, ^condition_field) == ^value
    )
  end

  def geolocation_by_ip_query(ip_address) do
    from(g in Geolocation,
      where: g.ip_address == ^ip_address
    )
  end

  def get_geolocations_by_field(condition_field, value, repo) do
    geolocation_data_by_field_query(condition_field, value)
    |> repo.all
  end

  def get_geolocation_by_ip(ip_address, repo) do
    geolocation_by_ip_query(ip_address)
    |> repo.one
  end
end
