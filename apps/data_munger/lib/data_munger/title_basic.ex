defmodule DataMunger.TitleBasic do
  use Ecto.Schema
  import Ecto.Changeset
  alias DataMunger.TitleBasic


  @primary_key{:tconst, :string, []}
  schema "title_basics" do
    field :primary_title, :string
    field :original_title, :string
    field :start_year, :integer
    field :end_year, :integer

  end

  @doc false
  def changeset(%TitleBasic{} = name, attrs) do
    name
    |> cast(attrs, [:nconst, :primary_name, :birth_year, :death_year])
    |> validate_required([:nconst, :primary_name])
  end
end
