defmodule SchemaTest do
  use ExUnit.Case

  alias GeolocationHandler.Geolocations.Geolocation

  test "valid_changeset" do
    assert %Ecto.Changeset{valid?: true} =
             Geolocation.changeset(%Geolocation{}, %{
               ip_address: "127.0.0.1",
               country_code: "BR",
               country: "Brazil",
               city: "Sao Paulo",
               latitude: "1.234",
               longitude: "1.456",
               mystery_value: "123456"
             })
  end

  test "invalid changeset country code invalid length" do
    assert %Ecto.Changeset{
             valid?: false,
             errors: [
               country_code: _
             ]
           } =
             Geolocation.changeset(%Geolocation{}, %{
               ip_address: "127.0.0.1",
               country_code: "BRa",
               country: "Brazil",
               city: "Sao Paulo",
               latitude: "1.234",
               longitude: "1.456",
               mystery_value: "123456"
             })
  end

  test "invalid changeset mystery value 0" do
    assert %Ecto.Changeset{
             valid?: false,
             errors: [
               mystery_value: _
             ]
           } =
             Geolocation.changeset(%Geolocation{}, %{
               ip_address: "127.0.0.1",
               country_code: "BR",
               country: "Brazil",
               city: "Sao Paulo",
               latitude: "1.234",
               longitude: "1.456",
               mystery_value: "0"
             })
  end

  test "invalid changeset non number latitude" do
    assert %Ecto.Changeset{
             valid?: false,
             errors: [
               latitude: _
             ]
           } =
             Geolocation.changeset(%Geolocation{}, %{
               ip_address: "127.0.0.1",
               country_code: "BR",
               country: "Brazil",
               city: "Sao Paulo",
               latitude: "aaa",
               longitude: "1.456",
               mystery_value: "1"
             })
  end

  test "invalid changeset missing city field" do
    assert %Ecto.Changeset{
             valid?: false,
             errors: [
               city: _
             ]
           } =
             Geolocation.changeset(%Geolocation{}, %{
               ip_address: "127.0.0.1",
               country_code: "BR",
               country: "Brazil",
               latitude: "1.2",
               longitude: "1.456",
               mystery_value: "1"
             })
  end
end
