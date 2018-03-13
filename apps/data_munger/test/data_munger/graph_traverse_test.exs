defmodule DataMunger.GraphTraverseTest do
  use ExUnit.Case, async: true
  alias DataMunger.GraphTraverse
  alias DataMunger.ImdbRepo
  alias DataMunger.TitleBasic
  alias DataMunger.TitlePrincipal

  describe "movies for actor" do
    test "given a name, finds 3 movie tconsts for that name" do
      ["nm0000203", "nm0000702", "nm0000204", "nm0000102"]
      |> Enum.each(fn(n) ->
        GraphTraverse.movies_for_actor(n)
        |> Enum.map(fn(m) ->
          ImdbRepo.get(TitleBasic, m)
        end)
        |> Enum.map(fn(mov) ->
          assert mov.title_type == "movie"
        end)
        |> (&(assert Enum.count(&1) == 3)).()
      end)
    end

    test "given a name and count, finds count movies" do
      [2,4,9]
      |> Enum.each(fn(n) ->
        GraphTraverse.movies_for_actor("nm0000203", n)
        |> Enum.map(fn(m) ->
          ImdbRepo.get(TitleBasic, m)
        end)
        |> Enum.map(fn(mov) ->
          assert mov.title_type == "movie"
        end)
        |> (&(assert Enum.count(&1) == n)).()
      end)
    end
  end

  describe "actors for movies" do
    test "given a movie, finds the principal actors for that movie" do
      t = "tt0102388"
      t
      |> GraphTraverse.actors_for_movie()
      |> Enum.map(fn(a) -> 
        ImdbRepo.get_by(TitlePrincipal, [nconst: a, tconst: t])
      end)
      |> Enum.each(fn(p) ->
        assert p.category in ["actor", "actress"]
      end)
    end
  end

  describe "get a bunch of actors and movies from one actor" do
    test "returns uniq collections of actors and movies" do
      {actors, movies} = ["nm0000204"]
                          |> GraphTraverse.movies_and_actors([], 2)
      actors
      |> Enum.each(fn(a) ->
        assert String.match?(a, ~r/nm[0-9]{7}/)
      end)
      assert actors 
             |> Enum.uniq()
             |> Enum.count() == actors 
                                |> Enum.count()
      actors
      |> Enum.each(fn(a) ->
        assert String.match?(a, ~r/nm[0-9]{7}/)
      end)
      assert Enum.count(actors) > 1
      assert movies 
             |> Enum.uniq()
             |> Enum.count() == movies 
                                |> Enum.count()
      assert Enum.count(movies) > 1
    end
  end

end

