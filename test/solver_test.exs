defmodule Cube.SolverTest do
  use ExUnit.Case, async: true

  alias Cube.Solver

  test "sc" do
    cube = Cube2.new()

    assert {cube, []} == Solver.solve_cross({cube, []})

    cube = cube |> Cube2.f2

    {_, moves} = Solver.solve_cross({cube, []})
    assert ["f2"] == moves
  end
end
