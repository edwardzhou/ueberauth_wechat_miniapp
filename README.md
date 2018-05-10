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
        wechat_miniapp: {Ueberauth.Strategy.WechatMiniapp, []}
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
    /auth/wechat_miniapp/callback?code=<js_code>&iv=<iv>&encrypted_data=<encrypted_data>&signature=<signature>&raw_data=<raw_data>


## Wechat Miniapp oauth sample:
```javascript
    // try login
    // 登录
    wx.login({
        success: res => {
        if (res.code) {
            const code = res.code;

            wx.getUserInfo({withCredentials: true,
            success: user_res => {
                var form_data = {
                code: code,
                raw_data: user_res.rawData,
                signature: user_res.signature,
                encrypted_data: user_res.encryptedData,
                iv: user_res.iv
                }

                wx.request({
                url: 'https://your.domain.com/auth/wechat_miniapp/callback',
                data: form_data,
                success: login_res => {
                    console.log("login response: " + JSON.stringify(res));
                },
                fail: res => {
                console.log("login failed!")
                }
                })
            }
            })
        }
        }
    })

```

