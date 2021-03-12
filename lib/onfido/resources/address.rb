module Onfido
  class Address < Resource
    def all(postcode)
      query_string = "postcode=#{postcode.delete(' ')}"
      get(url: url_for("addresses/pick?#{query_string}"))
    end
  end
end
