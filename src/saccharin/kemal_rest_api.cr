require "uri"

module Saccharin
  class APIResponseHelper
    def self.get_request_origin(env)
      if env.request.headers["Origin"]?
        env.request.headers["Origin"]
      else
        env.request.headers["host"]
      end
    end

    def self.json_response_success(env, code, data)
      env.response.content_type = "application/json"

      env.response.headers["Access-Control-Allow-Headers"] = "Origin,Authorization,Content-Type,Accept"
      env.response.headers["Access-Control-Allow-Origin"] = get_request_origin(env)
      env.response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
      env.response.headers["Access-Control-Allow-Credentials"] = "true"

      {
        meta: { result: code },
        data: data,
      }.to_json
    end

    def self.json_response_error(env, code, error, message)
      env.response.content_type = "application/json"

      env.response.headers["Access-Control-Allow-Headers"] = "Origin,Authorization,Content-Type,Accept"
      env.response.headers["Access-Control-Allow-Origin"] = get_request_origin(env)
      env.response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
      env.response.headers["Access-Control-Allow-Credentials"] = "true"

      _LOG "** Error: #{error}"
      _LOG message

      {
        meta: { result: code, error: error, message: message },
      }.to_json
    end

    def self.parse_request_params(opts)
      h = Hash(String, String).new

      opts.each do |k, v|
        if k.match(/\[\]$/)
          array_key = k.gsub(/\[\]$/, "")

          unless h[array_key]?
            h[array_key] = opts.fetch_all(k).join(",")
          end
        else
          unless h[k]?
            h[k] = opts[k]
          end
        end
      end

      h
    end
  end

  #
  # Full CRUD
  #
  macro rest_api(path, model)
    # index
    get "/{{ path.id }}" do |env|
      begin
        %items = {{ model.id }}.find_all(
          Saccharin::APIResponseHelper.parse_request_params(env.params.query)
        )
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
      env.response.headers["Access-Control-Allow-Headers"] = "Origin,Authorization,Content-Type,Accept"
      # env.response.headers["Access-Control-Expose-Headers"] = "Authorization"
      env.response.headers["Access-Control-Allow-Origin"] = Saccharin::APIResponseHelper.get_request_origin(env)
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
        %items = {{ model.id }}.find_all(
          Saccharin::APIResponseHelper.parse_request_params(env.params.query)
        )
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

  #
  # Additional Action
  #
  macro rest_api_action(path, model, action_name)
    post "/{{ path.id }}" do |env|
      begin
        %result = {{ model.id }}.{{ action_name.id }}(env.params.json)
        Saccharin::APIResponseHelper.json_response_success(
          env,
          "okay",
          %result
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

  macro rest_api_action_get(path, model, action_name)
    get "/{{ path.id }}" do |env|
      begin
        %result = {{ model.id }}.{{ action_name.id }}(env.params.query)
        Saccharin::APIResponseHelper.json_response_success(
          env,
          "okay",
          %result
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
