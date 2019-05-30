defmodule ProcessCsvTest do
  use ExUnit.Case

  alias GeolocationHandler.Geolocations.ProcessCsv
  alias GeolocationHandler.RepoMock

  test "whole process with mock file" do
    assert assert {:ok, %{invalid_rows: 1, total_rows: 5, valid_rows: 4, elapsed_time: _seconds}} =
                    ProcessCsv.process_file("test/support/fixtures/example.csv", RepoMock)
  end

  test "invalid file input" do
    assert ProcessCsv.process_file("unexisting", RepoMock) ==
             {:error, :invalid_file, :enoent}
  end

  test "invalid header" do
    assert ProcessCsv.process_file("test/support/fixtures/invalid_header.csv", RepoMock) ==
             {:error, :invalid_file, :incompatible_header}
  end
end
