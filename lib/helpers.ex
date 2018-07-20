defmodule Cube.Helpers do
  @sides ~w(f r b l)

  def rotate([], _), do: []
  def rotate(list, 0), do: list
  def rotate(list, n) when n < 0 do
    Enum.reverse(list) |> rotate(-n) |> Enum.reverse
  end
  def rotate([h|t], n), do: rotate(t ++ [h], n - 1)

  def make_moves({cube, moves}, new_moves, face) do
    new_moves = create_step(new_moves, face)
    {Cube2.turn(cube, new_moves), moves ++ [new_moves]}
  end

  def face_names(front), do: @sides |> rotate(face_index(front))

  def face_index(face) do
    Enum.find_index(@sides, &Kernel.==(&1,face))
  end

  def create_step(steps, face) do
    face_map = Enum.zip(@sides, face_names(face))
    String.split(steps) |> Enum.map(fn step ->
      case Enum.find(face_map, fn {f, _} -> String.contains?(step, f) end) do
        nil -> step
        {same, same} -> step
        {old, new} -> String.replace(step, old, new)
      end
    end) |> Enum.join(" ")
  end

  def sort_cubie(cubie) do
    cubie |> String.split("") |> Enum.sort |> Enum.join
  end
end
