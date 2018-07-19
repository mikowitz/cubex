defmodule CubeTest do
  use ExUnit.Case
  doctest Cube

  test "starts with red in front and white on the bottom" do
    assert Cube2.new() ==
      ~w(UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)
  end

  test "U" do
    assert Cube2.new() |> Cube2.u() ==
      ~w(UR UB UL UF DF DR DB DL FR FL BR BL URB UBL ULF UFR DRF DFL DLB DBR)
  end

  test "D" do
    assert Cube2.new() |> Cube2.d() ==
      ~w(UF UR UB UL DL DF DR DB FR FL BR BL UFR URB UBL ULF DFL DLB DBR DRF)
  end

  test "F" do
    assert Cube2.new() |> Cube2.f() ==
      ~w(LF UR UB UL RF DR DB DL FU FD BR BL LFU URB UBL LDF RUF RFD DLB DBR)
  end

  test "B" do
    assert Cube2.new() |> Cube2.b() ==
      ~w(UF UR RB UL DF DR LB DL FR FL BD BU UFR RDB RBU ULF DRF DFL LUB LBD)
  end

  test "R" do
    assert Cube2.new() |> Cube2.r() ==
      ~w(UF FR UB UL DF BR DB DL DR FL UR BL FDR FRU UBL ULF BRD DFL DLB BUR)
  end

  test "L" do
    assert Cube2.new() |> Cube2.l() ==
      ~w(UF UR UB BL DF DR DB FL FR UL BR DL UFR URB BDL BLU DRF FUL FLD DBR)
  end

  test "longer sequence" do
    assert Cube2.new |> Cube2.fp |> Cube2.u |> Cube2.fp |> Cube2.dp |> Cube2.lp
    |> Cube2.dp |> Cube2.fp |> Cube2.up |> Cube2.l2 |> Cube2.dp
      ~w(RU LF UB DR DL BL UL FU BD RF BR FD LDF LBD FUL RFD UFR RDB UBL RBU)
  end

  test "longer sequence shorthand" do
    assert Cube2.new |> Cube2.turn("f' u f' d' l' d' f' u' l2 d'") ==
      ~w(RU LF UB DR DL BL UL FU BD RF BR FD LDF LBD FUL RFD UFR RDB UBL RBU)

    assert Cube2.new |> Cube2.turn("F' U F' D' L' D' F' U' L2 D'") ==
      ~w(RU LF UB DR DL BL UL FU BD RF BR FD LDF LBD FUL RFD UFR RDB UBL RBU)
  end

  test "swap" do
    cube = Cube2.new
    cube = Cube2.swap(cube, 0, 3)
    assert cube ==
      ~w(UL UR UB UF DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)
    cube = Cube2.swap(cube, 3, 2)
    assert cube ==
      ~w(UL UR UF UB DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)
    cube = Cube2.swap(cube, 2, 1)
    assert cube ==
      ~w(UL UF UR UB DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)
  end

  test "rotate" do
    cube = Cube2.new
    cube = Cube2.rotate(cube, 0, 1)
    assert cube ==
      ~w(FU UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)

    cube = Cube2.new
    cube = Cube2.rotate(cube, 0, 2)
    assert cube ==
      ~w(UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)

    cube = Cube2.new
    cube = Cube2.rotate(cube, 12, 1)
    assert cube ==
      ~w(UF UR UB UL DF DR DB DL FR FL BR BL FRU URB UBL ULF DRF DFL DLB DBR)

    cube = Cube2.new
    cube = Cube2.rotate(cube, 12, 2)
    assert cube ==
      ~w(UF UR UB UL DF DR DB DL FR FL BR BL RUF URB UBL ULF DRF DFL DLB DBR)

    cube = Cube2.new
    cube = Cube2.rotate(cube, 12, 3)
    assert cube ==
      ~w(UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)
  end
