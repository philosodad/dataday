defmodule DataMunger.TitlePrincipal do
  use Ecto.Schema
  import Ecto.Changeset
  alias DataMunger.TitlePrincipal

  schema "title_principals" do
    field :nconst, :string
    field :tconst, :string
    field :category, :string
    field :characters, :string
    field :ordering, :integer
  end

  @doc false
  def changeset(%TitlePrincipal{} = title, attrs) do
    title
    |> cast(attrs, [:nconst, :category, :tconst, :characters, :ordering])
    |> validate_required([:nconst, :tconst])
  end
end
