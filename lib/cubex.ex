defmodule Cubex do
  @moduledoc """
  # Cubex
  """

  @doc """
  Takes a string representation of a scrambled cube and returns a list of turns
  needed to return it to a solved state.

  ## Example

      iex> {cube, turns} = Cubex.solve("UL DB BR FL BL DR FD RU FR UB LD FU FDR FUL BDL RBU FLD RUF DBR LUB")
      iex> cube
      ["UF", "UR", "UB", "UL", "DF", "DR", "DB", "DL", "FR", "FL", "BR", "BL", "UFR",
       "URB", "UBL", "ULF", "DRF", "DFL", "DLB", "DBR"]
      iex> turns
      ["u' b2", "u' l f' l'", "d' b d", "l' u l", "r u r'", "b u b'", "l u l'", "u'",
      "b u' b' u b u' b'", "u", "u", "u", "u l u' l' u' b' u b", "u",
      "f u' f' u f u' f'", "u'", "u' f' u f u r u' r'", "l u f u' f' l'",
      "r2 d r' u2 r d' r' u2 r'", "r b' r' f r b r' f' r b r' f r b' r' f'", "u",
      "f u' f u f u f u' f' u' f2"]

  """
  def solve(cube) when is_bitstring(cube) do
    cube |> String.split |> Cubex.Solver.solve
  end
end
