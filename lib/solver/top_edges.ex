defmodule Solver.TopEdges do
  import Cube.Helpers

  def solve({cube, _} = set) do
    case oriented_edge_count(cube) do
      4 -> set
      _ -> flip_edges(set) |> solve
    end
  end

  def flip_edges({cube, _} = set) do
    case unrotated_edge_indices(cube) do
      [0, 1] -> rotate_adjacent_edges(set, "f")
      [0, 2] -> rotate_opposite_edges(set, "f")
      [0, 3] -> rotate_adjacent_edges(set, "l")
      [1, 2] -> rotate_adjacent_edges(set, "r")
      [1, 3] -> rotate_opposite_edges(set, "r")
      [2, 3] -> rotate_adjacent_edges(set, "b")
      _ -> make_moves(set, "f u r u' r' f' r b u b' u' r'")
    end
  end

  def rotate_adjacent_edges(set, face) do
    make_moves(set, "f u r u' r' f'", face)
  end

  def rotate_opposite_edges(set, face) do
    make_moves(set, "f r u r' u' f'", face)
  end

  def oriented_edge_count(cube) do
    Enum.slice(cube, 0, 4) |> Enum.count(&String.starts_with?(&1, "U"))
  end

  def unrotated_edge_indices(cube) do
    Enum.slice(cube, 0, 4) |> Enum.with_index |> Enum.reject(fn {f, _} -> String.starts_with?(f, "U") end)
    |> Enum.map(fn {_, i} -> i end)
  end
end
