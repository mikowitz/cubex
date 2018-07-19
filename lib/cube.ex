defmodule Cube do
  #          0  1  2  3  4  5  6  7  8  9  10 11 12  13  14  15  16  17  18  19
  @solved ~w(UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)

  def new, do: @solved
  def new(state), do: state


  def u(cube) do
    # [0,1,2,3], [12,13,14,15]
    perform_turn2(
      cube,
      'BCDAEFGHIJKLNOPMQRST',
      'AAAAAAAAAAAAAAAAAAAA'
    )
  end

  defp perform_turn2(cube, swaps, rotations) do
    cube = Enum.map(swaps, &Enum.at(cube, &1-65))
    rotations |> Enum.with_index |> Enum.reduce(cube, fn {r, i}, c ->
      rotate(c, i, r - 65)
    end)

  end

  def d(cube) do
    # [4,7,6,5], [16,17,18,19]
    perform_turn2(
      cube,
      # [0,1,2,3,7,4,5,6,8,9,10,11,12,13,14,15,17,18,19,16],
      # [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      'ABCDHEFGIJKLMNOPRSTQ',
      'AAAAAAAAAAAAAAAAAAAA'
    )
  end

  def f(cube) do
    # [0,9,4,8], [12,15,17,16]
    perform_turn(
      cube,
      [9,1,2,3,8,5,6,7,0,4,10,11,15,13,14,17,12,16,18,19],
      [1,0,0,0,1,0,0,0,1,1,0,0,1,0,0,2,2,1,0,0]
    )
  end

  def b(cube) do
    # [2,10,6,11], [13,19,18,14]
    perform_turn(
      cube,
      [0,1,10,3,4,5,11,7,8,9,6,2,12,19,13,15,16,17,14,18],
      [0,0,1,0,0,0,1,0,0,0,1,1,0,2,1,0,0,0,2,1]
    )
  end

  def r(cube) do
    # [1,8,5,10], [12,16,19,13]
    perform_turn(
      cube,
      [0,8,2,3,4,10,6,7,5,9,1,11,16,12,14,15,19,17,18,13],
      [0,0,0,0,0,0,0,0,0,0,0,0,2,1,0,0,1,0,0,2]
    )
  end

  def l(cube) do
    # [3,11,7,9], [15,14,18,17]
    perform_turn(
      cube,
      [0,1,2,11,4,5,6,9,8,3,10,7,12,13,18,14,16,15,17,19],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1,0,2,1,0]
    )
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

  defp perform_turn(cube, swaps, rotations) do
    cube = Enum.map(swaps, &Enum.at(cube, &1))
    rotations |> Enum.with_index |> Enum.reduce(cube, fn {r, i}, c ->
      rotate(c, i, r)
    end)
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
