defmodule Cubex.Solver do
  @steps [
    Cross,
    LowerCorners,
    LowerLayers,
    TopEdges,
    TopCorners,
    PositionTopCorners,
    PositionTopEdges
  ]

  def solve(cube) do
    Enum.reduce(@steps, {cube, []}, fn step, set ->
      step |> to_module |> apply(:solve, [set])
    end)
  end

  def to_module(step) do
    Module.safe_concat(__MODULE__, step)
  end
end
