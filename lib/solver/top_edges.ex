defmodule Solver.TopEdges do
  @sides ~w(f r b l)

  def solve({cube, _} = set) do
    case oriented_edge_count(cube) do
      0 -> flip_all_edges(set)
      2 -> flip_two_edges(set)
      4 -> set
    end
  end

  def flip_all_edges(set) do
    make_moves(set, "f u r u' r' f' r b u b' u' r'")
  end

  def flip_two_edges({cube, _} = set) do
    case unrotated_edge_indices(cube) do
      [0, 1] -> rotate_adjacent_edges(set, "f")
      [0, 2] -> rotate_opposite_edges(set, "f")
      [0, 3] -> rotate_adjacent_edges(set, "l")
      [1, 2] -> rotate_adjacent_edges(set, "r")
      [1, 3] -> rotate_opposite_edges(set, "r")
      [2, 3] -> rotate_adjacent_edges(set, "b")
    end
  end

  def rotate_adjacent_edges(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "#{f} u #{r} u' #{r}' #{f}'")
  end

  def rotate_opposite_edges(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "#{f} #{r} u #{r}' u' #{f}'")
  end

  def oriented_edge_count(cube) do
    Enum.slice(cube, 0, 4) |> Enum.count(&String.starts_with?(&1, "U"))
  end

  def unrotated_edge_indices(cube) do
    Enum.slice(cube, 0, 4) |> Enum.with_index |> Enum.reject(fn {f, _} -> String.starts_with?(f, "U") end)
    |> Enum.map(fn {_, i} -> i end)
  end

  defp make_moves({cube, moves}, new_moves) do
    {
      Cube2.turn(cube, new_moves),
      moves ++ [new_moves]
    }
  end

  def face_names(front) do
    @sides |> Stream.cycle
    |> Stream.drop(Enum.find_index(@sides, &Kernel.==(&1,front)))
    |> Enum.take(4)
  end
end
