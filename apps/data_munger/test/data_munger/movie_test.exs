defmodule DataMunger.MovieTest do
  use ExUnit.Case, async: true
  alias DataMunger.Movie
  import Ecto.Query

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(DataMunger.Repo)
  end

  test "can convert a title_basic record to a movie record" do
    from(t in DataMunger.TitleBasic,
         select: t,
         limit: 4)
    |> DataMunger.ImdbRepo.all()
    |> Enum.each(fn(title) -> 
       change = Movie.changeset(%Movie{}, title)

       {:ok, movie} = DataMunger.Repo.insert(change)
       assert movie.title == title.primary_title
       assert movie.year == title.start_year
       assert movie.tconst == title.tconst
    end)
  end
end
