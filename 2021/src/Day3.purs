module Aoc.Day3 where

import Prelude

import Data.Array as Array
import Data.Foldable (sum)
import Data.Int (binary, pow)
import Data.Int as Int
import Data.Maybe (Maybe(..))
import Data.String.CodeUnits (toCharArray)
import Data.String.CodeUnits as String
import Data.String.Utils (lines)
import Data.Typelevel.Num (D12)
import Data.Vec (Vec)
import Data.Vec as Vec
import Effect (Effect)
import Effect.Class.Console (logShow)
import Node.Encoding (Encoding(..))
import Node.FS.Sync (readTextFile)

type BitArray = Vec D12 Boolean

parse :: String -> Array BitArray
parse = lines
  >>> Array.mapMaybe
    ( toCharArray
        >>> Array.mapMaybe charToBool
        >>> Vec.fromArray
    )
  where
  charToBool '0' = Just false
  charToBool '1' = Just true
  charToBool _ = Nothing

part1 :: Array BitArray -> Maybe Int
part1 = map (map bitToSign)
  >>> sum
  >>> map toBit
  >>> Array.fromFoldable
  >>> String.fromCharArray
  >>> Int.fromStringAs binary
  >>> map \n -> n * (2 `pow` 12 - 1 - n)
  where
  toBit x = if x > 0 then '1' else '0'
  bitToSign bit = if bit then 1 else -1

part2Impl :: Boolean -> Array (Array Boolean) -> Maybe Int
part2Impl bias = go 0
  where
  boolToChar = if _ then '1' else '0'

  go index arr =
    if Array.length remaining <= 1 then
      do
        first <- Array.head remaining
        first
          # map boolToChar
          # String.fromCharArray
          # Int.fromStringAs binary
    else
      go (index + 1) remaining
    where
    { no, yes } = arr # Array.partition \bits -> Array.index bits index
      == Just true

    remaining = case Array.length yes, Array.length no of
      la, lb -> if (la >= lb) == bias then yes else no

part2 :: Array (Array Boolean) -> Maybe Int
part2 arr = ado
  oxygen <- part2Impl true arr
  co2 <- part2Impl false arr
  in oxygen * co2

main :: Effect Unit
main = do
  content <- readTextFile UTF8 "inputs/3.txt"
  logShow $ part1 $ parse content
  logShow $ part2 $ map Array.fromFoldable $ parse content