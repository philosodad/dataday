defmodule DataMunger.NameBasic do
  use Ecto.Schema
  import Ecto.Changeset
  alias DataMunger.NameBasic


  @primary_key{:nconst, :string, []}
  schema "name_basics" do
    field :birth_year, :integer
    field :death_year, :integer
    field :primary_name, :string

  end

  @doc false
  def changeset(%NameBasic{} = name, attrs) do
    name
    |> cast(attrs, [:nconst, :primary_name, :birth_year, :death_year])
    |> validate_required([:nconst, :primary_name])
  end
end
