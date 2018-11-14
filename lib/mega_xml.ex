defmodule MegaXml do
  @chunk 10000

  def parse(bin) do
    {:ok, pid} = StringIO.open(bin)
    # IO.binstream(pid, @chunk)
    {:ok, result, _tail} = run_with_handle(pid, :stringio)
    StringIO.close(pid)
    result
  end

  def run(path) do
    {:ok, handle} = File.open(path, [:binary])
    {:ok, result, _tail} = run_with_handle(handle, :file)
    :ok = File.close(handle)
    result
  end

  defp run_with_handle(handle, :file) when is_pid(handle) do
    do_run_with_handle(handle, &continue_file/2)
  end

  defp run_with_handle(handle, :stringio) when is_pid(handle) do
    do_run_with_handle(handle, &continue_io/2)
  end

  defp do_run_with_handle(handle, continuation_function) do
    position = 0
    c_state = {handle, position, @chunk}

    :erlsom.parse_sax(
      "",
      %{},
      &sax_event_handler/2,
      [{:continuation_function, continuation_function, c_state}]
    )
  end

  defp continue_file(tail, {handle, offset, chunk}) do
    case :file.pread(handle, offset, chunk) do
      {:ok, data} ->
        {<<tail::binary, data::binary>>, {handle, offset + chunk, chunk}}

      :oef ->
        {tail, {handle, offset, chunk}}
    end
  end

  defp continue_io(tail, {handle, offset, chunk}) do
    case IO.read(handle, chunk) do
      bin when is_binary(bin) ->
        {<<tail::binary, bin::binary>>, {handle, offset + chunk, chunk}}

      :eof ->
        {tail, {handle, offset, chunk}}

      {:error, reason} ->
        raise "Problem reading IO. Reason: #{reason}"

      _ ->
        {tail, {handle, offset, chunk}}
    end
  end

  def all_uniq?(enum) do
    Enum.reduce_while(enum, %{}, fn x, acc ->
      if acc[x] do
        {:halt, false}
      else
        {:cont, Map.put(acc, x, true)}
      end
    end)
  end

  defp map_erlsom_attribs_to_map(attribs) when is_list(attribs) do
    attribs
    |> Enum.map(fn {:attribute, name, prefix, _, val} ->
      {combine_prefix_and_element_name(prefix, name), val}
    end)
    |> Map.new()
  end

  defp combine_prefix_and_element_name(prefix, name) do
    if prefix && prefix != [] do
      # note that prefix AND name here are charlists and not binaries
      # due to erlsom being erlang and all...
      # Elixir interpolation does the right thing though...
      "#{prefix}:#{name}"
    else
      "#{name}"
    end
  end

  def sax_event_handler(:startDocument, _state) do
    # the initial state of the stack
    [%{root: %{vals: []}}]
  end

  def sax_event_handler({:startElement, _, element_name, prefix, attribs}, stack) do
    element_name = combine_prefix_and_element_name(prefix, element_name)
    attribs = map_erlsom_attribs_to_map(attribs)

    new_node = %{
      element_name =>
        if attribs != %{} do
          %{attribs: attribs, vals: []}
        else
          %{vals: []}
        end
    }

    [new_node | stack]
  end

  def sax_event_handler({:characters, value}, [car | cdr] = stack) do
    if is_binary(car) do
      [car <> to_string(value) | cdr]
    else
      [to_string(value) | stack]
    end
  end

  def sax_event_handler({:ignorableWhitespace, _chars}, state) do
    state
  end

  def sax_event_handler({:endElement, _, element_name, prefix}, [car | cdr] = stack) do
    element_name = combine_prefix_and_element_name(prefix, element_name)
    # element at top of stack must be the same
    # first pull out any character values at top of stack
    # and strip out any whitespace at beginning or end
    {stack, text_val} =
      if is_binary(car) do
        {cdr, String.trim(car)}
      else
        {stack, nil}
      end

    # next, pull out the node at the top of the stack and check if it matches namewise
    [car | cdr] = stack
    # this should match
    %{^element_name => ele_parts} = car
    # push any top-of-stack text value to the val array on this node
    ele_parts =
      if text_val do
        Map.put(ele_parts, :vals, [text_val | ele_parts.vals])
      else
        ele_parts
      end

    # if the val is just ["sometext"] and no attributes then just set it equal to that text
    # if the val is just [%{somemap}] and no attributes then just set it equal to that map
    # You could do even more simplification such as converting something like this
    # <base><thing>1</thing><other>2</other></base>
    # into something like
    # %{"base" => %{"thing" => "1", "other" => "2"}}
    # after ensuring unique keys on all the submaps,
    # but I'll leave that for a later date
    # EDIT: I added it, it works. That code begins with this clause: %{vals: [_head | _tail] = multi} ->
    ele_parts =
      unless ele_parts[:attribs] do
        case ele_parts do
          %{vals: []} ->
            nil

          %{vals: [single_text_value]} when is_binary(single_text_value) ->
            single_text_value

          %{vals: [map]} when is_map(map) ->
            map

          %{vals: [_head | _tail] = multi} ->
            if multi |> Enum.map(fn x -> x |> Map.keys() |> List.first() end) |> all_uniq? do
              multi |> Enum.reduce(%{}, fn x, acc -> Map.merge(acc, x) end)
            else
              ele_parts
            end

          _ ->
            ele_parts
        end
      else
        ele_parts
      end

    struct = %{element_name => ele_parts}
    # popped!
    stack = cdr
    [prev_element | remainder] = stack
    prev_element_name = Map.keys(prev_element) |> List.first()
    prev_element_val = Map.values(prev_element) |> List.first()
    # set the new struct equal to this node with the vals pointing to the old struct
    prev_element_val = Map.put(prev_element_val, :vals, [struct | prev_element_val.vals])
    prev_element = Map.put(prev_element, prev_element_name, prev_element_val)
    [prev_element | remainder]
  end

  def sax_event_handler(:endDocument, state) do
    List.first(state).root.vals |> List.first()
  end

  def sax_event_handler(_, state) do
    state
  end
end
