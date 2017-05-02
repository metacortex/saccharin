require "uri"

module Saccharin
  class APIResponseHelper
    def self.json_response_success(env, code, data)
      env.response.content_type = "application/json"

      origin = env.request.headers["Origin"]

      env.response.headers["Access-Control-Allow-Headers"] = "Origin,Authorization,Content-Type,Accept"
      env.response.headers["Access-Control-Allow-Origin"] = origin
      env.response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
      env.response.headers["Access-Control-Allow-Credentials"] = "true"

      {
        meta: { result: code },
        data: data,
      }.to_json
    end

    def self.json_response_error(env, code, error, message)
      env.response.content_type = "application/json"

      origin = env.request.headers["Origin"]

      env.response.headers["Access-Control-Allow-Headers"] = "Origin,Authorization,Content-Type,Accept"
      env.response.headers["Access-Control-Allow-Origin"] = origin
      env.response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
      env.response.headers["Access-Control-Allow-Credentials"] = "true"

      _LOG "** Error: #{error}"
      _LOG message

      {
        meta: { result: code, error: error, message: message },
      }.to_json
    end
  end

  #
  # Full CRUD
  #
  macro rest_api(path, model)
    # index
    get "/{{ path.id }}" do |env|
      begin
        %items = {{ model.id }}.find_all(env.params.query.to_h)
        %items = if %items.is_a? Array
          %items.map(&.serialize)
        else
          %items
        end
        Saccharin::APIResponseHelper.json_response_success(
          env,
          "okay",
          %items
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
          changeset.instance.serialize
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
          %item.serialize(mode: "detail")
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
    put "/{{ path.id }}/:id" do |env|
      begin
        %item = {{ model.id }}.find_by_id(env.params.url["id"])
        %item.assign_attributes(env.params.json)
        changeset = %item.save(true)
        Saccharin::APIResponseHelper.json_response_success(
          env,
          "okay",
          changeset.instance.serialize
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

    # destroy
    delete "/{{ path.id }}/:id" do |env|
      begin
        %id = env.params.url["id"]
        %item = {{ model.id }}.find_by_id(%id)
        %item.destroy
        Saccharin::APIResponseHelper.json_response_success(
          env,
          "okay",
          { id: %id }
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
  end

  #
  # CORS
  #
  macro options_cors(path = "*")
    options "/{{ path.id }}" do |env|
      origin = env.request.headers["Origin"]

      env.response.headers["Access-Control-Allow-Headers"] = "Origin,Authorization,Content-Type,Accept"
      # env.response.headers["Access-Control-Expose-Headers"] = "Authorization"
      env.response.headers["Access-Control-Allow-Origin"] = origin
      env.response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
      env.response.headers["Access-Control-Allow-Credentials"] = "true"

      env.response.status_code = 204
    end
  end

  #
  # Data query only REST
  #
  macro rest_api_read_only(path, model)
    # index
    get "/{{ path.id }}" do |env|
      begin
        %items = {{ model.id }}.find_all(env.params.query.to_h)
        %items = if %items.is_a? Array
          %items.map(&.serialize)
        else
          %items
        end
        Saccharin::APIResponseHelper.json_response_success(
          env,
          "okay",
          %items
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
          %item.serialize(mode: "detail")
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
  end

end
