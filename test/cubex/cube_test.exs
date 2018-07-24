defmodule Cubex.CubeTest do
  use ExUnit.Case
  doctest Cubex

  alias Cubex.{Cube, Helpers}

  test "starts with red in front and white on the bottom" do
    assert Cube.new() ==
      ~w(UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)
  end

  test "U" do
    assert Cube.new() |> Cube.u() ==
      ~w(UR UB UL UF DF DR DB DL FR FL BR BL URB UBL ULF UFR DRF DFL DLB DBR)
  end

  test "D" do
    assert Cube.new() |> Cube.d() ==
      ~w(UF UR UB UL DL DF DR DB FR FL BR BL UFR URB UBL ULF DFL DLB DBR DRF)
  end

  test "F" do
    assert Cube.new() |> Cube.f() ==
      ~w(LF UR UB UL RF DR DB DL FU FD BR BL LFU URB UBL LDF RUF RFD DLB DBR)
  end

  test "B" do
    assert Cube.new() |> Cube.b() ==
      ~w(UF UR RB UL DF DR LB DL FR FL BD BU UFR RDB RBU ULF DRF DFL LUB LBD)
  end

  test "R" do
    assert Cube.new() |> Cube.r() ==
      ~w(UF FR UB UL DF BR DB DL DR FL UR BL FDR FRU UBL ULF BRD DFL DLB BUR)
  end

  test "L" do
    assert Cube.new() |> Cube.l() ==
      ~w(UF UR UB BL DF DR DB FL FR UL BR DL UFR URB BDL BLU DRF FUL FLD DBR)
  end

  test "longer sequence" do
    assert Cube.new |> Cube.fp |> Cube.u |> Cube.fp |> Cube.dp |> Cube.lp
    |> Cube.dp |> Cube.fp |> Cube.up |> Cube.l2 |> Cube.dp
      ~w(RU LF UB DR DL BL UL FU BD RF BR FD LDF LBD FUL RFD UFR RDB UBL RBU)
  end

  test "longer sequence shorthand" do
    assert Cube.new |> Helpers.turn("f' u f' d' l' d' f' u' l2 d'") ==
      ~w(RU LF UB DR DL BL UL FU BD RF BR FD LDF LBD FUL RFD UFR RDB UBL RBU)

    assert Cube.new |> Helpers.turn("F' U F' D' L' D' F' U' L2 D'") ==
      ~w(RU LF UB DR DL BL UL FU BD RF BR FD LDF LBD FUL RFD UFR RDB UBL RBU)
  end
end
