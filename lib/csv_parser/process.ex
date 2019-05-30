defmodule GeolocationHandler.CsvParser.Process do
  alias GeolocationHandler.CsvParser.{Load, Persist}

  def process_file(file_path) do
    {:ok, content_stream} = Load.load_and_validate(file_path)

    Persist.persist_and_generate_metadata(content_stream)
  end
end
