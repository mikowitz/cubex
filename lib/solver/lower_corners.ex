defmodule Cubex.Solver.LowerCorners do
  @solved ~w(UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)

  @fr "DFR"
  @fl "DFL"
  @bl "BDL"
  @br "BDR"

  import Cube.Helpers

  def solve({cube, _} = set) do
    case solved?(cube) do
      true -> set
      false -> _solve(set)
    end
  end

  defp _solve({cube, _} = set) do
    cond do
      corner_at?(cube, 12) -> position_top_front_right(set) |> solve
      corner_at?(cube, 13) -> position_top_right_back(set) |> solve
      corner_at?(cube, 14) -> position_top_back_left(set) |> solve
      corner_at?(cube, 15) -> position_top_left_front(set) |> solve
      wrong_corner_at?(cube, 16) -> move_up(set, "f") |> solve
      wrong_corner_at?(cube, 17) -> move_up(set, "l") |> solve
      wrong_corner_at?(cube, 18) -> move_up(set, "b") |> solve
      wrong_corner_at?(cube, 19) -> move_up(set, "r") |> solve
      true -> {:error, :bad_cube, cube}
    end
  end

  def position_from_top_corner({cube, _} = set, index, face) do
    functions = ["", "_left", "_across", "_right"] |> rotate(face_index(face))
    {suffix, _} = Enum.zip(functions, [@fr, @fl, @bl, @br]) |> Enum.find(fn {_, corner} ->
      sort_cubie(Enum.at(cube, index)) == corner
    end)
    apply(__MODULE__, :"move_down#{suffix}", [set, face])
  end

  def position_top_front_right(set), do: position_from_top_corner(set, 12, "f")
  def position_top_right_back(set), do: position_from_top_corner(set, 13, "r")
  def position_top_back_left(set), do: position_from_top_corner(set, 14, "b")
  def position_top_left_front(set), do: position_from_top_corner(set, 15, "l")

  defp move_up(set, face), do: make_moves(set, "r u' r'", face)

  def move_down(set, face), do: make_moves(set, "r u r'", face)
  def move_down_right(set, face), do: make_moves(set, "b u' b'", face)
  def move_down_across(set, face), do: make_moves(set, "l u2 l'", face)
  def move_down_left(set, face), do: make_moves(set, "l' u l", face)

  def corner_at?(cube, index) do
    cubie = Enum.at(cube, index)
    Enum.member?([@fr, @fl, @bl, @br], sort_cubie(cubie))
  end

  def wrong_corner_at?(cube, index) do
    corner_at?(cube, index) &&
      sort_cubie(Enum.at(cube, index)) != sort_cubie(Enum.at(@solved, index))
  end

  def solved?(cube) do
    Enum.slice(cube, 16, 4) |> Enum.map(&sort_cubie/1) == ~w(DFR DFL BDL BDR) &&
      Enum.slice(cube, 4,4) == ~w(DF DR DB DL)
  end
end
