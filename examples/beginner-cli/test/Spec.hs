module Main (main) where

import AwesomeHaskell.Greeting (greeting)
import Data.List (isInfixOf)
import Test.Tasty (TestTree, defaultMain, testGroup)
import Test.Tasty.HUnit (testCase, (@?=))
import Test.Tasty.QuickCheck
  ( Gen
  , Property
  , counterexample
  , elements
  , forAll
  , listOf1
  , testProperty
  )

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests =
  testGroup
    "beginner CLI"
    [ exampleTests
    , propertyTests
    ]

exampleTests :: TestTree
exampleTests =
  testGroup
    "examples"
    [ testCase "uses a default subject" $
        greeting [] @?= "Hello, Haskell!"
    , testCase "joins command-line words" $
        greeting ["Ada", "Lovelace"] @?= "Hello, Ada Lovelace!"
    ]

propertyTests :: TestTree
propertyTests =
  testGroup
    "properties"
    [ testProperty "preserves every generated name word" prop_preservesNameWords
    ]

prop_preservesNameWords :: Property
prop_preservesNameWords =
  forAll nameWords $ \names ->
    let result = greeting names
     in counterexample ("Generated greeting: " <> show result) $
          all (`isInfixOf` result) names

nameWords :: Gen [String]
nameWords = listOf1 (listOf1 (elements alphabet))

alphabet :: [Char]
alphabet = ['a' .. 'z'] <> ['A' .. 'Z']
