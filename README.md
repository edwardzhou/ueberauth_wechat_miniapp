# Überauth Wechat Miniapp

> Wechat Miniapp OAuth2 strategy for Überauth.

## Installation

1. Add `:ueberauth_wechat_miniapp` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:ueberauth_wechat_miniapp, github: "edwardzhou/ueberauth_wechat_miniapp"}]
    end
    ```

1. Add the strategy to your applications:

    ```elixir
    def application do
      [applications: [:ueberauth_wechat_miniapp]]
    end
    ```

1. Add Wechat to your Überauth configuration:

    ```elixir
    config :ueberauth, Ueberauth,
      providers: [
        wechat: {Ueberauth.Strategy.WechatMiniapp, []}
      ]
    ```

1.  Update your provider configuration:

    ```elixir
    config :ueberauth, Ueberauth.Strategy.WechatMiniapp.OAuth,
      client_id: System.get_env("WECHAT_MINIAPP_APPID"),
      client_secret: System.get_env("WECHAT_MINIAPP_SECRET")
    ```

1.  Include the Überauth plug in your controller:

    ```elixir
    defmodule MyApp.AuthController do
      use MyApp.Web, :controller

      pipeline :browser do
        plug Ueberauth
        ...
       end
    end
    ```

1.  Create the request and callback routes if you haven't already:

    ```elixir
    scope "/auth", MyApp do
      pipe_through :browser

      get "/:provider/callback", AuthController, :callback
      post "/:provider/callback", AuthController, :callback
    end
    ```

1. You controller needs to implement callbacks to deal with `Ueberauth.Auth` and `Ueberauth.Failure` responses.

For an example implementation see the [Überauth Example](https://github.com/ueberauth/ueberauth_example) application.

## Calling
    get or post
    /auth/wechat_miniapp?code=<js_code>&iv=<iv>&encrypted_data=<encrypted_data>&signature=<signature>&raw_data=<raw_data>

