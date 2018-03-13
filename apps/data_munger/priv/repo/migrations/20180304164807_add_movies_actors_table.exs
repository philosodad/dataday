defmodule DataMunger.Repo.Migrations.AddMoviesActorsTable do
  use Ecto.Migration

  def change do
    create table("movie_actors") do
      add :nconst, :string, size: 9
      add :tconst, :string, size: 9
      add :characters, {:array, :string}
    end
  end
end
