defmodule Solver.LowerLayers do
  #    0  1  2  3  4  5  6  7  8  9  10 11 12  13  14  15  16  17  18  19
  # ~w(UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)

  @solved ~w(UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)
  @sides ~w(f r b l)
  @drf "DRF"
  @dfl "DFL"
  @dlb "DLB"
  @dbr "DBR"

  def solve({[_,_,_,_,"DF","DR","DB","DL","FR","FL","BR","BL",_,_,_,_,"DRF","DFL","DLB","DBR"],_}=set), do: set

  # check middle layers
  def solve({cube, _} = set) do
    cond do
      cubies_placed?(cube, [8, 16]) -> rotate(set, "f") |> solve
      cubies_placed?(cube, [9, 17]) -> rotate(set, "l") |> solve
      cubies_placed?(cube, [10, 19]) -> rotate(set, "r") |> solve
      cubies_placed?(cube, [11, 18]) -> rotate(set, "b") |> solve
      no_edge_cubies_in_top_layer?(cube) -> pop_cubie(set) |> solve

      cubie_in_adjacent_top_edges?(cube, "FR", [0]) -> insert_cwise(set, "f") |> solve
      cubie_in_adjacent_top_edges?(cube, "FR", [1]) -> insert_ccwise(set, "f") |> solve

      cubie_in_adjacent_top_edges?(cube, "RB", [1]) -> insert_cwise(set, "r") |> solve
      cubie_in_adjacent_top_edges?(cube, "RB", [2]) -> insert_ccwise(set, "r") |> solve

      cubie_in_adjacent_top_edges?(cube, "BL", [2]) -> insert_cwise(set, "b") |> solve
      cubie_in_adjacent_top_edges?(cube, "BL", [3]) -> insert_ccwise(set, "b") |> solve

      cubie_in_adjacent_top_edges?(cube, "LF", [3]) -> insert_cwise(set, "l") |> solve
      cubie_in_adjacent_top_edges?(cube, "LF", [0]) -> insert_ccwise(set, "l") |> solve
      true -> make_moves(set, "u") |> solve
    end
  end

  def cwise_set(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "u #{r} u' #{r}' u' #{f}' u #{f}")
  end

  def cwise_cwise(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "#{f}' u #{f} u' #{f}' u #{f}")
  end

  def cwise_ccwise(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "#{f}' u' #{f} u #{f}' u' #{f}")
  end

  def ccwise_set(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "u' #{f}' u #{f} u #{r} u' #{r}'")
  end

  def ccwise_cwise(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "#{r} u #{r}' u' #{r} u #{r}'")
  end

  def ccwise_ccwise(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "#{r} u' #{r}' u #{r} u' #{r}'")
  end

  def insert_cwise({[edge,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,corner|_], _} = set, "f") do
    # IO.puts "insert cwise f"
    case [edge, corner] do
      ["RF", "DRF"] -> cwise_set(set, "f")
      ["RF", "FDR"] -> cwise_cwise(set, "f")
      ["RF", "RFD"] -> cwise_ccwise(set, "f")
      ["FR", _] -> make_moves(set, "u'") |> solve
    end
  end

  def insert_ccwise({[_,edge,_,_,_,_,_,_,_,_,_,_,_,_,_,_,corner|_], _} = set, "f") do
    # IO.puts "insert ccwise f"
    case [edge, corner] do
      ["FR", "DRF"] -> ccwise_set(set, "f")
      ["FR", "FDR"] -> ccwise_cwise(set, "f")
      ["FR", "RFD"] -> ccwise_ccwise(set, "f")
      ["RF", _] -> make_moves(set, "u") |> solve
    end
  end

  def insert_cwise({[_,edge,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,corner], _} = set, "r") do
    # IO.puts "insert cwise r"
    case [edge, corner] do
      ["BR", "DBR"] -> cwise_set(set, "r")
      ["BR", "RDB"] -> cwise_cwise(set, "r")
      ["BR", "BRD"] -> cwise_ccwise(set, "r")
      ["RB", _] -> make_moves(set, "u'") |> solve
    end
  end

  def insert_ccwise({[_,_,edge,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,corner], _} = set, "r") do
    # IO.puts "insert ccwise r"
    case [edge, corner] do
      ["RB", "DBR"] -> ccwise_set(set, "r")
      ["RB", "RDB"] -> ccwise_cwise(set, "r")
      ["RB", "BRD"] -> ccwise_ccwise(set, "r")
      ["BR", _] -> make_moves(set, "u") |> solve
    end
  end

  def insert_cwise({[_,_,edge,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,corner|_], _} = set, "b") do
    # IO.puts "insert cwise b"
    case [edge, corner] do
      ["LB", "DLB"] -> cwise_set(set, "b")
      ["LB", "BDL"] -> cwise_cwise(set, "b")
      ["LB", "LBD"] -> cwise_ccwise(set, "b")
      ["BL", _] -> make_moves(set, "u'") |> solve
    end
  end
  def insert_ccwise({[_,_,_,edge,_,_,_,_,_,_,_,_,_,_,_,_,_,_,corner|_], _} = set, "b") do
    # IO.puts "insert ccwise b"
    case [edge, corner] do
      ["BL", "DLB"] -> ccwise_set(set, "b")
      ["BL", "BDL"] -> ccwise_cwise(set, "b")
      ["BL", "LBD"] -> ccwise_ccwise(set, "b")
      ["LB", _] -> make_moves(set, "u") |> solve
    end
  end

  def insert_cwise({[_,_,_,edge,_,_,_,_,_,_,_,_,_,_,_,_,_,corner|_], _} = set, "l") do
    # IO.puts "insert cwise l"
    case [edge, corner] do
      ["FL", "DFL"] -> cwise_set(set, "l")
      ["FL", "LDF"] -> cwise_cwise(set, "l")
      ["FL", "FLD"] -> cwise_ccwise(set, "l")
      ["LF", _] -> make_moves(set, "u'") |> solve
    end
  end
  def insert_ccwise({[edge,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,corner|_], _} = set, "l") do
    # IO.puts "insert ccwise l"
    case [edge, corner] do
      ["LF", "DFL"] -> ccwise_set(set, "l")
      ["LF", "LDF"] -> ccwise_cwise(set, "l")
      ["LF", "FLD"] -> ccwise_ccwise(set, "l")
      ["FL", _] -> make_moves(set, "u") |> solve
    end
  end

  def cubie_in_adjacent_top_edges?(cube, cubie, indices) do
    Enum.any?(indices, fn i -> sort_cubie(cubie) == sort_cubie(Enum.at(cube, i)) end)
  end

  def cubies_placed?(cube, indices) do
    Enum.all?(indices, fn i ->
      sort_cubie(Enum.at(cube, i)) == sort_cubie(Enum.at(@solved, i))
    end) &&
      Enum.any?(indices, fn i->
          Enum.at(cube, i) != Enum.at(@solved, i)
      end)
  end

  def no_edge_cubies_in_top_layer?(cube) do
    Enum.slice(cube, 0, 4) |> Enum.all?(&Regex.match?(~r/U/, &1))
  end

  def pop_cubie({cube, _} = set) do
    # IO.puts "pop cubie"
    cond do
      !cubie_correct?(cube, 8) -> _pop_cubie(set, "f")
      !cubie_correct?(cube, 9) -> _pop_cubie(set, "l")
      !cubie_correct?(cube, 10) -> _pop_cubie(set, "r")
      # !cubies_placed?(cube, [11]) -> _pop_cubie(set, "b")
      true -> _pop_cubie(set, "b")
    end
  end

  def cubie_correct?(cube, i) do
    sort_cubie(Enum.at(cube, i)) == sort_cubie(Enum.at(@solved, i))
  end

  def _pop_cubie(set, face) do
    [f, r, b, l] = face_names(face)
    # IO.puts "   popping cubie on #{f}"
    make_moves(set, "u #{r} u' #{r}' u' #{f}' u #{f}")
  end

  def rotate({[_,_,_,_,_,_,_,_,edge,_,_,_,_,_,_,_,corner|_], _} = set, "f") do
    # IO.puts "rotate f"
    case [edge, corner] do
      ["FR", "FDR"] -> cwise(set, "f")
      ["FR", "RFD"] -> ccwise(set, "f")
      ["RF", "DRF"] -> flip(set, "f")
      ["RF", "FDR"] -> flip_cwise(set, "f")
      ["RF", "RFD"] -> flip_ccwise(set, "f")
    end
  end

  def rotate({[_,_,_,_,_,_,_,_,_,edge,_,_,_,_,_,_,_,corner|_], _} = set, "l") do
    # IO.puts "rotate l"
    case [edge, corner] do
      ["FL", "LDF"] -> cwise(set, "l")
      ["FL", "FLD"] -> ccwise(set, "l")
      ["LF", "DFL"] -> flip(set, "l")
      ["LF", "LDF"] -> flip_cwise(set, "l")
      ["LF", "FLD"] -> flip_ccwise(set, "l")
    end
  end

  def rotate({[_,_,_,_,_,_,_,_,_,_,edge,_,_,_,_,_,_,_,_,corner], _} = set, "r") do
    # IO.puts "rotate r"
    case [edge, corner] do
      ["BR", "RDB"] -> cwise(set, "r")
      ["BR", "BRD"] -> ccwise(set, "r")
      ["RB", "DBR"] -> flip(set, "r")
      ["RB", "RDB"] -> flip_cwise(set, "r")
      ["RB", "BRD"] -> flip_ccwise(set, "r")
    end
  end

  def rotate({[_,_,_,_,_,_,_,_,_,_,_,edge,_,_,_,_,_,_,corner|_], _} = set, "b") do
    # IO.puts "rotate b"
    case [edge, corner] do
      ["BL", "BDL"] -> cwise(set, "b")
      ["BL", "LBD"] -> ccwise(set, "b")
      ["LB", "DLB"] -> flip(set, "b")
      ["LB", "BDL"] -> flip_cwise(set, "b")
      ["LB", "LBD"] -> flip_ccwise(set, "b")
    end
  end

  def cwise(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "#{r} u' #{r}' u #{r} u2 #{r}' u #{r} u' #{r}'")
  end

  def ccwise(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "#{r} u' #{r}' u' #{r} u #{r}' u' #{r} u2 #{r}'")
  end

  def flip(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "#{r} u' #{r}' u #{f}' u2 #{f} u #{f}' u2 #{f}")
  end

  def flip_cwise(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "#{r} u #{r}' u' #{r} u' #{r}' u2 #{f}' u' #{f}")
  end

  def flip_ccwise(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "#{r} u' #{r}' u #{f}' u' #{f} u' #{f}' u' #{f}")
  end

  def place_right(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "u #{r} u' #{r}' u' #{f}' u #{f}")
  end
  def place_right_cc(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "#{f}' u' #{f} u #{f}' u' #{f}")
  end
  def place_right_c(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "#{r} u #{r}' u2 #{f}' u #{f}")
  end

  def flip_right_c(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "u' #{r} u #{r}' u' #{r} u #{r}'")
  end
  def flip_right_cc(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "u' #{r} u' #{r}' u #{r} u' #{r}'")
  end
  def flip_right(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "u'") |> place_left(r)
  end

  def place_left(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "u' #{l}' u #{l} u #{f} u' #{f}'")
  end
  def flip_left(set, face) do
    [f, r, b, l] = face_names(face)
    make_moves(set, "u") |> place_right(l)
  end

  def sort_cubie(cubie) do
    cubie |> String.split("") |> Enum.sort |> Enum.join
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
