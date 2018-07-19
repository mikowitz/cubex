defmodule Cube.Printer do
  def print(cube) do
    [
      # UF UR UB UL
      <<t8,f2>>,<<t6,r2>>,<<t2,b2>>,<<t4,l2>>,
      # DF DR DB DL
      <<d2,f8>>,<<d6,r8>>,<<d8,b8>>,<<d4,l8>>,
      # FR FL BR BL
      <<f6,r4>>,<<f4,l6>>,<<b4,r6>>,<<b6,l4>>,
      # UFR URB UBL ULF
      <<t9,f3,r1>>, <<t3,r3,b1>>, <<t1,b3,l1>>, <<t7,l3,f1>>,
      # DRF DFL DLB DBR
      <<d3,r7,f9>>, <<d1,f7,l9>>, <<d7,l7,b9>>, <<d9,b7,r9>>
    ] = cube
    [t5, f5, r5, l5, d5, b5] = 'UFRLDB'
    print_short_cube_row([t1, t2, t3])
    print_short_cube_row([t4, t5, t6])
    print_short_cube_row([t7, t8, t9])
    print_long_cube_row([l1, l2, l3, f1, f2, f3, r1, r2, r3, b1, b2, b3])
    print_long_cube_row([l4, l5, l6, f4, f5, f6, r4, r5, r6, b4, b5, b6])
    print_long_cube_row([l7, l8, l9, f7, f8, f9, r7, r8, r9, b7, b8, b9])
    print_long_border()
    print_short_cube_row([d1, d2, d3])
    print_short_cube_row([d4, d5, d6])
    print_short_cube_row([d7, d8, d9])
    print_short_border()
    cube
  end

  defp print_short_cube_row(faces) do
    print_short_border()
    :io.format("            || ~c | ~c | ~c ||~n", faces)
  end
  defp print_long_cube_row(faces) do
    print_long_border()
    :io.format("| ~c | ~c | ~c || ~c | ~c | ~c || ~c | ~c | ~c || ~c | ~c | ~c |~n", faces)
  end
  defp print_short_border, do: IO.puts("            ++---+---+---++")
  defp print_long_border, do: IO.puts("+---+---+---++---+---+---++---+---+---++---+---+---+")


end
