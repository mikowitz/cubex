defmodule Cubex.Solver do
  alias Cubex.Solver.{Cross, LowerCorners, LowerLayers,
    TopEdges, TopCorners, PositionTopCorners, PositionTopEdges}

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
    Enum.reduce(@steps, {cube, []}, &apply(&1, :solve, [&2]))
  end
end
