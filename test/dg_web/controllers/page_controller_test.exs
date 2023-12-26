defmodule DgWeb.PageControllerTest do
  use DgWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Your digital garage for your vehicles"
  end

  test "GET /about", %{conn: conn} do
    conn = get(conn, ~p"/about")
    assert html_response(conn, 200) =~ "About Digital Garage"
  end

  test "GET /privacy", %{conn: conn} do
    conn = get(conn, ~p"/privacy")

    assert html_response(conn, 200) =~
             "By using the Digital Garage app"
  end
end
