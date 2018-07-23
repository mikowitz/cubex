defmodule Solver.PositionTopEdges do
  @sides ~w(f r b l)

  @solved ~w(UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)

  import Cube.Helpers

  def solve({@solved, _} = set), do: set
  def solve({cube, _} = set) do
    case count_aligned_edges?(cube) do
      4 -> make_moves(set, "u") |> solve
      1 -> rotate_three(set) |> solve
      0 -> rotate_four(set) |> solve
    end
  end

  def rotate_three({cube, _} = set) do
    [good_edge, _] = find_aligned_edge(cube)
    good_face_index = Enum.find_index(cube, fn c -> c == good_edge end)
    front_index = rem(good_face_index + 2, 4)
    face = Enum.at(@sides, front_index)
    make_moves(set, "r u' r u r u r u' r' u' r2", face)
  end

  def rotate_four({cube, _} = set) do
    cond do
      is_cross?(cube) -> make_moves(set, "l2 r2 d l2 r2 d2 l2 r2 d l2 r2 u2 d2")
      is_z_shape?(cube) -> make_moves(set, "l2 r2 d l2 r2 u l r' f2 l2 r2 b2 l r'")
      true -> make_moves(set, "u")
    end
  end

  def is_cross?(cube) do
    [f,_,b,_,_,_,_,_,_,_,_,_,fr,br|_] = cube
    String.at(f, 1) == String.at(br, 2) &&
      String.at(b, 1) == String.at(fr, 1)
  end

  def is_z_shape?(cube) do
    [f,r,_,_,_,_,_,_,_,_,_,_,fr|_] = cube
    String.at(f, 1) == String.at(fr, 2) &&
      String.at(r, 1) == String.at(fr, 1)
  end

  def count_aligned_edges?(cube) do
    corner_and_edge_pairs(cube) |> Enum.count(fn [e, c] ->
      String.at(e, 1) == String.at(c, 1)
    end)
  end

  def find_aligned_edge(cube) do
    corner_and_edge_pairs(cube) |> Enum.find(fn [e, c] ->
      String.at(e, 1) == String.at(c, 1)
    end)
  end

  def corner_and_edge_pairs(cube) do
    Enum.map([[0,12], [1,13], [2,14], [3,15]], fn indices ->
      Enum.map(indices, &Enum.at(cube, &1))
    end)
  end
end
