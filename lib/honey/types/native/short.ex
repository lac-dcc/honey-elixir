defmodule Honey.CNativeType.Short do
  defstruct []
  alias Honey.CExpr
  alias Honey.CExpr.Utils
  alias Honey.CNativeType.{Short, Int, Long}

  def op(:+, rep_1, %Short{}, rep2) do
    {Short.new(), "#{rep_1} + #{rep2}"}
  end

  def op(:+, rep_1, %Int{}, rep2) do
    {Int.new(), "#{rep_1} + #{rep2}"}
  end

  def op(:+, rep_1, %Long{}, rep2) do
    {Long.new(), "#{rep_1} + #{rep2}"}
  end

  def op(:-, rep_1, %Short{}, rep2) do
    {Short.new(), "#{rep_1} - #{rep2}"}
  end

  def op(:-, rep_1, %Int{}, rep2) do
    {Int.new(), "#{rep_1} - #{rep2}"}
  end

  def op(:-, rep_1, %Long{}, rep2) do
    {Long.new(), "#{rep_1} - #{rep2}"}
  end

  def op(:*, rep_1, %Short{}, rep2) do
    {Short.new(), "#{rep_1} * #{rep2}"}
  end

  def op(:*, rep_1, %Int{}, rep2) do
    {Int.new(), "#{rep_1} * #{rep2}"}
  end

  def op(:*, rep_1, %Long{}, rep2) do
    {Long.new(), "#{rep_1} * #{rep2}"}
  end

  def op(:/, rep_1, %Short{}, rep2) do
    {Int.new(), "#{rep_1} / #{rep2}"}
  end

  def op(:/, rep_1, %Int{}, rep2) do
    {Int.new(), "#{rep_1} / #{rep2}"}
  end

  def op(:/, rep_1, %Long{}, rep2) do
    {Long.new(), "#{rep_1} / #{rep2}"}
  end

  def op(operator, _rep1, type, _rep2) do
    Utils.operator_not_defined_error!(__MODULE__, operator, type.__struct__)
  end

  defimpl Honey.CType do
    def get_type_definition_str(_) do
      "int"
    end

    def op(_, operator, value1, value2) do
      repr1 = CExpr.get_c_representation(value1)
      repr2 = CExpr.get_c_representation(value2)
      type2 = CExpr.get_type(value2)

      Int.op(operator, repr1, type2, repr2)
    end
  end

  def new() do
    %Int{}
  end
end