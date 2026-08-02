{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import AwesomeHaskell.WebApi (application)
import Data.ByteString (ByteString)
import qualified Data.ByteString.Lazy as LBS
import Data.Text (Text)
import Network.HTTP.Types (methodGet, status200, status404)
import Network.Wai (Application, defaultRequest, pathInfo, rawPathInfo, requestMethod)
import Network.Wai.Test
  ( SRequest (SRequest)
  , SResponse
  , runSession
  , simpleBody
  , simpleStatus
  , srequest
  )
import Test.Tasty (TestTree, defaultMain, testGroup)
import Test.Tasty.HUnit (testCase, (@?=))

main :: IO ()
main = do
  app <- application
  defaultMain (tests app)

tests :: Application -> TestTree
tests app =
  testGroup
    "web-api-scotty"
    [ testCase "health endpoint" $ do
        response <- get app "/health" ["health"]
        simpleStatus response @?= status200
        simpleBody response @?= "{\"status\":\"ok\"}"
    , testCase "path parameter" $ do
        response <- get app "/hello/Ada" ["hello", "Ada"]
        simpleStatus response @?= status200
        simpleBody response @?= "{\"message\":\"Hello, Ada!\"}"
    , testCase "unknown route" $ do
        response <- get app "/missing" ["missing"]
        simpleStatus response @?= status404
    ]

get :: Application -> ByteString -> [Text] -> IO SResponse
get app rawPath segments =
  runSession
    ( srequest
        ( SRequest
            defaultRequest
              { requestMethod = methodGet
              , rawPathInfo = rawPath
              , pathInfo = segments
              }
            LBS.empty
        )
    )
    app
