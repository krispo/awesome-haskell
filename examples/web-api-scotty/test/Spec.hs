{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import AwesomeHaskell.WebApi (application)
import qualified Data.ByteString.Lazy as LBS
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
import Test.Tasty.HUnit (Assertion, testCase, (@?=))

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

get :: Application -> LBS.ByteString -> [Data.Text.Text] -> IO SResponse
get app rawPath segments =
  runSession
    ( srequest
        ( SRequest
            defaultRequest
              { requestMethod = methodGet
              , rawPathInfo = LBS.toStrict rawPath
              , pathInfo = segments
              }
            LBS.empty
        )
    )
    app
