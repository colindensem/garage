defmodule Dg.Factory do
  alias Dg.Accounts.User
  alias Dg.Garages.Garage

  def admin_user do
    user_info = %{
      "email_verified" => true,
      "email" => "hello@briskoda.net",
      "name" => "Da Admin",
      "sub" => "google-oauth2|redacted",
      "picture" => "https://picture-url.com"
    }

    User
    |> Ash.Changeset.for_action(
      :register_with_auth0,
      %{
        user_info: user_info,
        oauth_tokens: %{}
      }
    )
    |> Dg.Accounts.create!()
  end

  def user_factory do
    user_info = %{
      "email_verified" => Enum.random([true, false]),
      "email" => Faker.Internet.email(),
      "name" => Faker.Person.name(),
      "sub" => "google-oauth2|#{System.unique_integer([:positive])}",
      "picture" => Faker.Internet.url()
    }

    User
    |> Ash.Changeset.for_action(
      :register_with_auth0,
      %{
        user_info: user_info,
        oauth_tokens: %{}
      }
    )
    |> Dg.Accounts.create!()
  end

  def garage_factory(user, opts \\ %{}) do
    Garage.create!(
      %{
        name: Faker.String.base64()
      },
      actor: user
    )
  end
end
