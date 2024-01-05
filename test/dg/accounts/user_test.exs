defmodule Dg.Accounts.UserTest do
  use Dg.DataCase, async: true
  alias Dg.Accounts.User

  describe "register_with_auth0/1" do
    test "creates a new user" do
      assert %User{
               auth0_id: "google-oauth2|redacted",
               email_verified: true,
               email: %Ash.CiString{string: "hello@briskoda.net"},
               name: "Da Admin",
               picture: "https://picture-url.com"
             } = Dg.Factory.admin_user()
    end

    test "updates an existing user" do
      user = Dg.Factory.user_factory()

      user_info = %{
        "email_verified" => true,
        "email" => Faker.Internet.email(),
        "name" => Faker.Person.name(),
        "sub" => user.auth0_id,
        "picture" => Faker.Internet.url()
      }

      updated_user =
        User
        |> Ash.Changeset.for_action(
          :register_with_auth0,
          %{
            user_info: user_info,
            oauth_tokens: %{}
          }
        )
        |> Dg.Accounts.create!()

      auth0_id = user.auth0_id
      email = user_info["email"]
      name = user_info["name"]
      picture = user_info["picture"]

      assert %User{
               auth0_id: ^auth0_id,
               email_verified: true,
               email: %Ash.CiString{string: ^email},
               name: ^name,
               picture: ^picture
             } = updated_user
    end
  end
end
