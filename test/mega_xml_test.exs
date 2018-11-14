defmodule MegaXmlTest do
  use ExUnit.Case
  doctest MegaXml

  @xmldoc """
    <SearchResults:searchresults xsi:schemaLocation="http://www.zillow.com/static/xsd/SearchResults.xsd /vstatic/ae1bf8a790b67ef2e902d2bc04046f02/static/xsd/SearchResults.xsd">
    <request>
        <address>2114 Bigelow Ave</address>
        <citystatezip>Seattle, WA</citystatezip>
    </request>
    <message>
        <text>Request successfully processed</text>
        <code>0</code>
    </message>
    <response>
        <results>
            <result>
                <zpid>48749425</zpid>
                <links>
                    <homedetails>
    http://www.zillow.com/homedetails/2114-Bigelow-Ave-N-Seattle-WA-98109/48749425_zpid/
                    </homedetails>
                    <graphsanddata> http://www.zillow.com/homedetails/charts/48749425_zpid,1year_chartDuration/?cbt=7522682882544325802%7E9%7EY2EzX18jtvYTCel5PgJtPY1pmDDLxGDZXzsfRy49lJvCnZ4bh7Fi9w**
                    </graphsanddata>
                    <mapthishome>http://www.zillow.com/homes/map/48749425_zpid/</mapthishome>
                    <comparables>http://www.zillow.com/homes/comps/48749425_zpid/</comparables>
                </links>
                <address>
                    <street>2114 Bigelow Ave N</street>
                    <zipcode>98109</zipcode>
                    <city>Seattle</city>
                    <state>WA</state>
                    <latitude>47.63793</latitude>
                    <longitude>-122.347936</longitude>
                </address>
                <zestimate>
                    <amount currency="USD">1219500</amount>
                    <last-updated>11/03/2009</last-updated>
                    <oneWeekChange deprecated="true"/>
                    <valueChange duration="30" currency="USD">-41500</valueChange>
                    <valuationRange>
                        <low currency="USD">1024380</low>
                        <high currency="USD">1378035</high>
                    </valuationRange>
                    <percentile>0</percentile>
                </zestimate>
                <localRealEstate>
                    <region id="271856" type="neighborhood" name="East Queen Anne">
                        <zindexValue>525,397</zindexValue>
                        <zindexOneYearChange>-0.144</zindexOneYearChange>
                        <links>
                            <overview>
    http://www.zillow.com/local-info/WA-Seattle/East-Queen-Anne/r_271856/
                            </overview>
                            <forSaleByOwner>
    http://www.zillow.com/homes/fsbo/East-Queen-Anne-Seattle-WA/
                            </forSaleByOwner>
                            <forSale>
    http://www.zillow.com/east-queen-anne-seattle-wa/
                            </forSale>
                        </links>
                    </region>
                    <region id="16037" type="city" name="Seattle">
                        <zindexValue>381,764</zindexValue>
                        <zindexOneYearChange>-0.074</zindexOneYearChange>
                        <links>
                            <overview>
    http://www.zillow.com/local-info/WA-Seattle/r_16037/
                            </overview>
                            <forSaleByOwner>http://www.zillow.com/homes/fsbo/Seattle-WA/</forSaleByOwner>
                            <forSale>http://www.zillow.com/seattle-wa/</forSale>
                        </links>
                    </region>
                    <region id="59" type="state" name="Washington">
                        <zindexValue>263,278</zindexValue>
                        <zindexOneYearChange>-0.066</zindexOneYearChange>
                        <links>
                            <overview>
    http://www.zillow.com/local-info/WA-home-value/r_59/
                            </overview>
                            <forSaleByOwner>http://www.zillow.com/homes/fsbo/WA/</forSaleByOwner>
                            <forSale>http://www.zillow.com/wa/</forSale>
                        </links>
                    </region>
                </localRealEstate>
            </result>
        </results>
    </response>
  </SearchResults:searchresults>
  """

  @expected_datastructure %{
    "SearchResults:searchresults" => %{
      attribs: %{
        "xsi:schemaLocation" =>
          'http://www.zillow.com/static/xsd/SearchResults.xsd /vstatic/ae1bf8a790b67ef2e902d2bc04046f02/static/xsd/SearchResults.xsd'
      },
      vals: [
        %{
          "response" => %{
            "results" => %{
              "result" => %{
                "address" => %{
                  "city" => "Seattle",
                  "latitude" => "47.63793",
                  "longitude" => "-122.347936",
                  "state" => "WA",
                  "street" => "2114 Bigelow Ave N",
                  "zipcode" => "98109"
                },
                "links" => %{
                  "comparables" => "http://www.zillow.com/homes/comps/48749425_zpid/",
                  "graphsanddata" =>
                    "http://www.zillow.com/homedetails/charts/48749425_zpid,1year_chartDuration/?cbt=7522682882544325802%7E9%7EY2EzX18jtvYTCel5PgJtPY1pmDDLxGDZXzsfRy49lJvCnZ4bh7Fi9w**",
                  "homedetails" =>
                    "http://www.zillow.com/homedetails/2114-Bigelow-Ave-N-Seattle-WA-98109/48749425_zpid/",
                  "mapthishome" => "http://www.zillow.com/homes/map/48749425_zpid/"
                },
                "localRealEstate" => %{
                  vals: [
                    %{
                      "region" => %{
                        attribs: %{"id" => '59', "name" => 'Washington', "type" => 'state'},
                        vals: [
                          %{
                            "links" => %{
                              "forSale" => "http://www.zillow.com/wa/",
                              "forSaleByOwner" => "http://www.zillow.com/homes/fsbo/WA/",
                              "overview" => "http://www.zillow.com/local-info/WA-home-value/r_59/"
                            }
                          },
                          %{"zindexOneYearChange" => "-0.066"},
                          %{"zindexValue" => "263,278"}
                        ]
                      }
                    },
                    %{
                      "region" => %{
                        attribs: %{"id" => '16037', "name" => 'Seattle', "type" => 'city'},
                        vals: [
                          %{
                            "links" => %{
                              "forSale" => "http://www.zillow.com/seattle-wa/",
                              "forSaleByOwner" => "http://www.zillow.com/homes/fsbo/Seattle-WA/",
                              "overview" => "http://www.zillow.com/local-info/WA-Seattle/r_16037/"
                            }
                          },
                          %{"zindexOneYearChange" => "-0.074"},
                          %{"zindexValue" => "381,764"}
                        ]
                      }
                    },
                    %{
                      "region" => %{
                        attribs: %{
                          "id" => '271856',
                          "name" => 'East Queen Anne',
                          "type" => 'neighborhood'
                        },
                        vals: [
                          %{
                            "links" => %{
                              "forSale" => "http://www.zillow.com/east-queen-anne-seattle-wa/",
                              "forSaleByOwner" =>
                                "http://www.zillow.com/homes/fsbo/East-Queen-Anne-Seattle-WA/",
                              "overview" =>
                                "http://www.zillow.com/local-info/WA-Seattle/East-Queen-Anne/r_271856/"
                            }
                          },
                          %{"zindexOneYearChange" => "-0.144"},
                          %{"zindexValue" => "525,397"}
                        ]
                      }
                    }
                  ]
                },
                "zestimate" => %{
                  "amount" => %{attribs: %{"currency" => 'USD'}, vals: ["1219500"]},
                  "last-updated" => "11/03/2009",
                  "oneWeekChange" => %{attribs: %{"deprecated" => 'true'}, vals: []},
                  "percentile" => "0",
                  "valuationRange" => %{
                    "high" => %{attribs: %{"currency" => 'USD'}, vals: ["1378035"]},
                    "low" => %{attribs: %{"currency" => 'USD'}, vals: ["1024380"]}
                  },
                  "valueChange" => %{
                    attribs: %{"currency" => 'USD', "duration" => '30'},
                    vals: ["-41500"]
                  }
                },
                "zpid" => "48749425"
              }
            }
          }
        },
        %{"message" => %{"code" => "0", "text" => "Request successfully processed"}},
        %{"request" => %{"address" => "2114 Bigelow Ave", "citystatezip" => "Seattle, WA"}}
      ]
    }
  }
  test "parses xml file" do
    assert @expected_datastructure == MegaXml.run("test/test.xml")
  end

  test "parses xml in memory" do
    assert @expected_datastructure == MegaXml.parse(@xmldoc)
  end

  @simplexml """
  <body id="5">
    <elem id="6">val</elem>
    <elem>val2</elem>
  </body>
  """
  test "parses simple xml with side by side elements without losing any" do
    assert MegaXml.parse(@simplexml) == %{
             "body" => %{
               attribs: %{"id" => '5'},
               vals: [%{"elem" => "val2"}, %{"elem" => %{attribs: %{"id" => '6'}, vals: ["val"]}}]
             }
           }
  end

  test "detect whether unique elements" do
    list = [1, 2, 3, 4, 5, 6]
    list2 = [1, 2, 3, 4, 5, 2, 6]
    assert MegaXml.all_uniq?(list)
    refute MegaXml.all_uniq?(list2)
  end
end
