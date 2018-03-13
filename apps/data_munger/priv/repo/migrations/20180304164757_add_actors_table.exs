defmodule DataMunger.Repo.Migrations.AddActorsTable do
  use Ecto.Migration

  def change do
    create table("actors") do
      add :name, :string, size: 480
      add :nconst, :string, size: 9
      add :birth_year, :integer
      add :death_year, :integer
    end
  end
end
