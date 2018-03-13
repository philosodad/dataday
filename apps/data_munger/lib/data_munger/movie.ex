defmodule DataMunger.Movie do
  use Ecto.Schema
  import Ecto.Changeset
  alias DataMunger.Movie


  schema "movies" do
    field :year, :integer
    field :title, :string
    field :tconst, :string
  end

  @doc false
  def changeset(%Movie{} = movie, %DataMunger.TitleBasic{} = title) do
    %{}
    |> Map.put(:year, title.start_year)
    |> Map.put(:tconst, title.tconst)
    |> Map.put(:title, title.primary_title)
    |> (&(changeset(movie, &1))).()
  end

  def changeset(%Movie{} = movie, attrs) do
    movie
    |> cast(attrs, [:tconst, :year, :title])
    |> validate_required([:tconst, :title])
  end
end
