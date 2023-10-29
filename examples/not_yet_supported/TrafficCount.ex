defmodule TrafficCount do
  use Honey, license: "Dual BSD/GPL"

  defmap( # Defines an eBPF map of the BPF_MAP_TYPE_HASH with 64 entries
    :TrafficCount,
    %{type: BPF_MAP_TYPE_HASH, max_entries: 64, print: true}
  )

  @sec "xdp_md"
  def main(ctx) do
    Honey.Ethhdr.init() #Should only be called once!
    src = Honey.Ethhdr.h_source() #Returns a void* to h_source. Maybe should have unique representation?
    
    count = Honey.Bpf_helpers.bpf_map_lookup_elem(:TrafficCount, src)
    count = count + 1

    Honey.Bpf_helpers.bpf_map_update_elem(:TrafficCount, src, count)
    
  end
end
