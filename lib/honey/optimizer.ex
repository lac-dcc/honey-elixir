defmodule Honey.Optimizer do
  @moduledoc """
  Module to define and run the optimization pipeline that runs over elixirs AST.
  """
  alias Honey.{ConstantPropagation, DCE, Analyze, TypePropagation}

  @doc """
  Runs the optimization and analysis steps.
  """
  def run(fun_def, arguments, env) do
    fun_def
    |> Analyze.run()
    |> ConstantPropagation.run()
    |> DCE.run()
    |> TypePropagation.run(arguments, env)

    # |> AstSize.output(env, " - Final")
    # |> IO.inspect()
  end
end
