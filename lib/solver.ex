defmodule Cube.Solver do
  #            0  1  2  3  4  5  6  7  8  9  10 11 12  13  14  15  16  17  18  19
  # @solved ~w(UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)

  @sides ~w(f r b l)

  def initialize(cube) do
    cube
  end

  def solve(cube) do
    {cube, []}
    |> message("=== Solve Cross ===")
    |> solve_cross
    |> message("=== Place Corners ===")
    |> place_corners
    |> message("=== Solve Lower Layers")
    |> solve_lower_layers
    |> message("=== Rotate Top Corners ===")
    |> rotate_top_edges
    |> message("=== Rotate Top Corners ===")
    |> rotate_top_corners
    |> message("=== Position Top Corners ===")
    |> position_top_corners
    |> message("=== Position Top Edges ===")
    |> position_top_edges
  end


  def message(set, message) do
    IO.puts message
    set
  end

  def solve_cross(set), do: Solver.Cross.solve(set)
  def place_corners(set), do: Solver.LowerCorners.solve(set)
  def solve_lower_layers(set), do: Solver.LowerLayers.solve(set)
  def rotate_top_edges(set), do: Solver.TopEdges.solve(set)
  def rotate_top_corners(set), do: Solver.TopCorners.solve(set)
  def position_top_corners(set), do: Solver.PositionTopCorners.solve(set)
  def position_top_edges(set), do: Solver.PositionTopEdges.solve(set)

  def test_cube do
    # Cube2.turn(Cube2.new, "f r l u2 d' b r' l2 f'")
    # Cube2.turn(Cube2.new, "u' f2 l u2 u b2 b2 b r b f b' b2 b2 u2")
    # Cube2.turn(Cube2.new, "b2 u2 r' d d' b2 d2 u2 r' r2 l b' u2 u' r2")
    # Cube2.turn(Cube2.new, "r2 d' l' f' l f f u r u2 b2 r' u' f2 d2")
    # Cube2.turn(Cube2.new, "b2 f u2 b' u r' r' f' u d' b f2 l' l r2")
    # Cube2.turn(Cube2.new, "d' b2 l' r2 r' f' u f2 b2 r' b2 f' f' r2 u2")
    Cube2.turn(Cube2.new, "f2 f' u d2 b l2 b l2 u l' l2 u2 b2 u2 l2")
  end


  def test do
    test_cube |> solve
  end
  def test(turns) do
    Cube2.turn(Cube2.new, turns) |> solve
  end

  def random_test do
    steps = scramble_steps
    IO.inspect steps
    File.write("random.txt", steps <> "\n", [:append])
    Cube2.new |> Cube2.turn(steps) |> solve
  end

  @turns Enum.map(~w(f r b l u d), fn s ->
    Enum.map(["", "'", "2"], &"#{s}#{&1}")
  end) |> List.flatten

  def all_turns, do: @turns

  def random_turn, do: Enum.random(all_turns)

  def scramble_steps do
    Stream.repeatedly(&random_turn/0) |> Enum.take(15) |> Enum.join(" ")
  end
end
