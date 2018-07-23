defmodule Cube.SolverTest do
  use ExUnit.Case, async: true

  alias Cubex.Solver
  alias Cubex.Solver.Cross

  test "sc" do
    cube = Cube2.new()

    assert {cube, []} == Cross.solve({cube, []})

    cube = cube |> Cube2.f2

    {_, moves} = Cross.solve({cube, []})
    assert ["f2"] == moves
  end

  test "consistency" do
    solution = {
      ~w(UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR),
      ["f2", "u2 b2", "r2 u2 l2", "d2 l d2", "r u2 r'", "l u' l'", "r' u r",
       "l u' l'", "u", "u", "u b u' b' u' r' u r", "u'", "u'", "r u r' u' r u r'",
       "l u l' u' l u l'", "u", "u' l' u l u f u' f'", "f r u r' u' f'", "u", "u",
       "u", "r u r' u r u2 r'", "r b' r f2 r' b r f2 r2",
       "l2 r2 d l2 r2 u l r' f2 l2 r2 b2 l r'", "u", "u"]
    }
    cube = Cube2.turn(Cube2.new, "f2 f' u d2 b l2 b l2 u l' l2 u2 b2 u2 l2")
    assert Solver.solve(cube) == solution
  end
end
