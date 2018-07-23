defmodule Cubex.Solver.Cross do
  import Cube.Helpers

  def solve({[_, _, _, _, "DF", "DR", "DB", "DL"|_], _} = set), do: set
  def solve({cube, _} = set) do
    {cubie, index} = find_first_unplaced_cross_cubie(cube)
    {func, face} = lookup_function_and_face(cubie, index)
    apply(__MODULE__, func, [set, face]) |> solve
  end

  def rotate_down(set, face), do: make_moves(set, "f2", face)
  def rotate_down_right(set, face), do: make_moves(set, "u' r2", face)
  def rotate_down_across(set, face), do: make_moves(set, "u2 b2", face)
  def rotate_down_left(set, face), do: make_moves(set, "u l2", face)

  def flip_down(set, face), do: make_moves(set, "u' r' f r", face)
  def flip_down_right(set, face), do: make_moves(set, "f r' f'", face)
  def flip_down_across(set, face), do: make_moves(set, "u' r b' r'", face)
  def flip_down_left(set, face), do: make_moves(set, "f' l f", face)

  def rotate_right(set, face), do: make_moves(set, "f2 u' r2", face)
  def rotate_across(set, face), do: make_moves(set, "f2 u2 b2", face)
  def rotate_left(set, face), do: make_moves(set, "f2 u l2", face)

  def flip(set, face), do: make_moves(set, "f' d r' d'", face)
  def flip_right(set, face), do: make_moves(set, "f' r'", face)
  def flip_across(set, face), do: make_moves(set, "d r' d' b'", face)
  def flip_left(set, face), do: make_moves(set, "f l", face)

  def middle_front_to_front(set, face), do: make_moves(set, "d r' d'", face)
  def middle_front_to_right(set, face), do: make_moves(set, "r'", face)
  def middle_front_to_back(set, face), do: make_moves(set, "d' r' d", face)
  def middle_front_to_left(set, face), do: make_moves(set, "d2 r' d2", face)

  def middle_right_to_front(set, face), do: make_moves(set, "f", face)
  def middle_right_to_right(set, face), do: make_moves(set, "d' f d", face)
  def middle_right_to_back(set, face), do: make_moves(set, "d2 f d2", face)
  def middle_right_to_left(set, face), do: make_moves(set, "d f d'", face)

  def find_first_unplaced_cross_cubie(cube) do
    Enum.with_index(cube) |> Enum.find(fn {cubie, index} ->
      String.length(cubie) == 2 &&
        Regex.match?(~r/D/, cubie) &&
          !correctly_placed?(cubie, index)
    end)
  end

  def correctly_placed?("DF", 4), do: true
  def correctly_placed?("DR", 5), do: true
  def correctly_placed?("DB", 6), do: true
  def correctly_placed?("DL", 7), do: true
  def correctly_placed?(_, _), do: false

  def lookup_function_and_face(cubie, index) do
    lookup_table()[cubie] |> Enum.at(index)
  end

  def lookup_table do
    %{
      "DF" => [
        {:rotate_down, "f"},
        {:rotate_down_left, "r"},
        {:rotate_down_across, "b"},
        {:rotate_down_right, "l"},
        nil,
        {:rotate_left, "r"},
        {:rotate_across, "b"},
        {:rotate_right, "l"},
        {:middle_front_to_front, "f"},
        {:middle_right_to_right, "l"},
        {:middle_right_to_left, "r"},
        {:middle_front_to_back, "b"}
      ],
      "FD" => [
        {:flip_down, "f"},
        {:flip_down_left, "r"},
        {:flip_down_across, "b"},
        {:flip_down_right, "l"},
        {:flip, "f"},
        {:flip_left, "r"},
        {:flip_across, "b"},
        {:flip_right, "l"},
        {:middle_right_to_front, "f"},
        {:middle_front_to_right, "l"},
        {:middle_front_to_left, "r"},
        {:middle_right_to_back, "b"}
      ],
      "DR" => [
        {:rotate_down_right, "f"},
        {:rotate_down, "r"},
        {:rotate_down_left, "b"},
        {:rotate_down_across, "l"},
        {:rotate_right, "f"}, nil,
        {:rotate_left, "b"},
        {:rotate_across, "l"},
        {:middle_front_to_right, "f"},
        {:middle_right_to_back, "l"},
        {:middle_right_to_front, "r"},
        {:middle_front_to_left, "b"}
      ],
      "RD" => [
        {:flip_down_right, "f"},
        {:flip_down, "r"},
        {:flip_down_left, "b"},
        {:flip_down_across, "l"},
        {:flip_right, "f"},
        {:flip, "r"},
        {:flip_left, "b"},
        {:flip_across, "l"},
        {:middle_right_to_right, "f"},
        {:middle_front_to_back, "l"},
        {:middle_front_to_front, "r"},
        {:middle_right_to_left, "b"}
      ],
      "DB" => [
        {:rotate_down_across, "f"},
        {:rotate_down_right, "r"},
        {:rotate_down, "b"},
        {:rotate_down_left, "l"},
        {:rotate_across, "f"},
        {:rotate_right, "r"}, nil,
        {:rotate_left, "l"},
        {:middle_front_to_back, "f"},
        {:middle_right_to_left, "l"},
        {:middle_right_to_right, "r"},
        {:middle_front_to_front, "b"}
      ],
      "BD" => [
        {:flip_down_across, "f"},
        {:flip_down_right, "r"},
        {:flip_down, "b"},
        {:flip_down_left, "l"},
        {:flip_across, "f"},
        {:flip_right, "r"},
        {:flip, "b"},
        {:flip_left, "l"},
        {:middle_right_to_back, "f"},
        {:middle_front_to_left, "l"},
        {:middle_front_to_right, "r"},
        {:middle_right_to_front, "b"},
      ],
      "DL" => [
        {:rotate_down_left, "f"},
        {:rotate_down_across, "r"},
        {:rotate_down_right, "b"},
        {:rotate_down, "l"},
        {:rotate_left, "f"},
        {:rotate_across, "r"},
        {:rotate_right, "b"}, nil,
        {:middle_front_to_left, "f"},
        {:middle_right_to_front, "l"},
        {:middle_right_to_back, "r"},
        {:middle_front_to_right, "b"}
      ],
      "LD" => [
        {:flip_down_left, "f"},
        {:flip_down_across, "r"},
        {:flip_down_right, "b"},
        {:flip_down, "l"},
        {:flip_left, "f"},
        {:flip_across, "r"},
        {:flip_right, "b"},
        {:flip, "l"},
        {:middle_right_to_left, "f"},
        {:middle_front_to_front, "l"},
        {:middle_front_to_back, "r"},
        {:middle_right_to_right, "b"}
      ]
    }
  end
end
