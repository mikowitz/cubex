defmodule Solver.TopCorners do
  @sides ~w(f r b l)

  import Cube.Helpers

  def solve({cube, _} = set) do
    case oriented_corner_count(cube) do
      0 -> flip_all_corners(set)
      2 -> flip_two_corners(set)
      1 -> flip_three_corners(set)
      4 -> set
    end
  end

  def flip_all_corners({cube, _} = set) do
    case top_face_indices(cube) do
      [1, 2, 1, 2] -> make_moves(set, "r u2 r' u' r u r' u' r u' r'") |> solve
      [1, 2, 2, 1] -> make_moves(set, "r u2 r2 u' r2 u' r2 u2 r") |> solve
      _ -> make_moves(set, "u") |> solve
    end
  end

  def flip_two_corners({cube, _} = set) do
    case top_face_indices(cube) do
      [1, 0, 0, 2] -> make_moves(set, "r2 d r' u2 r d' r' u2 r'") |> solve
      [1, 2, 0, 0] -> make_moves(set, "r' f' l f r f' l' f") |> solve
      [0, 2, 0, 1] -> make_moves(set, "r' f' l' f r f' l f") |> solve
      _ -> make_moves(set, "u") |> solve
    end
  end

  def flip_three_corners({cube, _} = set) do
    case top_face_indices(cube) do
      [1, 1, 1, 0] -> make_moves(set, "r u r' u r u2 r'")
      [2, 0, 2, 2] -> make_moves(set, "r u2 r' u' r u' r'")
      _ -> make_moves(set, "u") |> solve
    end
  end

  def top_face_indices(cube) do
    Enum.slice(cube, 12, 4) |> Enum.map(fn c ->
      String.split(c, "", trim: true) |> Enum.find_index(fn f -> f == "U" end)
    end)
  end

  def oriented_corner_count(cube) do
    cube |> top_face_indices |> Enum.count(fn x -> x == 0 end)
  end
end
