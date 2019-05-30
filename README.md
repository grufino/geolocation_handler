# GeolocationHandler

# Architectural / Design decisions

- Geolocations context represents Domain Drive Design for the data input and necessary behaviour
- The repository module to be used must contain a configured database and be provided by the client application of this library
- Database layer validations and tests are not implemented in this library, only unit tests that do not require persistency were implemented in order to not require mocking a database.
- This library currently only supports Postgres database, in order to not overcomplicate configuration and increase complexity.

# Assumptions about Geolocations data structure:

- All fields are required
- Mystery_value should be > 0
- Ip address is primary key of the table, which implies that duplicated entries will be validated through it, in database layer (which is not covered in this library)
- First valid data set will be inserted and if there is any duplicated valid one, first inserted will remain


