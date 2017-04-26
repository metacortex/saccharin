module Saccharin
  class APIResponseHelper
    def self.json_response_success(env, code, data)
      env.response.content_type = "application/json"
      {
        meta: { result: code },
        data: data,
      }.to_json
    end

    def self.json_response_error(env, code, error, message)
      env.response.content_type = "application/json"

      _LOG "** Error: #{error}"
      _LOG message

      {
        meta: { result: code, error: error, message: message },
      }.to_json
    end
  end

  macro rest_api(path, model)
    # index
    get "/{{ path.id }}" do |env|
      begin
        %items = {{ model.id }}.find_all(env.params.query.to_h)
        Saccharin::APIResponseHelper.json_response_success(
          env,
          "okay",
          %items.map(&.to_json)
        )
      rescue ex : Exception
        Saccharin::APIResponseHelper.json_response_error(
          env,
          "error",
          ex.class.to_s,
          ex.message
        )
      end
    end

    # show
    get "/{{ path.id }}/:id" do |env|
      begin
        %item = {{ model.id }}.find_by_id(env.params.url["id"])
        Saccharin::APIResponseHelper.json_response_success(
          env,
          "okay",
          %item.to_json(mode: "detail")
        )
      rescue ex : Exception
        Saccharin::APIResponseHelper.json_response_error(
          env,
          "error",
          ex.class.to_s,
          ex.message
        )
      end
    end

    # create
    post "/{{ path.id }}" do |env|
      begin
        %item = {{ model.id }}.new
        %item.assign_attributes(env.params.json)
        changeset = %item.save(true)
        Saccharin::APIResponseHelper.json_response_success(
          env,
          "okay",
          changeset.instance.to_json
        )
      rescue ex : Exception
        Saccharin::APIResponseHelper.json_response_error(
          env,
          "error",
          ex.class.to_s,
          ex.message
        )
      end
    end

    # update

    # destroy

  end
end
