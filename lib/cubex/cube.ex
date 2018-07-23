defmodule Cubex.Cube do
  #          0  1  2  3  4  5  6  7  8  9  10 11 12  13  14  15  16  17  18  19
  @solved ~w(UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)

  def new, do: @solved
  def new(state), do: state


  def u(cube) do
    perform_turn2(
      cube,
      [1,2,3,0,4,5,6,7,8,9,10,11,13,14,15,12,16,17,18,19],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    )
  end

  defp perform_turn2(cube, swaps, rotations) do
    Enum.zip(swaps, rotations)
    |> Enum.map(fn {swap, rotation} ->
      Enum.at(cube, swap) |> Cubex.Helpers.rotate(rotation)
    end)
  end

  def d(cube) do
    perform_turn2(
      cube,
      [0,1,2,3,7,4,5,6,8,9,10,11,12,13,14,15,17,18,19,16],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    )
  end

  def f(cube) do
    perform_turn2(
      cube,
      # [0,9,4,8], [12,15,17,16],
      [9,1,2,3,8,5,6,7,0,4,10,11,15,13,14,17,12,16,18,19],
      [1,0,0,0,1,0,0,0,1,1,0,0,1,0,0,2,2,1,0,0]
    )
  end

  def b(cube) do
    perform_turn2(
      cube,
      [0,1,10,3,4,5,11,7,8,9,6,2,12,19,13,15,16,17,14,18],
      [0,0,1,0,0,0,1,0,0,0,1,1,0,2,1,0,0,0,2,1]
    )
  end

  def r(cube) do
    perform_turn2(
      cube,
      [0,8,2,3,4,10,6,7,5,9,1,11,16,12,14,15,19,17,18,13],
      [0,0,0,0,0,0,0,0,0,0,0,0,2,1,0,0,1,0,0,2]
    )
  end

  def l(cube) do
    perform_turn2(
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
