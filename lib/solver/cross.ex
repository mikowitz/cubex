defmodule Solver.Cross do
  @sides ~w(f r b l)

  def solve({[_, _, _, _, "DF", "DR", "DB", "DL"|_], _} = set), do: set

  # pos 0 up front
  def solve({["DF"|_], _} = set), do: rotate_down(set, "f") |> solve
  def solve({["FD"|_], _} = set), do: flip_down(set, "f") |> solve
  def solve({["DR"|_], _} = set), do: rotate_down_right(set, "f") |> solve
  def solve({["RD"|_], _} = set), do: flip_down_right(set, "f") |> solve
  def solve({["DB"|_], _} = set), do: rotate_down_across(set, "f") |> solve
  def solve({["BD"|_], _} = set), do: flip_down_across(set, "f") |> solve
  def solve({["DL"|_], _} = set), do: rotate_down_left(set, "f") |> solve
  def solve({["LD"|_], _} = set), do: flip_down_left(set, "f") |> solve

  # pos 1 up right
  def solve({[_,"DF"|_], _} = set), do: solve(rotate_down_left(set, "r"))
  def solve({[_,"FD"|_], _} = set), do: solve(flip_down_left(set, "r"))
  def solve({[_,"DR"|_], _} = set), do: solve(rotate_down(set, "r"))
  def solve({[_,"RD"|_], _} = set), do: solve(flip_down(set, "r"))
  def solve({[_,"DB"|_], _} = set), do: solve(rotate_down_right(set, "r"))
  def solve({[_,"BD"|_], _} = set), do: solve(flip_down_right(set, "r"))
  def solve({[_,"DL"|_], _} = set), do: solve(rotate_down_across(set, "r"))
  def solve({[_,"LD"|_], _} = set), do: solve(flip_down_across(set, "r"))

  # pos 2 up back
  def solve({[_,_,"DF"|_], _} = set), do: solve(rotate_down_across(set, "b"))
  def solve({[_,_,"FD"|_], _} = set), do: solve(flip_down_across(set, "b"))
  def solve({[_,_,"DR"|_], _} = set), do: solve(rotate_down_left(set, "b"))
  def solve({[_,_,"RD"|_], _} = set), do: solve(flip_down_left(set, "b"))
  def solve({[_,_,"DB"|_], _} = set), do: solve(rotate_down(set, "b"))
  def solve({[_,_,"BD"|_], _} = set), do: solve(flip_down(set, "b"))
  def solve({[_,_,"DL"|_], _} = set), do: solve(rotate_down_right(set, "b"))
  def solve({[_,_,"LD"|_], _} = set), do: solve(flip_down_right(set, "b"))

  # pos 3 up left
  def solve({[_,_,_,"DF"|_], _} = set), do: solve(rotate_down_right(set, "l"))
  def solve({[_,_,_,"FD"|_], _} = set), do: solve(flip_down_right(set, "l"))
  def solve({[_,_,_,"DR"|_], _} = set), do: solve(rotate_down_across(set, "l"))
  def solve({[_,_,_,"RD"|_], _} = set), do: solve(flip_down_across(set, "l"))
  def solve({[_,_,_,"DB"|_], _} = set), do: solve(rotate_down_left(set, "l"))
  def solve({[_,_,_,"BD"|_], _} = set), do: solve(flip_down_left(set, "l"))
  def solve({[_,_,_,"DL"|_], _} = set), do: solve(rotate_down(set, "l"))
  def solve({[_,_,_,"LD"|_], _} = set), do: solve(flip_down(set, "l"))

  # pos 4
  # def solve({[_,_,_,_,"DF"|_], _} = set), do: solve(set)
  def solve({[_,_,_,_,"FD"|_], _} = set), do: solve(flip(set, "f"))
  def solve({[_,_,_,_,"DR"|_], _} = set), do: solve(rotate_right(set, "f"))
  def solve({[_,_,_,_,"RD"|_], _} = set), do: solve(flip_right(set, "f"))
  def solve({[_,_,_,_,"DB"|_], _} = set), do: solve(rotate_across(set, "f"))
  def solve({[_,_,_,_,"BD"|_], _} = set), do: solve(flip_across(set, "f"))
  def solve({[_,_,_,_,"DL"|_], _} = set), do: solve(rotate_left(set, "f"))
  def solve({[_,_,_,_,"LD"|_], _} = set), do: solve(flip_left(set, "f"))

  # pos 5
  def solve({[_,_,_,_,_,"DF"|_], _} = set), do: solve(rotate_left(set, "r"))
  def solve({[_,_,_,_,_,"FD"|_], _} = set), do: solve(flip_left(set, "r"))
  # def solve({[_,_,_,_,_,"DR"|_], _} = set), do: solve(set)
  def solve({[_,_,_,_,_,"RD"|_], _} = set), do: solve(flip(set, "r"))
  def solve({[_,_,_,_,_,"DB"|_], _} = set), do: solve(rotate_right(set, "r"))
  def solve({[_,_,_,_,_,"BD"|_], _} = set), do: solve(flip_right(set, "r"))
  def solve({[_,_,_,_,_,"DL"|_], _} = set), do: solve(rotate_across(set, "r"))
  def solve({[_,_,_,_,_,"LD"|_], _} = set), do: solve(flip_across(set, "r"))

  # pos 6
  def solve({[_,_,_,_,_,_,"DF"|_], _} = set), do: solve(rotate_across(set, "b"))
  def solve({[_,_,_,_,_,_,"FD"|_], _} = set), do: solve(flip_across(set, "b"))
  def solve({[_,_,_,_,_,_,"DR"|_], _} = set), do: solve(rotate_left(set, "b"))
  def solve({[_,_,_,_,_,_,"RD"|_], _} = set), do: solve(flip_left(set, "b"))
  # def solve({[_,_,_,_,_,_,"DB"|_], _} = set), do: solve(set)
  def solve({[_,_,_,_,_,_,"BD"|_], _} = set), do: solve(flip(set, "b"))
  def solve({[_,_,_,_,_,_,"DL"|_], _} = set), do: solve(rotate_right(set, "b"))
  def solve({[_,_,_,_,_,_,"LD"|_], _} = set), do: solve(flip_right(set, "b"))

  # pos 7
  def solve({[_,_,_,_,_,_,_,"DF"|_], _} = set), do: solve(rotate_right(set, "l"))
  def solve({[_,_,_,_,_,_,_,"FD"|_], _} = set), do: solve(flip_right(set, "l"))
  def solve({[_,_,_,_,_,_,_,"DR"|_], _} = set), do: solve(rotate_across(set, "l"))
  def solve({[_,_,_,_,_,_,_,"RD"|_], _} = set), do: solve(flip_across(set, "l"))
  def solve({[_,_,_,_,_,_,_,"DB"|_], _} = set), do: solve(rotate_left(set, "l"))
  def solve({[_,_,_,_,_,_,_,"BD"|_], _} = set), do: solve(flip_left(set, "l"))
  # def solve({[_,_,_,_,_,_,_,"DL"|_], _} = set), do: solve(set)
  def solve({[_,_,_,_,_,_,_,"LD"|_], _} = set), do: solve(flip(set, "l"))

  # pos 8 front right
  def solve({[_,_,_,_,_,_,_,_,"DF"|_], _} = set), do: solve(middle_front_to_front(set, "f"))
  def solve({[_,_,_,_,_,_,_,_,"FD"|_], _} = set), do: solve(middle_right_to_front(set, "f"))
  def solve({[_,_,_,_,_,_,_,_,"DR"|_], _} = set), do: solve(middle_front_to_right(set, "f"))
  def solve({[_,_,_,_,_,_,_,_,"RD"|_], _} = set), do: solve(middle_right_to_right(set, "f"))
  def solve({[_,_,_,_,_,_,_,_,"DB"|_], _} = set), do: solve(middle_front_to_back(set, "f"))
  def solve({[_,_,_,_,_,_,_,_,"BD"|_], _} = set), do: solve(middle_right_to_back(set, "f"))
  def solve({[_,_,_,_,_,_,_,_,"DL"|_], _} = set), do: solve(middle_front_to_left(set, "f"))
  def solve({[_,_,_,_,_,_,_,_,"LD"|_], _} = set), do: solve(middle_right_to_left(set, "f"))

  # pos 9 front left
  def solve({[_,_,_,_,_,_,_,_,_,"DF"|_], _} = set), do: solve(middle_right_to_right(set, "l"))
  def solve({[_,_,_,_,_,_,_,_,_,"FD"|_], _} = set), do: solve(middle_front_to_right(set, "l"))
  def solve({[_,_,_,_,_,_,_,_,_,"DR"|_], _} = set), do: solve(middle_right_to_back(set, "l"))
  def solve({[_,_,_,_,_,_,_,_,_,"RD"|_], _} = set), do: solve(middle_front_to_back(set, "l"))
  def solve({[_,_,_,_,_,_,_,_,_,"DB"|_], _} = set), do: solve(middle_right_to_left(set, "l"))
  def solve({[_,_,_,_,_,_,_,_,_,"BD"|_], _} = set), do: solve(middle_front_to_left(set, "l"))
  def solve({[_,_,_,_,_,_,_,_,_,"DL"|_], _} = set), do: solve(middle_right_to_front(set, "l"))
  def solve({[_,_,_,_,_,_,_,_,_,"LD"|_], _} = set), do: solve(middle_front_to_front(set, "l"))

  # pos 10 back right
  def solve({[_,_,_,_,_,_,_,_,_,_,"DF"|_], _} = set), do: solve(middle_right_to_left(set, "r"))
  def solve({[_,_,_,_,_,_,_,_,_,_,"FD"|_], _} = set), do: solve(middle_front_to_left(set, "r"))
  def solve({[_,_,_,_,_,_,_,_,_,_,"DR"|_], _} = set), do: solve(middle_right_to_front(set, "r"))
  def solve({[_,_,_,_,_,_,_,_,_,_,"RD"|_], _} = set), do: solve(middle_front_to_front(set, "r"))
  def solve({[_,_,_,_,_,_,_,_,_,_,"DB"|_], _} = set), do: solve(middle_right_to_right(set, "r"))
  def solve({[_,_,_,_,_,_,_,_,_,_,"BD"|_], _} = set), do: solve(middle_front_to_right(set, "r"))
  def solve({[_,_,_,_,_,_,_,_,_,_,"DL"|_], _} = set), do: solve(middle_right_to_back(set, "r"))
  def solve({[_,_,_,_,_,_,_,_,_,_,"LD"|_], _} = set), do: solve(middle_front_to_back(set, "r"))

  # pos 11 back left
  def solve({[_,_,_,_,_,_,_,_,_,_,_,"DF"|_], _} = set), do: solve(middle_front_to_back(set, "b"))
  def solve({[_,_,_,_,_,_,_,_,_,_,_,"FD"|_], _} = set), do: solve(middle_right_to_back(set, "b"))
  def solve({[_,_,_,_,_,_,_,_,_,_,_,"DR"|_], _} = set), do: solve(middle_front_to_left(set, "b"))
  def solve({[_,_,_,_,_,_,_,_,_,_,_,"RD"|_], _} = set), do: solve(middle_right_to_left(set, "b"))
  def solve({[_,_,_,_,_,_,_,_,_,_,_,"DB"|_], _} = set), do: solve(middle_front_to_front(set, "b"))
  def solve({[_,_,_,_,_,_,_,_,_,_,_,"BD"|_], _} = set), do: solve(middle_right_to_front(set, "b"))
  def solve({[_,_,_,_,_,_,_,_,_,_,_,"DL"|_], _} = set), do: solve(middle_front_to_right(set, "b"))
  def solve({[_,_,_,_,_,_,_,_,_,_,_,"LD"|_], _} = set), do: solve(middle_right_to_right(set, "b"))

  def middle_front_to_front(set, face) do
    [_, r, _, _] = face_names(face)
    make_moves(set, "d #{r}' d'")
  end
  def middle_right_to_front(set, face) do
    [f, _, _, _] = face_names(face)
    make_moves(set, "#{f}")
  end
  def middle_front_to_right(set, face) do
    [_, r, _, _] = face_names(face)
    make_moves(set, "#{r}'")
  end
  def middle_right_to_right(set, face) do
    [f, _, _, _] = face_names(face)
    make_moves(set, "d' #{f} d")
  end
  def middle_front_to_back(set, face) do
    [_, r, _, _] = face_names(face)
    make_moves(set, "d' #{r}' d")
  end
  def middle_right_to_back(set, face) do
    [f, _, _, _] = face_names(face)
    make_moves(set, "d2 #{f} d2")
  end
  def middle_front_to_left(set, face) do
    [_, r, _, _] = face_names(face)
    make_moves(set, "d2 #{r}' d2")
  end
  def middle_right_to_left(set, face) do
    [f, _, _, _] = face_names(face)
    make_moves(set, "d #{f} d'")
  end

  def flip(set, face) do
    [f, r, _, _] = face_names(face)
    make_moves(set, "#{f}' d #{r}' d'")
  end
  def rotate_right(set, face) do
    [f, r, _, _] = face_names(face)
    make_moves(set, "#{f}2 u' #{r}2")
  end
  def flip_right(set, face) do
    [f, r, _, _] = face_names(face)
    make_moves(set, "#{f}' #{r}'")
  end
  def rotate_across(set, face) do
    [f, _, b, _] = face_names(face)
    make_moves(set, "#{f}2 u2 #{b}2")
  end
  def flip_across(set, face) do
    [_, r, b, _] = face_names(face)
    make_moves(set, "d #{r}' d' #{b}'")
  end
  def rotate_left(set, face) do
    [f, _, _, l] = face_names(face)
    make_moves(set, "#{f}2 u #{l}2")
  end
  def flip_left(set, face) do
    [f, _, _, l] = face_names(face)
    make_moves(set, "#{f} #{l}")
  end

  def rotate_down(set, face) do
    make_moves(set, "#{face}2")
  end
  def flip_down(set, face) do
    [f, r, _, _] = face_names(face)
    make_moves(set, "u' #{r}' #{f} #{r}")
  end
  def rotate_down_across(set, face) do
    [_, _, b, _] = face_names(face)
    make_moves(set, "u2 #{b}2")
  end
  def flip_down_across(set, face) do
    [_, r, b, _] = face_names(face)
    make_moves(set, "u' #{r} #{b}' #{r}'")
  end

  def rotate_down_right(set, face) do
    [_, r, _, _] = face_names(face)
    make_moves(set, "u' #{r}2")
  end
  def flip_down_right(set, face) do
    [f, r, _, _] = face_names(face)
    make_moves(set, "#{f} #{r}' #{f}'")
  end

  def rotate_down_left(set, face) do
    [_, _, _, l] = face_names(face)
    make_moves(set, "u #{l}2")
  end
  def flip_down_left(set, face) do
    [f, _, _, l] = face_names(face)
    make_moves(set, "#{f}' #{l} #{f}")
  end

  def face_names(front) do
    @sides |> Stream.cycle
    |> Stream.drop(Enum.find_index(@sides, &Kernel.==(&1,front)))
    |> Enum.take(4)
  end

  defp make_moves({cube, moves}, new_moves) do
    {
      Cube2.turn(cube, new_moves),
      moves ++ [new_moves]
    }
  end
end
