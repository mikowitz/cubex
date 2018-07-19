defmodule Cube2 do
  #          0  1  2  3  4  5  6  7  8  9  10 11 12  13  14  15  16  17  18  19
  @solved ~w(UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)

  def new, do: @solved
  def new(state), do: state


  def u(cube) do
    perform_turn(cube, [0,1,2,3], [12,13,14,15], [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
  end

  def d(cube) do
    perform_turn(cube, [4,7,6,5], [16,17,18,19], [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
  end

  def f(cube) do
    perform_turn(cube, [0,9,4,8], [12,15,17,16], [1,0,0,0,1,0,0,0,1,1,0,0,1,0,0,2,2,1,0,0])
  end

  def b(cube) do
    perform_turn(cube, [2,10,6,11], [13,19,18,14], [0,0,1,0,0,0,1,0,0,0,1,1,0,2,1,0,0,0,2,1])
  end

  def r(cube) do
    perform_turn(cube, [1,8,5,10], [12,16,19,13], [0,0,0,0,0,0,0,0,0,0,0,0,2,1,0,0,1,0,0,2])
  end

  def l(cube) do
    perform_turn(cube, [3,11,7,9], [15,14,18,17], [0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1,0,2,1,0])
  end

  def turn(cube, steps) do
    steps |> String.downcase |> String.split |> Enum.map(&get_turn_function/1)
    |> Enum.reduce(cube, fn f, c ->
      apply(__MODULE__, f, [c])
    end)
  end

  def get_turn_function(turn) do
    String.replace(turn, "'", "p") |> String.to_atom
  end

  def swap(cube, index_a, index_b) do
    Enum.reduce([{index_a, index_b}], cube, fn {a, b}, c ->
      c |> List.replace_at(a, Enum.at(cube, b))
        |> List.replace_at(b, Enum.at(cube, a))
    end)
  end

  def rotate(cube, _, 0), do: cube
  def rotate(cube, index, steps) do
    cubie = Enum.reduce(steps..1, Enum.at(cube, index), fn _, cubie ->
      rotate_once(cubie)
    end)
    List.replace_at(cube, index, cubie)
  end

  defp rotate_once(cubie) do
    [h|t] = to_charlist(cubie)
    to_string(t ++ [h])
  end

  defp perform_turn(cube, edges, corners, rotations) do
    swaps = build_swaps(edges, corners)
    cube = Enum.reduce(swaps, cube, fn [a, b], c ->
      swap(c, a, b)
    end)
    rotations |> Enum.with_index |> Enum.reduce(cube, fn {r, i}, c ->
      rotate(c, i, r)
    end)
  end

  defp build_swaps(edges, corners) do
    Enum.map([edges, corners], fn l ->
      Enum.chunk_every(l, 2, 1, :discard)
    end) |> Enum.concat
  end

  def l2(cube), do: cube |> l |> l
  def r2(cube), do: cube |> r |> r
  def u2(cube), do: cube |> u |> u
  def d2(cube), do: cube |> d |> d
  def f2(cube), do: cube |> f |> f
  def b2(cube), do: cube |> b |> b

  def lp(cube), do: cube |> l2 |> l
  def rp(cube), do: cube |> r2 |> r
  def up(cube), do: cube |> u2 |> u
  def dp(cube), do: cube |> d2 |> d
  def fp(cube), do: cube |> f2 |> f
  def bp(cube), do: cube |> b2 |> b
end
