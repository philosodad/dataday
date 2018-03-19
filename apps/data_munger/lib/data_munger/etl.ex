defmodule DataMunger.Etl do
  alias DataMunger.GraphTraverse
  alias DataMunger.NameBasic
  alias DataMunger.TitleBasic
  alias DataMunger.TitlePrincipal
  alias DataMunger.Actor
  alias DataMunger.Movie
  alias DataMunger.MovieActor
  alias DataMunger.Repo
  alias DataMunger.ImdbRepo
  import Ecto.Query, only: [from: 2]

  def load_from_seed(seeds, depth) do
    {names, movies} = GraphTraverse.movies_and_actors(seeds, [], depth)
    principals = GraphTraverse.principals_from_movies(movies)
    names
    |> Enum.each(fn(name) ->
      ImdbRepo.get_by(NameBasic, nconst: name)
      |> actor_from_name_basic()
    end) 
    movies
    |> Enum.each(fn(movie) -> 
      ImdbRepo.get_by(TitleBasic, tconst: movie)
      |> movie_from_title_basic()
    end)
    from(p in TitlePrincipal,
     where: p.id in ^principals,
     select: p)
    |> ImdbRepo.all()
    |> Enum.each(fn(p) ->
      movie_actor_from_title_principal(p)
    end)
  end

  defp actor_from_name_basic(name_basic) do
    %Actor{} 
    |> Actor.changeset(name_basic)
    |> Repo.insert()
  end

  defp movie_from_title_basic(title_basic) do
    %Movie{} 
    |> Movie.changeset(title_basic)
    |> Repo.insert()
  end

  defp movie_actor_from_title_principal(principal) do
    %MovieActor{}
    |> MovieActor.changeset(principal)
    |> Repo.insert()
  end
end
