# frozen_string_literal: true

module API
  module V1
    class StocksController < ApplicationController
      include Dry::Monads[:result]

      include AppImport[get_operation: "api.v1.stocks.get_operation"]

      # :nocov:
      # rubocop:disable Metrics/MethodLength
      def in_stocks
        result = get_operation.call(params.to_unsafe_h)

        # maybe move to concern
        case result
        in Success(values)
          render json: values
        in Failure[:unprocessable_entity, errors]
          render json: { errors: errors }, status: :unprocessable_entity
        in Failure[:not_found, errors]
          puts "Not fount in stock. Message: #{errors}" # send to monitoring service

          render :json, status: :not_found
        in Failure[:doesnt_have_enough_in_stock, errors]
          render :json, status: :not_found
        in Failure[:too_many_requests, _errors]
          # thing about how to add rate limit
          render :json, status: :too_many_requests
        end
      end
      # rubocop:enable Metrics/MethodLength
      # :nocov:
    end
  end
end
