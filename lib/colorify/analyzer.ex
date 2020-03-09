defmodule Colorify.Analyzer do
  def analyze(url, limit \\ 5) do
    url
    |> temp_file_from_url()
    |> Mogrify.open()
    |> Mogrify.histogram()
    |> Enum.sort(fn a, b -> a["count"] > b["count"] end)
    |> Enum.take(limit)
  end

  defp temp_file_from_url(url) do
    Application.ensure_all_started(:inets)
    :ssl.start()
    {:ok, resp} = :httpc.request(:get, {String.to_charlist(url), []}, [], body_format: :binary)
    {{_, 200, 'OK'}, _headers, body} = resp
    File.write!("/tmp/img", body)
    "/tmp/img"
  end
end
