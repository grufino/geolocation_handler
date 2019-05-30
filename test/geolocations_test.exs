defmodule GeolocationsTest do
  use ExUnit.Case

  alias GeolocationHandler.Geolocations

  test "geolocation_by_ip_query/1" do
    assert %Ecto.Query{} = Geolocations.geolocation_by_ip_query!("fake_ip")
  end

  test "geolocation_data_by_field_query/1 ip address field only" do
    assert %Ecto.Query{select: fields} =
             Geolocations.geolocation_data_by_field_query!(:country, "Brazil", [:ip_address])
  end

  test "geolocation_data_by_field_query/1 all fields" do
    assert %Ecto.Query{} = Geolocations.geolocation_data_by_field_query!(:country, "Brazil", [])
  end
end
