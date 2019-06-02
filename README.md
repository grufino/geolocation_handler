# GeolocationHandler

# Usage

This library offers a CSV import process with basic error treatment and data validations, and requires a database (Ecto.Repo) to be passed in order to persist the data in the database, example usage:
```
iex(2)> GeolocationHandler.Csv.Import.import_file("data_dump.csv", GeolocationApi.Repo)

23:30:14.530 [info]  Loading file: "data_dump.csv"

{:ok,
 %{
   elapsed_time_seconds: 180,
   invalid_rows: 84027,
   total_rows: 1000000,
   valid_rows: 915973
 }}
```

The library also provides two ways to query the data, also requiring the repository to be passed as argument:

Get specific record by ip:

iex(1)> GeolocationHandler.Geolocations.get_geolocation_by_ip("31.185.249.104", GeolocationApi.Repo)
%GeolocationHandler.Geolocations.Geolocation{
  __meta__: #Ecto.Schema.Metadata<:loaded, "geolocations">,
  city: "New Rodrick",
  country: "Swaziland",
  country_code: "TJ",
  ip_address: "31.185.249.104",
  latitude: -9.819692971081892,
  longitude: 48.19629305170949,
  mystery_value: 4150731611
}

Get set of records by preferred field:

iex(1)> GeolocationHandler.Geolocations.get_geolocations_by_field(:country, "Brazil", GeolocationApi.Repo)
[
  %GeolocationHandler.Geolocations.Geolocation{
    __meta__: #Ecto.Schema.Metadata<:loaded, "geolocations">,
    city: "Teagantown",
    country: "Brazil",
    country_code: "AF",
    ip_address: "146.28.225.119",
    latitude: 41.6025356534943,
    longitude: -73.88706674873318,
    mystery_value: 7286756817
  },
  %GeolocationHandler.Geolocations.Geolocation{
    __meta__: #Ecto.Schema.Metadata<:loaded, "geolocations">,
    city: "New Stacymouth",
    country: "Brazil",
    country_code: "ME",
    ip_address: "193.250.218.149",
    latitude: -13.657978651259668,
    longitude: 10.79200975652148,
    mystery_value: 2376021209
  } ... ]

# Requirements

- A working database properly configured as Ecto Repo
- Table geolocations created with that respects the contract defined in GeolocationHandler.Geolocations.Geolocation schema.

# Architectural / Design decisions

- Geolocations context represents Domain Drive Design for the data input and necessary behaviour
- The repository module to be used must contain a configured database and be provided by the client application of this library
- Database layer validations and tests are not implemented in this library, only unit tests that do not require persistency were implemented in order to not require mocking a database.
- Instead of configuring a database, that would have to be supervised by the library and therefore require a supervision tree and an otp application, it was chosen to pass the database (or Repo), in a dependency injection fashion, for when the library has to interact with database. This removes unnecessary complexity from the library and allows for the application that will use it to manage the database alone, while allowing the library to operate SQL anyway, without even knowing which type of database or adapter is being used. Although, as a trade-off it also demands that the contract that the library uses to operate the database is never broken (for example if in the future the function Repo.insert_all/3 changes, it could break the library), but I think this is a minor trade-off in this case considering that the library has Ecto's version as a dependency and therefore can guarantee that the function still exists through it. This approach is recommended by Elixir's official library guidelines: https://hexdocs.pm/elixir/master/library-guidelines.html#avoid-application-configuration

# Assumptions about Geolocations data structure:

- All fields are required
- Mystery_value should be > 0
- Ip address is primary key of the table, which implies that duplicated entries will be validated through it, in the database layer (which is not validated in this library, and therefore duplicated items are not included in metadata invalid_rows field), this allows much more performance and consistency as it is automatically validated and indexed by the database which is highly optimized for this kind of operation. 
- First valid data set will be inserted and if there is any duplicated valid one (with same ip address), first inserted will remain

# Other considerations and thoughts

- For performance improvement, libraries with back-pressure systems like Flow/GenStage could be used, but it would require also benchmarking and experimenting.
- For even more consistency and completeness, this library could provide a custom mix task that generates the necessary migration according to the schema in the api that is using it, but I decided to create the migration directly in the api to save time.
- I do not think it is a good idea to add a database layer dependency to a library unless unavoidable, I would see a better fit for this library to check the data consistency and parse the CSV file as much as possible, and even build querys too, but leave for the actual owner of the database to send the requests, because allows more flexibility in case different use cases appear.

