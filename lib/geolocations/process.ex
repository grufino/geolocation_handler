defmodule GeolocationHandler.CsvParser.Process do
  alias GeolocationHandler.Geolocations.{LoadCsv, Persist}

  def process_file(file_path, repo) do
    {:ok, content_stream} = LoadCsv.load_and_validate(file_path)

    Persist.persist_and_generate_metadata(content_stream, repo)
  end
end
