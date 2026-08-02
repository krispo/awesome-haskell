module AwesomeHaskell.Greeting
  ( greeting
  ) where

-- | Build a friendly greeting from zero or more command-line words.
greeting :: [String] -> String
greeting [] = "Hello, Haskell!"
greeting names = "Hello, " <> unwords names <> "!"
