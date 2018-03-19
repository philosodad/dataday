defmodule DataMunger.EtlTest do
  use ExUnit.Case, async: true
  require Ecto.Query
  alias Ecto.Query
  alias DataMunger.Etl
  alias DataMunger.Repo
  alias DataMunger.ImdbRepo
  alias DataMunger.Movie
  alias DataMunger.TitlePrincipal
  alias DataMunger.Actor
  alias DataMunger.MovieActor

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(DataMunger.Repo)
  end

  describe "load database from seed actors" do
    test "adds the actors" do
      DataMunger.Etl.load_from_seed(["nm0000204"], 1)
      [
        %{nconst: "nm0000191", name: "Ewan McGregor", birth_year: 1971, death_year: nil},
        %{nconst: "nm0000198", name: "Gary Oldman", birth_year: 1958, death_year: nil}, 
        %{nconst: "nm0000204", name: "Natalie Portman",birth_year: 1981, death_year: nil}, 
        %{nconst: "nm0000489", name: "Christopher Lee", birth_year: 1922, death_year: 2015},
        %{nconst: "nm0000553", name: "Liam Neeson", birth_year: 1952, death_year: nil}, 
        %{nconst: "nm0000606", name: "Jean Reno", birth_year: 1948, death_year: nil}, 
        %{nconst: "nm0000732", name: "Danny Aiello", birth_year: 1933, death_year: nil}, 
        %{nconst: "nm0005157", name: "Jake Lloyd", birth_year: 1989, death_year: nil}, 
        %{nconst: "nm0159789", name: "Hayden Christensen", birth_year: 1981, death_year: nil}] 
      |> Enum.each(fn(s) ->
        actor = Repo.get_by(Actor, nconst: s.nconst)
        s
        |> Map.keys
        |> Enum.each(fn(k) ->
          assert Map.get(s, k) == Map.get(actor, k)
        end)
      end)
    end

    test "adds the movies" do
      DataMunger.Etl.load_from_seed(["nm0000204"], 1)
      [%{tconst: "tt0110413", title: "Léon: The Professional", year: 1994},
        %{tconst: "tt0120915", title: "Star Wars: Episode I - The Phantom Menace", year: 1999},
        %{tconst: "tt0121765", title: "Star Wars: Episode II - Attack of the Clones", year: 2002}]
      |> Enum.each(fn(s) ->
        movie = Repo.get_by(Movie, tconst: s.tconst)
        s
        |> Map.keys
        |> Enum.each(fn(k) ->
          assert Map.get(s, k) == Map.get(movie, k)
        end)
      end)

    end

    test "adds the actor-movies" do
      DataMunger.Etl.load_from_seed(["nm0000204"], 1)

      ids = [937006, 937007, 937009, 937008, 1024551, 1024552, 1024554, 1024553, 1029911, 1029913, 1029914, 1029912]
      title_principals = Query.from(
        p in TitlePrincipal,
        where: p.id in ^ids,
        select: {p.nconst, p.tconst})
      |> ImdbRepo.all()
      movie_actors = Query.from(
        ma in MovieActor, 
        select: {ma.nconst, ma.tconst})
      |> Repo.all()
      
      assert title_principals -- movie_actors == []
      assert movie_actors -- title_principals == []
      assert Enum.count(movie_actors) == 12
    end
  end
end

