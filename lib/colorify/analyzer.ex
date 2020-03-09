defmodule Colorify.Analyzer do
  def analyze(url, limit \\ 5)
  def analyze(nil, _limit), do: %{}
  def analyze(url, limit) do
    url
    |> temp_file_from_url()
    |> Mogrify.open()
    |> Mogrify.histogram()
    |> Enum.sort(fn a, b -> a["count"] > b["count"] end)
    |> Enum.take(limit)
  end

  defp temp_file_from_url(nil), do: nil
  defp temp_file_from_url(url) do
    temp_file_name = :crypto.hash(:md5, url) |> Base.encode16()
    Application.ensure_all_started(:inets)
    :ssl.start()
    {:ok, resp} = :httpc.request(:get, {String.to_charlist(url), []}, [], body_format: :binary)
    {{_, 200, 'OK'}, _headers, body} = resp
    File.write!("/tmp/" <> temp_file_name, body)
    "/tmp/" <> temp_file_name
  end
end
