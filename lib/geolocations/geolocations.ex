defmodule GeolocationHandler.Geolocations do
  import Ecto.Query

  alias GeolocationHandler.Geolocations.Geolocation

  def geolocation_data_by_field_query!(contition_field, value, []) do
    from(g in Geolocation,
      where: field(g, ^contition_field) == ^value
    )
  end

  def geolocation_data_by_field_query!(contition_field, value, fields_wanted) do
    from(g in Geolocation,
      where: field(g, ^contition_field) == ^value,
      select: ^fields_wanted
    )
  end

  def geolocation_by_ip_query!(ip_address) do
    from(g in Geolocation,
      where: g.ip_address == ^ip_address
    )
  end

  def get_all_from_query!(query, repo) do
    query
    |> repo.all!
  end

  def get_one_from_query!(query, repo) do
    query
    |> repo.one!
  end
end
