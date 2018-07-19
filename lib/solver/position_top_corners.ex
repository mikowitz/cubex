defmodule Solver.PositionTopCorners do
  @sides ~w(f r b l)

  @fr "UFR"
  @rb "URB"
  @bl "UBL"
  @lf "ULF"

  def solve({[_,_,_,_,"DF","DR","DB","DL",
              "FR","FL","BR","BL",
              "UFR","URB","UBL","ULF",
              "DRF","DFL","DLB","DBR"], _} = set), do: set
  def solve({cube, _} = set) do
    cond do
      corners_off_alignment?(cube) -> rotate_into_place(set) |> solve
      same_face_on_front(cube) -> rotate_three(set, "f") |> solve
      same_face_on_right(cube) -> rotate_three(set, "r") |> solve
      same_face_on_back(cube) -> rotate_three(set, "b") |> solve
      same_face_on_left(cube) -> rotate_three(set, "l") |> solve
      faces_opposite_fb(cube) -> parallel_swap(set, "f") |> solve
      faces_opposite_lr(cube) -> parallel_swap(set, "r") |> solve
    end
  end

  def same_face_on_front(cube) do
    fr = Enum.at(cube, 12)
    lf = Enum.at(cube, 15)
    String.at(fr, 1) == String.at(lf, 2)
  end
  def same_face_on_right(cube) do
    rb = Enum.at(cube, 13)
    fr = Enum.at(cube, 12)
    String.at(rb, 1) == String.at(fr, 2)
  end
  def same_face_on_back(cube) do
    bl = Enum.at(cube, 14)
    rb = Enum.at(cube, 13)
    String.at(bl, 1) == String.at(rb, 2)
  end
  def same_face_on_left(cube) do
    lf = Enum.at(cube, 15)
    bl = Enum.at(cube, 14)
    String.at(lf, 1) == String.at(bl, 2)
  end

  def faces_opposite_fb(cube) do
    [fr, rb, bl, lf] = Enum.slice(cube, 12, 4)

    String.at(fr, 1) == String.at(rb, 2) &&
      String.at(bl, 1) == String.at(lf, 2)
  end
  def faces_opposite_lr(cube) do
    [fr, rb, bl, lf] = Enum.slice(cube, 12, 4)

    String.at(fr, 2) == String.at(lf, 1) &&
      String.at(rb, 1) == String.at(bl, 2)
  end

  def parallel_swap({cube, _} = set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "#{r} #{b}' #{r}' #{f} #{r} #{b} #{r}' #{f}' #{r} #{b} #{r}' #{f} #{r} #{b}' #{r}' #{f}'")
  end

  def rotate_three(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "#{r} #{b}' #{r} #{f}2 #{r}' #{b} #{r} #{f}2 #{r}2")
  end

  def corners_off_alignment?(cube) do
    correct_corners = [@fr, @rb, @bl, @lf]
    corners = Enum.slice(cube, 12, 4)
    Enum.any?([1,2,3], fn drop ->
      (Enum.slice(corners, drop, length(corners) - drop) ++ Enum.slice(corners, 0, drop)) == correct_corners
    end)
  end

  def rotate_into_place({cube, _} = set) do
    correct_corners = [@fr, @rb, @bl, @lf]
    corners = Enum.slice(cube, 12, 4)
    offset = Enum.find([1,2,3], fn drop ->
      (Enum.slice(corners, drop, length(corners) - drop) ++ Enum.slice(corners, 0, drop)) == correct_corners
    end)
    case offset do
      1 -> make_moves(set, "u")
      2 -> make_moves(set, "u2")
      3 -> make_moves(set, "u'")
    end
  end

  def corners(cube) do
    Enum.slice(cube, 12, 4)
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
