defmodule DataMunger.MovieActor do
  use Ecto.Schema
  import Ecto.Changeset
  alias DataMunger.MovieActor


  schema "movie_actors" do
    field :characters, {:array, :string}
    field :nconst, :string
    field :tconst, :string
  end

  @doc false
  def changeset(%MovieActor{} = movie_actor, %DataMunger.TitlePrincipal{} = attrs) do
    attrs = Map.from_struct(attrs)
    changeset(movie_actor, attrs)
  end

  def changeset(%MovieActor{} = movie_actor, attrs) do
    movie_actor
    |> cast(attrs, [:tconst, :nconst])
    |> add_category(attrs)
    |> validate_required([:nconst, :tconst])
  end

  @doc false 
  def add_category(changeset, attrs) do
    case attrs
         |> Map.get(:characters) do

       nil -> changeset
       character_string -> characters = character_string
                                        |> String.replace(~r/\ \(.*\)/, "")
                                        |> Poison.decode!()
                           changeset 
                           |> Ecto.Changeset.put_change(:characters, characters)
    end
  rescue
    _ -> changeset
       |> Ecto.Changeset.put_change(:characters, [])
  end

end
