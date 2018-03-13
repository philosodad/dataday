defmodule DataMunger.Actor do
  use Ecto.Schema
  import Ecto.Changeset
  alias DataMunger.Actor


  schema "actors" do
    field :birth_year, :integer
    field :death_year, :integer
    field :name, :string
    field :nconst, :string
  end

  @doc false
  def changeset(%Actor{} = actor, attrs = %DataMunger.NameBasic{}) do
    %{}
    |> Map.put(:nconst, attrs.nconst)
    |> Map.put(:name, attrs.primary_name)
    |> Map.put(:birth_year, attrs.birth_year)
    |> Map.put(:death_year, attrs.death_year)
    |> (&(changeset(actor, &1))).()
  end

  def changeset(%Actor{} = actor, attrs) do
    actor
    |> cast(attrs, [:nconst, :name, :birth_year, :death_year])
    |> validate_required([:nconst, :name])
  end
end
