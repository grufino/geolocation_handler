defmodule GeolocationHandler.Csv.Load do
  require Logger

  @moduledoc """
  Module responsible for validating the file, header and loading it in form of stream without header
  """

  alias GeolocationHandler.Geolocations.Geolocation

  def load_and_validate(file_path) do
    Logger.info("Loading file: #{inspect(file_path)}")

    with {:ok, _metadata} <- File.stat(file_path),
         {:ok, content_stream} <- validate_and_remove_header(file_path) do
      {:ok, content_stream}
    else
      {:error, error_message} ->
        {:error, :invalid_file, error_message}
    end
  end

  defp validate_and_remove_header(filename) do
    file_stream =
      filename
      |> File.stream!()
      |> CSV.decode()

    field_string_list =
      Geolocation.get_field_list()
      |> Enum.map(&Atom.to_string/1)

    with {:ok, first_row} when first_row == field_string_list <- Enum.at(file_stream, 0) do
      {:ok, Stream.drop(file_stream, 1)}
    else
      _ -> {:error, :incompatible_header}
    end
  end

  def trim_and_split(row) do
    row
    |> String.trim()
    |> String.split(",")
  end
end
