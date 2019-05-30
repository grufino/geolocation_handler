defmodule GeolocationHandler.Geolocations.ProcessCsv do
  alias GeolocationHandler.Geolocations.{LoadCsv, PersistStream}

  def process_file(file_path, repo) do
    with {:ok, content_stream} <- LoadCsv.load_and_validate(file_path) do
      PersistStream.persist_and_generate_metadata(content_stream, repo)
    else
      error -> error
    end
  end
end
