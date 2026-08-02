module Main (main) where

import AwesomeHaskell.Greeting (greeting)
import System.Environment (getArgs)

main :: IO ()
main = do
  arguments <- getArgs
  putStrLn (greeting arguments)
