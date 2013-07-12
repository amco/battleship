# Be sure to restart your server when you modify this file.

# Eventgame::Application.config.session_store :cookie_store, key: '_eventgame_session'
Eventgame::Application.config.session_store ActionDispatch::Session::CacheStore, expire_after: 1.hour

