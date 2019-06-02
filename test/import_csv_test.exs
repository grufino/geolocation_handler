defmodule ImportTest do
  use ExUnit.Case

  alias GeolocationHandler.Csv.Import
  alias GeolocationHandler.RepoMock

  test "whole process with mock file" do
    assert assert {:ok,
                   %{
                     elapsed_time_seconds: 0,
                     invalid_rows: 1,
                     total_rows: 5,
                     valid_rows: 4
                   }} = Import.import_file("test/support/fixtures/example.csv", RepoMock)
  end

  test "invalid file input" do
    assert Import.import_file("unexisting", RepoMock) ==
             {:error, :invalid_file, :enoent}
  end

  test "invalid header" do
    assert Import.import_file("test/support/fixtures/invalid_header.csv", RepoMock) ==
             {:error, :invalid_file, :incompatible_header}
  end
end
