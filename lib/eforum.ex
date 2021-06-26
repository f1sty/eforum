defmodule Eforum do
  @forum_url "https://elixirforum.com"

  def retreive(url \\ @forum_url) do
    url
    |> get()
    |> parse()
    |> get_topics()
    |> display()
  end

  defp get(url) do
    {:ok, response} =
      :get
      |> Finch.build(url)
      |> Finch.request(Crawler)

    response
  end

  defp parse(%Finch.Response{body: body, status: 200}) do
    body
    |> Floki.parse_document!()
    |> Floki.find("tbody tr a.title")
  end

  defp parse(%Finch.Response{status: status}) do
    {:error, "Error: status #{status}"}
  end

  defp get_topics({:error, message}) do
    [message]
  end

  defp get_topics(topics) do
    Enum.flat_map(topics, fn {_tag, _attrs, topic} -> topic end)
  end

  defp display(topics) do
    Enum.each(topics, &IO.puts/1)
  end
end
