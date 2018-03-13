defmodule DataMunger.Repo.Migrations.AddMoviesTable do
  use Ecto.Migration

  def change do
    create table("movies") do
      add :title, :string, size: 480
      add :tconst, :string, size: 9
      add :year, :integer
    end
  end
end
