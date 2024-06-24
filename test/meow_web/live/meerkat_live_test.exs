defmodule MeowWeb.MeerkatLiveTest do
  use MeowWeb.ConnCase

  import Phoenix.LiveViewTest
  import Meow.MeerkatsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_meerkat(_) do
    meerkat = meerkat_fixture()
    %{meerkat: meerkat}
  end

  describe "Index" do
    setup [:create_meerkat]

    test "lists all meerkats", %{conn: conn, meerkat: meerkat} do
      {:ok, _index_live, html} = live(conn, ~p"/meerkats")

      assert html =~ "Listing Meerkats"
      assert html =~ meerkat.name
    end

    test "saves new meerkat", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/meerkats")

      assert index_live |> element("a", "New Meerkat") |> render_click() =~
               "New Meerkat"

      assert_patch(index_live, ~p"/meerkats/new")

      assert index_live
             |> form("#meerkat-form", meerkat: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#meerkat-form", meerkat: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/meerkats")

      html = render(index_live)
      assert html =~ "Meerkat created successfully"
      assert html =~ "some name"
    end

    test "updates meerkat in listing", %{conn: conn, meerkat: meerkat} do
      {:ok, index_live, _html} = live(conn, ~p"/meerkats")

      assert index_live |> element("#meerkats-#{meerkat.id} a", "Edit") |> render_click() =~
               "Edit Meerkat"

      assert_patch(index_live, ~p"/meerkats/#{meerkat}/edit")

      assert index_live
             |> form("#meerkat-form", meerkat: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#meerkat-form", meerkat: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/meerkats")

      html = render(index_live)
      assert html =~ "Meerkat updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes meerkat in listing", %{conn: conn, meerkat: meerkat} do
      {:ok, index_live, _html} = live(conn, ~p"/meerkats")

      assert index_live |> element("#meerkats-#{meerkat.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#meerkats-#{meerkat.id}")
    end
  end

  describe "Show" do
    setup [:create_meerkat]

    test "displays meerkat", %{conn: conn, meerkat: meerkat} do
      {:ok, _show_live, html} = live(conn, ~p"/meerkats/#{meerkat}")

      assert html =~ "Show Meerkat"
      assert html =~ meerkat.name
    end

    test "updates meerkat within modal", %{conn: conn, meerkat: meerkat} do
      {:ok, show_live, _html} = live(conn, ~p"/meerkats/#{meerkat}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Meerkat"

      assert_patch(show_live, ~p"/meerkats/#{meerkat}/show/edit")

      assert show_live
             |> form("#meerkat-form", meerkat: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#meerkat-form", meerkat: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/meerkats/#{meerkat}")

      html = render(show_live)
      assert html =~ "Meerkat updated successfully"
      assert html =~ "some updated name"
    end
  end
end
