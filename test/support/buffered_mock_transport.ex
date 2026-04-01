defmodule BufferedMockTransport do
  @moduledoc """
  A mock transport that delegates parse/encode to STDIO (for buffering)
  but stubs the GenServer behaviour. Used to test chunked STDIO responses.
  """
  @behaviour Anubis.Transport
  @behaviour Anubis.Transport.Behaviour

  defdelegate transport_init(opts \\ []), to: Anubis.Transport.STDIO
  defdelegate parse(raw, state), to: Anubis.Transport.STDIO
  defdelegate encode(message, state), to: Anubis.Transport.STDIO
  defdelegate extract_metadata(raw, state), to: Anubis.Transport.STDIO

  @impl Anubis.Transport.Behaviour
  def start_link(_opts), do: {:ok, self()}

  @impl Anubis.Transport.Behaviour
  def send_message(_, _, _opts \\ [timeout: 1_000]), do: :ok

  @impl Anubis.Transport.Behaviour
  def shutdown(_), do: :ok

  @impl Anubis.Transport.Behaviour
  def supported_protocol_versions, do: :all
end
