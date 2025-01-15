defmodule Honey.Ethhdr do
  alias Honey.ElixirType

  def init() do
    ElixirType.type_invalid()
  end

  def const_udp() do
    ElixirType.type_integer()
  end

  def ip_protocol() do
    ElixirType.type_integer()
  end

  def destination_port() do
    ElixirType.type_integer()
  end

  def set_destination_port(_dest_port) do
    ElixirType.type_integer()
  end

  def h_source() do
    ElixirType.type_void()
  end
end
