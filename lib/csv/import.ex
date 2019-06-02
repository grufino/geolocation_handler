defmodule GeolocationHandler.Csv.Import do
  alias GeolocationHandler.Geolocations.{PersistStream}
  alias GeolocationHandler.Csv.{Load}

  def import_file(file_path, repo, chunk_size \\ 5000) do
    with {:ok, content_stream} <- Load.load_and_validate(file_path) do
      PersistStream.persist_and_generate_metadata(content_stream, repo, chunk_size)
    else
      error -> error
    end
  end
end
