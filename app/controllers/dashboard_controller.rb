require 'net/http'

class DashboardController < ApplicationController

  def index
    @dogs = search_dog(params['dog']) if params[:dog].present?
  end

  def search_dog(dog)
    first_api = 'https://private-anon-b744331a39-cerctestedevfontes.apiary-mock.com/caes/' + dog
    second_api = 'https://private-anon-b744331a39-cerctestedevfontes.apiary-mock.com/dogs/' + dog

    begin
      api = HTTParty.get(first_api,
        headers: { 'Content-Type' => 'application/json' }
      )

      return [
          {
            nome_da_raca: api['nome_da_raca'],
            expectativa_de_vida_minima: api['expectativa_de_vida_minima'],
            expectativa_de_vida_maxima: api['expectativa_de_vida_maxima'],
            pais_de_origem: api['pais_de_origem']
          }
      ]
    rescue => ex
      begin
        api = HTTParty.get(second_api,
          headers: { 'Content-Type' => 'application/json' }
        )

        return [
          {
            nome_da_raca: api['breed']['name'],
            expectativa_de_vida_minima: api['breed']['life_span']['min'],
            expectativa_de_vida_maxima: api['breed']['life_span']['max'],
            pais_de_origem: api['breed']['country_of_origin']
          }
        ]
      rescue => e
      end
    end
  end

end
