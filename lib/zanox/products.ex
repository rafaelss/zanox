defmodule Zanox.Products do
  use HTTPoison.Base

  def search(query, params \\ %{}) do
    params = Map.put(params, :q, query)

    programs = List.wrap(params[:programs])
    if Enum.count(programs) > 0 do
      params = Map.put(params, :programs, Enum.join(programs, ","))
    end

    unless params[:items] do
      params = Map.put(params, :items, 50)
    end

    get!("&" <> URI.encode_query(params)).body
  end

  def process_url(url) do
    "http://api.zanox.com/json/2011-03-01/products?connectid=#{Application.get_env(:zanox, :connectid)}" <> url
  end

  def process_response_body(body) do
    response = body |> Poison.decode!
    products = response["productItems"]["productItem"]

    products
    |> Enum.map(fn(item) ->
      %Product{
        id: item["@id"],
        name: item["name"],
        modified: item["modified"],
        program: %Program{
          name: item["program"]["$"],
          id: item["program"]["@id"]
        },
        price: item["price"],
        currency: item["currency"],
        description: item["description"],
        manufacturer: item["manufacturer"],
        ean: item["ean"],
        images: %Images{
          large: item["image"]["large"]
        },
        merchant_category: item["merchantCategory"],
        merchant_product_id: item["merchantProductId"],
        tracking_links: Enum.map(item["trackingLinks"]["trackingLink"], fn(link) ->
          %TrackingLinks{
            adspace_id: link["@adspaceId"],
            ppc: link["ppc"],
            ppv: link["ppv"]
          }
        end)
      }
    end)
  end
end
