defmodule DataMunger.GraphTraverse do
  alias DataMunger.TitlePrincipal
  alias DataMunger.TitleBasic
  alias DataMunger.ImdbRepo
  import Ecto.Query, only: [from: 2]

  def movies_for_actor(actor, count \\ 3) do
    from(p in TitlePrincipal,
    join: t in TitleBasic,
    on: p.tconst == t.tconst,
    where: p.nconst == ^actor and
    t.title_type=="movie" and
    ilike(p.category, "act%"),
    select: p.tconst,
    limit: ^count)
    |> ImdbRepo.all()
  end

  def actors_for_movie(movie) do
    from(p in TitlePrincipal,
    where: p.tconst == ^movie and
    ilike(p.category, "act%"),
    select: p.nconst)
    |> ImdbRepo.all()
  end

  def movies_and_actors(actors, movies, 0) do
    {actors, movies}
  end

  def movies_and_actors(actors, _movies, depth) do
    new_movies = actors
              |> Enum.flat_map(fn(a) -> movies_for_actor(a) end)
              |> Enum.uniq()
    new_actors = new_movies
                  |> Enum.flat_map(fn(m) -> actors_for_movie(m) end)
                  |> Enum.uniq()
    movies_and_actors(new_actors, new_movies, depth-1)
  end
end
