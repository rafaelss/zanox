defmodule Zanox.ProductsTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  doctest Zanox

  setup_all do
    Application.put_env(:zanox, :connectid, "foobar")
    ExVCR.Config.cassette_library_dir("test/fixtures/cassettes")
    :ok
  end

  test "load products" do
    use_cassette "load-products" do
      Zanox.Products.start

      products = Zanox.Products.search("tv led 32", %{programs: 13212, items: 1})
      assert Enum.count(products) == 1

      product = products |> List.first
      assert product.id == "8da9d468080fb24227b141cbd5d48c57"
      assert product.name == "Suporte Fixo Multivisão para TVs LCD/LED/Plasma e 3D de 32\" à 84\" Pronto para Instalar -STPF63"
      assert product.modified == "2015-12-04T15:05:59Z"
      assert product.program.name == "Ricardo Eletro BR"
      assert product.program.id == "13212"
      assert product.price == 66.4
      assert product.currency == "BRL"
      assert product.description == ""
      assert product.manufacturer == "Multivisão"
      assert product.ean == 7896643408005
      assert product.images.large == "http://parceiroimg.maquinadevendas.com.br/produto/491_12778_20091030145930.jpg"
      assert product.merchant_category == "Acessórios para TV"
      assert product.merchant_product_id == 491

      assert Enum.count(product.tracking_links) == 1
      Enum.each(product.tracking_links, fn(link) ->
        assert link.adspace_id == "2034022"
        assert link.ppc == "http://ad.zanox.com/ppc/?30343243C59505925&ULP=[[Suporte-Fixo-Multivisao-para-TVs-LCDLEDPlasma-e-3D-de-32-a-84-Pronto-para-Instalar-STPF63/108-3260-3979-4657/?utm_source=Zanox&prc=8803&utm_medium=CPC_TV_e_Video_Zanox&utm_campaign=Acessorios_para_TV&utm_content=Suportes&cda=3EAC-1BE0-DA57-40AD]]&zpar9=[[foobar]]"
        assert link.ppv == "http://ad.zanox.com/ppv/?30343243C59505925&ULP=[[Suporte-Fixo-Multivisao-para-TVs-LCDLEDPlasma-e-3D-de-32-a-84-Pronto-para-Instalar-STPF63/108-3260-3979-4657/?utm_source=Zanox&prc=8803&utm_medium=CPC_TV_e_Video_Zanox&utm_campaign=Acessorios_para_TV&utm_content=Suportes&cda=3EAC-1BE0-DA57-40AD]]&zpar9=[[foobar]]"
      end)
    end
  end
end
