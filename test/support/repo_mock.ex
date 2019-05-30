defmodule GeolocationHandler.RepoMock do
  @behaviour Ecto.Repo

  alias GeolocationHandler.Geolocations.Geolocation

  @impl true
  def insert_all(Geolocation, _entries, _opts \\ []) do
    {4, nil}
  end
end
