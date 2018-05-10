defmodule Ueberauth.Strategy.WechatMiniapp.OAuth do
  @moduledoc """
  An implementation of OAuth2 for wechat.

  To add your `client_id` and `client_secret` include these values in your configuration.

      config :ueberauth, Ueberauth.Strategy.Wechat.OAuth,
        client_id: System.get_env("WECHAT_APPID"),
        client_secret: System.get_env("WECHAT_SECRET")
  """
  use OAuth2.Strategy

  @defaults [
    strategy: __MODULE__,
    site: "https://api.weixin.qq.com",
    authorize_url: "https://open.weixin.qq.com/connect/oauth2/authorize",
    token_url: "https://api.weixin.qq.com/sns/jscode2session"
  ]

  @doc """
  Construct a client for requests to Wechat.

  Optionally include any OAuth2 options here to be merged with the defaults.

      Ueberauth.Strategy.Wechat.OAuth.client(redirect_uri: "http://localhost:4000/auth/wechat/callback")

  This will be setup automatically for you in `Ueberauth.Strategy.Wechat`.
  These options are only useful for usage outside the normal callback phase of Ueberauth.
  """
  def client(opts \\ []) do
    config =
    :ueberauth
    |> Application.fetch_env!(Ueberauth.Strategy.WechatMiniapp.OAuth)
    |> check_config_key_exists(:client_id)
    |> check_config_key_exists(:client_secret)

    client_opts =
      @defaults
      |> Keyword.merge(config)
      |> Keyword.merge(opts)

    OAuth2.Client.new(client_opts)
  end

  @doc """
  Provides the authorize url for the request phase of Ueberauth. No need to call this usually.
  """
  def authorize_url!(params \\ [], opts \\ []) do
    opts
    |> client
    |> OAuth2.Client.authorize_url!(params)
  end

  def get(token, url, headers \\ [], opts \\ []) do
    access_token = Poison.decode!(token.access_token)
    url = ~s/#{url}?access_token=#{access_token["access_token"]}&openid=#{access_token["openid"]}/
    [token: token]
    |> client
    |> OAuth2.Client.get(url, headers, opts)
  end

  def get_token!(params \\ [], options \\ []) do
    headers        = Keyword.get(options, :headers, [])
    options        = Keyword.get(options, :options, [])
    client_options = Keyword.get(options, :client_options, [])
    client         = OAuth2.Client.get_token!(client(client_options), params, headers, options)
    client.token
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    client
    |> put_param(:response_type, "code")
    |> put_param(:appid, client.client_id)
    |> put_param(:redirect_uri, client.redirect_uri)
    |> OAuth2.Strategy.AuthCode.authorize_url(params)
  end

  def get_token(client, params, headers) do
    {code, params} = Keyword.pop(params, :code, client.params["code"])
    unless code do
      raise OAuth2.Error, reason: "Missing required key `code` for `#{inspect __MODULE__}`"
    end

    client
    |> put_param(:appid, client.client_id)
    |> put_param(:code, code)
    |> put_param(:js_code, code)
    |> put_param(:secret, client.client_secret)
    |> put_header("Accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end

  defp check_config_key_exists(config, key) when is_list(config) do
    unless Keyword.has_key?(config, key) do
      raise "#{inspect (key)} missing from config :ueberauth, Ueberauth.Strategy.Wechat"
    end
    config
  end
  defp check_config_key_exists(_, _) do
    raise "Config :ueberauth, Ueberauth.Strategy.Wechat is not a keyword list, as expected"
  end
end
