defmodule Solver.LowerCorners do
  #    0  1  2  3  4  5  6  7  8  9  10 11 12  13  14  15  16  17  18  19
  # ~w(UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)
  @solved ~w(UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)

  @sides ~w(f r b l)
  @fr "DFR"
  @fl "DFL"
  @bl "BDL"
  @br "BDR"

  def solve({cube, _} = set) do
    case solved?(cube) do
      true -> set
      false -> _solve(set)
    end
  end

  defp _solve({cube, _} = set) do
    cond do
      corner_at?(cube, 12) -> position_top_front_right(set) |> solve
      corner_at?(cube, 13) -> position_top_right_back(set) |> solve
      corner_at?(cube, 14) -> position_top_back_left(set) |> solve
      corner_at?(cube, 15) -> position_top_left_front(set) |> solve
      wrong_corner_at?(cube, 16) -> position_bottom_right_front(set) |> solve
      wrong_corner_at?(cube, 17) -> position_bottom_front_left(set) |> solve
      wrong_corner_at?(cube, 18) -> position_bottom_left_back(set) |> solve
      wrong_corner_at?(cube, 19) -> position_bottom_back_right(set) |> solve
      true -> {:error, :bad_cube, cube}
    end
  end

  def position_top_front_right({cube, _} = set) do
    case sort_corner(Enum.at(cube, 12)) do
      @fr -> move_down(set, "f")
      @fl -> move_down_left(set, "f")
      @bl -> move_down_across(set, "f")
      @br -> move_down_right(set, "f")
      _ -> {:error, :bad_cube, cube}
    end
  end

  def position_top_right_back({cube, _} =set) do
    case sort_corner(Enum.at(cube, 13)) do
      @fr -> move_down_left(set, "r")
      @fl -> move_down_across(set, "r")
      @bl -> move_down_right(set, "r")
      @br -> move_down(set, "r")
      _ -> {:error, :bad_cube, cube}
    end
  end
  def position_top_back_left({cube, _} =set) do
    case sort_corner(Enum.at(cube, 14)) do
      @fr -> move_down_across(set, "b")
      @fl -> move_down_right(set, "b")
      @bl -> move_down(set, "b")
      @br -> move_down_left(set, "b")
      _ -> {:error, :bad_cube, cube}
    end
  end
  def position_top_left_front({cube, _} =set) do
    case sort_corner(Enum.at(cube, 15)) do
      @fr -> move_down_right(set, "l")
      @fl -> move_down(set, "l")
      @bl -> move_down_left(set, "l")
      @br -> move_down_across(set, "l")
      _ -> {:error, :bad_cube, cube}
    end
  end

  defp move_up(set, face) do
    [_, r, _, _] = face_names(face)
    make_moves(set, "#{r} u' #{r}'")
  end

  def position_bottom_right_front({cube, _} = set) do
    case sort_corner(Enum.at(cube, 16)) do
      x when x in [@fl, @bl, @br] -> move_up(set, "f")
    end
  end

  def position_bottom_front_left({cube, _} = set) do
    case sort_corner(Enum.at(cube, 17)) do
      x when x in [@fr, @bl, @br] -> move_up(set, "l")
    end
  end

  def position_bottom_left_back({cube, _} = set) do
    case sort_corner(Enum.at(cube, 18)) do
      x when x in [@fr, @fl, @br] -> move_up(set, "b")
    end
  end

  def position_bottom_back_right({cube, _} = set) do
    case sort_corner(Enum.at(cube, 19)) do
      x when x in [@fr, @fl, @bl] -> move_up(set, "r")
    end
  end

  def move_down(set, face) do
    [_, r, _, _] = face_names(face)
    make_moves(set, "#{r} u #{r}'")
  end

  def move_down_right(set, face) do
    [_, _, b, _] = face_names(face)
    make_moves(set, "#{b} u' #{b}'")
  end

  def move_down_across(set, face) do
    [_, _, _, l] = face_names(face)
    make_moves(set, "#{l} u2 #{l}'")
  end

  def move_down_left(set, face) do
    [_, _, _, l] = face_names(face)
    make_moves(set, "#{l}' u #{l}")

  end

  def corner_at?(cube, index) do
    cubie = Enum.at(cube, index)
    Enum.member?([@fr, @fl, @bl, @br], sort_corner(cubie))
  end

  def wrong_corner_at?(cube, index) do
    corner_at?(cube, index) &&
      sort_corner(Enum.at(cube, index)) != sort_corner(Enum.at(@solved, index))
  end

  def solved?(cube) do
    Enum.slice(cube, 16, 4) |> Enum.map(&sort_corner/1) == ~w(DFR DFL BDL BDR) &&
      Enum.slice(cube, 4,4) == ~w(DF DR DB DL)
  end

  def sort_corner(corner) do
    corner |> String.split("") |> Enum.sort |> Enum.join
  end

  defp make_moves({cube, moves}, new_moves) do
    {
      Cube2.turn(cube, new_moves),
      moves ++ [new_moves]
    }
  end

  def face_names(front) do
    @sides |> Stream.cycle
    |> Stream.drop(Enum.find_index(@sides, &Kernel.==(&1,front)))
    |> Enum.take(4)
  end
end
