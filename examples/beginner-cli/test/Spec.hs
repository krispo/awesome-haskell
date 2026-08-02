module Main (main) where

import AwesomeHaskell.Greeting (greeting)
import Control.Monad (unless)
import System.Exit (exitFailure)

main :: IO ()
main = do
  assertEqual "default greeting" "Hello, Haskell!" (greeting [])
  assertEqual "named greeting" "Hello, Ada Lovelace!" (greeting ["Ada", "Lovelace"])
  putStrLn "All beginner CLI tests passed."

assertEqual :: String -> String -> String -> IO ()
assertEqual label expected actual =
  unless (expected == actual) $ do
    putStrLn ("Test failed: " <> label)
    putStrLn ("Expected: " <> show expected)
    putStrLn ("Actual:   " <> show actual)
    exitFailure
