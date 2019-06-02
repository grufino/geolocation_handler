defmodule GeolocationHandler.Geolocations.Geolocation do
  use Ecto.Schema
  import Ecto.Changeset

  @field_list ~w(ip_address country_code country city latitude longitude mystery_value)a

  @primary_key {:ip_address, :string, []}
  schema "geolocations" do
    field(:country_code, :string)
    field(:country, :string)
    field(:city, :string)
    field(:latitude, :float)
    field(:longitude, :float)
    field(:mystery_value, :integer)
  end

  @doc false
  def changeset(%__MODULE__{} = geolocation, attrs) do
    geolocation
    |> cast(attrs, @field_list)
    |> validate_required(@field_list)
    |> validate_length(:country_code, min: 2, max: 2)
    |> validate_number(:mystery_value, greater_than: 0)
    |> unique_constraint(:ip_address, name: "geolocations_pkey")
  end

  def get_field_list(), do: @field_list
end
