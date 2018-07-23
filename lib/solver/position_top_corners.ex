defmodule Cubex.Solver.PositionTopCorners do
  import Cube.Helpers

  def solve({[_,_,_,_,"DF","DR","DB","DL",
              "FR","FL","BR","BL",
              "UFR","URB","UBL","ULF",
              "DRF","DFL","DLB","DBR"], _} = set), do: set
  def solve({cube, _} = set) do
    cond do
      corners_misrotated?(cube) -> rotate_into_place(set) |> solve
      same_face_on_front(cube) -> rotate_three(set, "f") |> solve
      same_face_on_right(cube) -> rotate_three(set, "r") |> solve
      same_face_on_back(cube) -> rotate_three(set, "b") |> solve
      same_face_on_left(cube) -> rotate_three(set, "l") |> solve
      faces_opposite_fb(cube) -> parallel_swap(set, "f") |> solve
      faces_opposite_lr(cube) -> parallel_swap(set, "r") |> solve
    end
  end

  def same_face_on_front(cube), do: same_face?(cube, 12, 15)
  def same_face_on_right(cube), do: same_face?(cube, 13, 12)
  def same_face_on_back(cube), do: same_face?(cube, 14, 13)
  def same_face_on_left(cube), do: same_face?(cube, 15, 14)

  def same_face?(cube, index1, index2) do
    [cubie1, cubie2] = Enum.map([index1, index2], fn i -> Enum.at(cube, i) end)
    String.at(cubie1, 1) == String.at(cubie2, 2)
  end

  def faces_opposite_fb(cube) do
    [fr, rb, bl, lf] = corners(cube)

    String.at(fr, 1) == String.at(rb, 2) &&
      String.at(bl, 1) == String.at(lf, 2)
  end
  def faces_opposite_lr(cube) do
    [fr, rb, bl, lf] = corners(cube)

    String.at(fr, 2) == String.at(lf, 1) &&
      String.at(rb, 1) == String.at(bl, 2)
  end

  def parallel_swap(set, face) do
    make_moves(set, "r b' r' f r b r' f' r b r' f r b' r' f'", face)
  end

  def rotate_three(set, face) do
    make_moves(set, "r b' r f2 r' b r f2 r2", face)
  end

  def corners_misrotated?(cube) do
    case rotations_off_alignment(cube) do
      nil -> false
      _ -> true
    end
  end

  def rotate_into_place({cube, _} = set) do
    case rotations_off_alignment(cube) do
      1 -> make_moves(set, "u")
      2 -> make_moves(set, "u2")
      3 -> make_moves(set, "u'")
    end
  end

  def rotations_off_alignment(cube) do
    Enum.find([1,2,3], fn rot ->
      rotate(corners(cube), rot) == ["UFR", "URB", "UBL", "ULF"]
    end)
  end

  def corners(cube), do: Enum.slice(cube, 12, 4)
end