end

  # test "rotate_y" do
  #   assert Cube.new() |> Cube.rotate_y() ==
  #   [

  #     [{:y, :y, :y},
  #     {:y, :y, :y},
  #     {:y, :y, :y}],

  #     [{:r, :r, :r},
  #     {:r, :r, :r},
  #     {:r, :r, :r}],

  #     [{:g, :g, :g},
  #     {:g, :g, :g},
  #     {:g, :g, :g}],


  #     [{:o, :o, :o},
  #     {:o, :o, :o},
  #     {:o, :o, :o}],


  #     [{:b, :b, :b},
  #     {:b, :b, :b},
  #     {:b, :b, :b}],

  #     [{:w, :w, :w},
  #     {:w, :w, :w},
  #     {:w, :w, :w}],
  #   ]
  # end

  # test "f" do
  #   assert Cube.new() |> Cube.f() ==
  #   [

  #     [{:y, :y, :y},
  #     {:y, :y, :y},
  #     {:b, :b, :b}],

  #     [{:b, :b, :w},
  #     {:b, :b, :w},
  #     {:b, :b, :w}],

  #     [{:r, :r, :r},
  #     {:r, :r, :r},
  #     {:r, :r, :r}],

  #     [{:y, :g, :g},
  #     {:y, :g, :g},
  #     {:y, :g, :g}],

  #     [{:o, :o, :o},
  #     {:o, :o, :o},
  #     {:o, :o, :o}],

  #     [{:g, :g, :g},
  #     {:w, :w, :w},
  #     {:w, :w, :w}],
  #   ]
  # end

  # test "r" do
  #   assert Cube.new() |> Cube.r() ==
  #   [

  #     [{:y, :y, :r},
  #     {:y, :y, :r},
  #     {:y, :y, :r}],

  #     [{:b, :b, :b},
  #     {:b, :b, :b},
  #     {:b, :b, :b}],

  #     [{:r, :r, :w},
  #     {:r, :r, :w},
  #     {:r, :r, :w}],

  #     [{:g, :g, :g},
  #     {:g, :g, :g},
  #     {:g, :g, :g}],

  #     [{:y, :o, :o},
  #     {:y, :o, :o},
  #     {:y, :o, :o}],

  #     [{:w, :w, :o},
  #     {:w, :w, :o},
  #     {:w, :w, :o}],
  #   ]
  # end

  # test "l" do
  #   assert Cube.new() |> Cube.l() ==
  #   [

  #     [{:o, :y, :y},
  #     {:o, :y, :y},
  #     {:o, :y, :y}],

  #     [{:b, :b, :b},
  #     {:b, :b, :b},
  #     {:b, :b, :b}],

  #     [{:y, :r, :r},
  #     {:y, :r, :r},
  #     {:y, :r, :r}],

  #     [{:g, :g, :g},
  #     {:g, :g, :g},
  #     {:g, :g, :g}],

  #     [{:o, :o, :w},
  #     {:o, :o, :w},
  #     {:o, :o, :w}],

  #     [{:r, :w, :w},
  #     {:r, :w, :w},
  #     {:r, :w, :w}],
  #   ]
  # end

  # test "b" do
  #   assert Cube.new() |> Cube.b() ==
  #   [

  #     [{:g, :g, :g},
  #     {:y, :y, :y},
  #     {:y, :y, :y}],

  #     [{:y, :b, :b},
  #     {:y, :b, :b},
  #     {:y, :b, :b}],

  #     [{:r, :r, :r},
  #     {:r, :r, :r},
  #     {:r, :r, :r}],

  #     [{:g, :g, :w},
  #     {:g, :g, :w},
  #     {:g, :g, :w}],

  #     [{:o, :o, :o},
  #     {:o, :o, :o},
  #     {:o, :o, :o}],

  #     [{:w, :w, :w},
  #     {:w, :w, :w},
  #     {:b, :b, :b}],
  #   ]
  # end

  # test "u" do
  #   assert Cube.new() |> Cube.u() ==
  #   [

  #     [{:y, :y, :y},
  #     {:y, :y, :y},
  #     {:y, :y, :y}],

  #     [{:r, :r, :r},
  #     {:b, :b, :b},
  #     {:b, :b, :b}],

  #     [{:g, :g, :g},
  #     {:r, :r, :r},
  #     {:r, :r, :r}],

  #     [{:o, :o, :o},
  #     {:g, :g, :g},
  #     {:g, :g, :g}],

  #     [{:b, :b, :b},
  #     {:o, :o, :o},
  #     {:o, :o, :o}],

  #     [{:w, :w, :w},
  #     {:w, :w, :w},
  #     {:w, :w, :w}],
  #   ]
  # end

  # test "d" do
  #   assert Cube.new() |> Cube.d() ==
  #   [

  #     [{:y, :y, :y},
  #     {:y, :y, :y},
  #     {:y, :y, :y}],

  #     [{:b, :b, :b},
  #     {:b, :b, :b},
  #     {:o, :o, :o}],

  #     [{:r, :r, :r},
  #     {:r, :r, :r},
  #     {:b, :b, :b}],

  #     [{:g, :g, :g},
  #     {:g, :g, :g},
  #     {:r, :r, :r}],

  #     [{:o, :o, :o},
  #     {:o, :o, :o},
  #     {:g, :g, :g}],

  #     [{:w, :w, :w},
  #     {:w, :w, :w},
  #     {:w, :w, :w}],
  #   ]
  # end

  # test "f r u2 l'" do
  #   assert Cube.new() |> Cube.f() |> Cube.r() |> Cube.u2() |> Cube.l_prime() ==
  #   [

  #     [{:b, :b, :b},
  #     {:r, :y, :y},
  #     {:r, :y, :y}],

  #     [{:y, :w, :w},
  #     {:y, :b, :b},
  #     {:y, :b, :b}],

  #     [{:g, :o, :o},
  #     {:w, :r, :w},
  #     {:w, :r, :w}],

  #     [{:b, :b, :w},
  #     {:g, :g, :g},
  #     {:g, :g, :g}],

  #     [{:r, :r, :r},
  #     {:y, :o, :r},
  #     {:y, :o, :r}],

  #     [{:o, :g, :o},
  #     {:o, :w, :o},
  #     {:g, :w, :o}],
  #   ]
  # end
# end
