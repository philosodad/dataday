defmodule DataMunger.MovieActorTest do
  use ExUnit.Case, async: true
  alias DataMunger.MovieActor
  import Ecto.Query

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(DataMunger.Repo)
  end

  test "can convert a name_basic record to an actor record" do
    from(p in DataMunger.TitlePrincipal, 
         where: ilike(p.category, "act%") and 
         fragment("char_length(?)", p.characters) > 100, 
         select: p, limit: 3)
    |> DataMunger.ImdbRepo.all()
    |> Enum.each(fn(principal) -> 
       change = MovieActor.changeset(%MovieActor{}, principal)

       {:ok, movie_actor} = DataMunger.Repo.insert(change)
       assert movie_actor.nconst == principal.nconst
       assert movie_actor.tconst == principal.tconst
       assert Enum.count(movie_actor.characters) >= 1
    end)
  end
end

