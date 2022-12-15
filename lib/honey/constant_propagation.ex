defmodule Honey.ConstantPropagation do
  import Honey.Utils, only: [var_to_string: 1, is_var: 1]

  @moduledoc """
  Executes Constant Propagation optimization in the elixir AST of the source program.
  """

  @doc """
  Guard for constant values.
  More specifically: Numbers, bitstrings, atoms, binaries, booleans or nil.
  """

  defguard is_constant(item)
           when is_number(item) or
                  is_bitstring(item) or
                  is_atom(item) or
                  is_binary(item) or
                  is_boolean(item) or
                  is_nil(item)

  @doc """
  Runs the constant propagation optimization given an elixir AST.
  """

  def run(ast) do
    #Does a postwalk substituting known values for their constants.
    Macro.postwalk(ast, [], fn segment, constants ->
      case segment do
        #An atribution with a constant right hand side has a constant left side. Add the LHS variable as a constant.
        {:=, _meta, [lhs, rhs]} when is_constant(rhs) ->
          var_version = String.to_atom(var_to_string(lhs))
          constants = Keyword.put(constants, var_version, rhs)
          {rhs, constants}

        #A binary operation with two constants is a constant.
        {{:., _, [:erlang, :+]}, _, [lhs, rhs]} when is_constant(lhs) and is_constant(rhs) ->
          {lhs + rhs, constants}

        {{:., _, [:erlang, :-]}, _, [lhs, rhs]} when is_constant(lhs) and is_constant(rhs) ->
          {lhs - rhs, constants}

        {{:., _, [:erlang, :*]}, _, [lhs, rhs]} when is_constant(lhs) and is_constant(rhs) ->
          {lhs * rhs, constants}

        {{:., _, [:erlang, :/]}, _, [lhs, rhs]} when is_constant(lhs) and is_constant(rhs) ->
          {lhs / rhs, constants}

        {{:., _, [:erlang, :==]}, _, [lhs, rhs]} when is_constant(lhs) and is_constant(rhs) ->
          {lhs == rhs, constants}

        #A variable that has been kept as a constant (from the := case) can be substituted by its value.
        var when is_var(var) ->
          var_version = String.to_atom(var_to_string(var))

          case Keyword.fetch(constants, var_version) do
            {:ok, const} ->
              {const, constants}

            :error ->
              {segment, constants}
          end
        #In any other case, keep segment and accumulator untouched.
        _ ->
          {segment, constants}
      end
    end)
    |> elem(0) #Return the ast without the accumulator.
  end
end
