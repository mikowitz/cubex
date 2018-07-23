defmodule Cubex.Solver.LowerLayers do
  #    0  1  2  3  4  5  6  7  8  9  10 11 12  13  14  15  16  17  18  19
  # ~w(UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)

  @solved ~w(UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR)

  import Cubex.Helpers

  def solve({[_,_,_,_,"DF","DR","DB","DL","FR","FL","BR","BL",_,_,_,_,"DRF","DFL","DLB","DBR"],_}=set), do: set

  # check middle layers
  def solve({cube, _} = set) do
    cond do
      cubies_placed?(cube, [8, 16]) -> rotate_edge_and_corner(set, "f") |> solve
      cubies_placed?(cube, [9, 17]) -> rotate_edge_and_corner(set, "l") |> solve
      cubies_placed?(cube, [10, 19]) -> rotate_edge_and_corner(set, "r") |> solve
      cubies_placed?(cube, [11, 18]) -> rotate_edge_and_corner(set, "b") |> solve
      no_edge_cubies_in_top_layer?(cube) -> pop_cubie(set) |> solve

      cubie_in_adjacent_top_edges?(cube, "FR", [0]) -> insert_cwise(set, "f") |> solve
      cubie_in_adjacent_top_edges?(cube, "FR", [1]) -> insert_ccwise(set, "f") |> solve

      cubie_in_adjacent_top_edges?(cube, "RB", [1]) -> insert_cwise(set, "r") |> solve
      cubie_in_adjacent_top_edges?(cube, "RB", [2]) -> insert_ccwise(set, "r") |> solve

      cubie_in_adjacent_top_edges?(cube, "BL", [2]) -> insert_cwise(set, "b") |> solve
      cubie_in_adjacent_top_edges?(cube, "BL", [3]) -> insert_ccwise(set, "b") |> solve

      cubie_in_adjacent_top_edges?(cube, "LF", [3]) -> insert_cwise(set, "l") |> solve
      cubie_in_adjacent_top_edges?(cube, "LF", [0]) -> insert_ccwise(set, "l") |> solve
      true -> make_moves(set, "u", "f") |> solve
    end
  end

  def insert_cwise({[edge,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,corner|_], _} = set, "f") do
    case [edge, corner] do
      ["RF", "DRF"] -> cwise_set(set, "f")
      ["RF", "FDR"] -> cwise_cwise(set, "f")
      ["RF", "RFD"] -> cwise_ccwise(set, "f")
      ["FR", _] -> make_moves(set, "u'", "f") |> solve
    end
  end
  def insert_cwise({[_,edge,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,corner], _} = set, "r") do
    case [edge, corner] do
      ["BR", "DBR"] -> cwise_set(set, "r")
      ["BR", "RDB"] -> cwise_cwise(set, "r")
      ["BR", "BRD"] -> cwise_ccwise(set, "r")
      ["RB", _] -> make_moves(set, "u'", "f") |> solve
    end
  end
  def insert_cwise({[_,_,edge,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,corner|_], _} = set, "b") do
    case [edge, corner] do
      ["LB", "DLB"] -> cwise_set(set, "b")
      ["LB", "BDL"] -> cwise_cwise(set, "b")
      ["LB", "LBD"] -> cwise_ccwise(set, "b")
      ["BL", _] -> make_moves(set, "u'", "f") |> solve
    end
  end
  def insert_cwise({[_,_,_,edge,_,_,_,_,_,_,_,_,_,_,_,_,_,corner|_], _} = set, "l") do
    case [edge, corner] do
      ["FL", "DFL"] -> cwise_set(set, "l")
      ["FL", "LDF"] -> cwise_cwise(set, "l")
      ["FL", "FLD"] -> cwise_ccwise(set, "l")
      ["LF", _] -> make_moves(set, "u'", "f") |> solve
    end
  end

  def insert_ccwise({[_,edge,_,_,_,_,_,_,_,_,_,_,_,_,_,_,corner|_], _} = set, "f") do
    case [edge, corner] do
      ["FR", "DRF"] -> ccwise_set(set, "f")
      ["FR", "FDR"] -> ccwise_cwise(set, "f")
      ["FR", "RFD"] -> ccwise_ccwise(set, "f")
      ["RF", _] -> make_moves(set, "u", "f") |> solve
    end
  end
  def insert_ccwise({[_,_,edge,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,corner], _} = set, "r") do
    case [edge, corner] do
      ["RB", "DBR"] -> ccwise_set(set, "r")
      ["RB", "RDB"] -> ccwise_cwise(set, "r")
      ["RB", "BRD"] -> ccwise_ccwise(set, "r")
      ["BR", _] -> make_moves(set, "u", "f") |> solve
    end
  end
  def insert_ccwise({[_,_,_,edge,_,_,_,_,_,_,_,_,_,_,_,_,_,_,corner|_], _} = set, "b") do
    case [edge, corner] do
      ["BL", "DLB"] -> ccwise_set(set, "b")
      ["BL", "BDL"] -> ccwise_cwise(set, "b")
      ["BL", "LBD"] -> ccwise_ccwise(set, "b")
      ["LB", _] -> make_moves(set, "u", "f") |> solve
    end
  end

  def insert_ccwise({[edge,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,corner|_], _} = set, "l") do
    case [edge, corner] do
      ["LF", "DFL"] -> ccwise_set(set, "l")
      ["LF", "LDF"] -> ccwise_cwise(set, "l")
      ["LF", "FLD"] -> ccwise_ccwise(set, "l")
      ["FL", _] -> make_moves(set, "u", "f") |> solve
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
    make_moves(set, "u r u' r' u' f' u f", face)
  end

  def rotate_edge_and_corner({[_,_,_,_,_,_,_,_,edge,_,_,_,_,_,_,_,corner|_], _} = set, "f") do
    case [edge, corner] do
      ["FR", "FDR"] -> cwise(set, "f")
      ["FR", "RFD"] -> ccwise(set, "f")
      ["RF", "DRF"] -> flip(set, "f")
      ["RF", "FDR"] -> flip_cwise(set, "f")
      ["RF", "RFD"] -> flip_ccwise(set, "f")
    end
  end

  def rotate_edge_and_corner({[_,_,_,_,_,_,_,_,_,edge,_,_,_,_,_,_,_,corner|_], _} = set, "l") do
    case [edge, corner] do
      ["FL", "LDF"] -> cwise(set, "l")
      ["FL", "FLD"] -> ccwise(set, "l")
      ["LF", "DFL"] -> flip(set, "l")
      ["LF", "LDF"] -> flip_cwise(set, "l")
      ["LF", "FLD"] -> flip_ccwise(set, "l")
    end
  end

  def rotate_edge_and_corner({[_,_,_,_,_,_,_,_,_,_,edge,_,_,_,_,_,_,_,_,corner], _} = set, "r") do
    case [edge, corner] do
      ["BR", "RDB"] -> cwise(set, "r")
      ["BR", "BRD"] -> ccwise(set, "r")
      ["RB", "DBR"] -> flip(set, "r")
      ["RB", "RDB"] -> flip_cwise(set, "r")
      ["RB", "BRD"] -> flip_ccwise(set, "r")
    end
  end

  def rotate_edge_and_corner({[_,_,_,_,_,_,_,_,_,_,_,edge,_,_,_,_,_,_,corner|_], _} = set, "b") do
    case [edge, corner] do
      ["BL", "BDL"] -> cwise(set, "b")
      ["BL", "LBD"] -> ccwise(set, "b")
      ["LB", "DLB"] -> flip(set, "b")
      ["LB", "BDL"] -> flip_cwise(set, "b")
      ["LB", "LBD"] -> flip_ccwise(set, "b")
    end
  end

  def cwise(set, face), do: make_moves(set, "r u' r' u r u2 r' u r u' r'", face)
  def ccwise(set, face), do: make_moves(set, "r u' r' u' r u r' u' r u2 r'", face)

  def flip(set, face), do: make_moves(set, "r u' r' u f' u2 f u f' u2 f", face)
  def flip_cwise(set, face), do: make_moves(set, "r u r' u' r u' r' u2 f' u' f", face)
  def flip_ccwise(set, face), do: make_moves(set, "r u' r' u f' u' f u' f' u' f", face)

  def place_right(set, face), do: make_moves(set, "u r u' r' u' f' u f", face)
  def place_right_c(set, face), do: make_moves(set, "r u r' u2 f' u f", face)
  def place_right_cc(set, face), do: make_moves(set, "f' u' f u f' u' f", face)

  def place_left(set, face), do: make_moves(set, "u' l' u l u f u' f'", face)
  def flip_right_c(set, face), do: make_moves(set, "u' r u r' u' r u r'", face)
  def flip_right_cc(set, face), do: make_moves(set, "u' r u' r' u r u' r'", face)

  def flip_right(set, face) do
    [_, r, _, _] = face_names(face)
    make_moves(set, "u'", face) |> place_left(r)
  end
  def flip_left(set, face) do
    [_, _, _, l] = face_names(face)
    make_moves(set, "u", face) |> place_right(l)
  end

  def cwise_set(set, face), do: make_moves(set, "u r u' r' u' f' u f", face)
  def cwise_cwise(set, face), do: make_moves(set, "f' u f u' f' u f", face)
  def cwise_ccwise(set, face), do: make_moves(set, "f' u' f u f' u' f", face)

  def ccwise_set(set, face), do: make_moves(set, "u' f' u f u r u' r'", face)
  def ccwise_cwise(set, face), do: make_moves(set, "r u r' u' r u r'", face)
  def ccwise_ccwise(set, face), do: make_moves(set, "r u' r' u r u' r'", face)
end
