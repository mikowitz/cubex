defmodule Solver.Cross do
  @side_names ~w(front right back left)
  @sides Enum.map(@side_names, &String.first/1)

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

  defp lookup_table do
    Enum.map(@sides, fn face ->
      uppercase_face = String.upcase(face)
      [
        {"D#{uppercase_face}", build_turn_map(:rotation, face)},
        {"#{uppercase_face}D", build_turn_map(:flip, face)}
      ]
    end) |> Enum.concat |> Enum.into(%{})
  end

  def build_turn_map(type, face) do
    [:top, :bottom, :middle] |> Enum.map(fn prefixix ->
      apply(__MODULE__, :"#{prefixix}_layer_#{type}_fields", [face])
    end) |> Enum.concat
  end

  def top_layer_rotation_fields(face) do
    top_or_bottom_layer_function_names_for(face, fn {suffix, f} -> {:"rotate_down#{suffix}", f} end)
  end

  def middle_layer_rotation_fields(face) do
    middle_layer_function_names_for(face, [:front, :right], fn {prefix, suffix, f} ->
      {:"middle_#{prefix}_to_#{Enum.at(@side_names, face_index(suffix))}", f}
    end)
  end

  def bottom_layer_rotation_fields(face) do
    top_or_bottom_layer_function_names_for(face, fn
      {"", _} -> nil
      {suffix, face} -> {:"rotate#{suffix}", face}
    end)
  end

  def top_layer_flip_fields(face) do
    top_or_bottom_layer_function_names_for(face, fn {suffix, f} -> {:"flip_down#{suffix}", f} end)
  end

  def middle_layer_flip_fields(face) do
    middle_layer_function_names_for(face, [:right, :front], fn {prefix, suffix, f} ->
      {:"middle_#{prefix}_to_#{Enum.at(@side_names, face_index(suffix))}", f}
    end)
  end

  def bottom_layer_flip_fields(face) do
    top_or_bottom_layer_function_names_for(face, fn {suffix, f} -> {:"flip#{suffix}", f} end)
  end

  def top_or_bottom_layer_function_names_for(face, func) do
    ["", "_left", "_across", "_right"] |> rotate(-face_index(face))
    |> Enum.zip(@sides) |> Enum.map(&func.(&1))
  end

  def middle_layer_function_names_for(face, [prefix1, prefix2], func) do
    [f, r, b, l] = face_names(face)
    Enum.zip([
      [prefix1, prefix2, prefix2, prefix1],
      [f, r, l, b], ~w(f l r b)
    ]) |> Enum.map(&func.(&1))
  end
end
