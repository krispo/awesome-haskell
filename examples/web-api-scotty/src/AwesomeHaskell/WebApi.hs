{-# LANGUAGE OverloadedStrings #-}

module AwesomeHaskell.WebApi
  ( application
  , routes
  , runServer
  ) where

import Data.Aeson (object, (.=))
import Data.Text (Text)
import Network.Wai (Application)
import Web.Scotty (ScottyM, get, json, pathParam, scotty, scottyApp)

-- | Routes shared by the executable and in-process tests.
routes :: ScottyM ()
routes = do
  get "/health" $
    json (object ["status" .= ("ok" :: Text)])

  get "/hello/:name" $ do
    name <- pathParam "name"
    json (object ["message" .= ("Hello, " <> (name :: Text) <> "!")])

-- | Build a WAI application without opening a network port.
application :: IO Application
application = scottyApp routes

-- | Run the example server on localhost:3000.
runServer :: IO ()
runServer = scotty 3000 routes
