module Reversi.Client.Tatsuki (TatsukiClient) where

import Control.Applicative
import Data.Bits
import Reversi.Tatsuki
import Reversi.Command
import Reversi.Client

newtype TatsukiClient = TatsukiClient Board
instance Client TatsukiClient where
  initialize =  resetSearchLog >> return (TatsukiClient initialBoard)
  play (TatsukiClient board) _ = edgeToMv <$> findEdge board
  doMove (TatsukiClient board) mv _ = return $ TatsukiClient $ moveBoard (mvToEdge mv) board
  putInfo (TatsukiClient board) = putStrLn "hoge"

edgeToMv :: Edge -> Mv
edgeToMv Nothing = Pass
edgeToMv (Just pos) = M ((fromIntegral pos .&. 7) + 1) ((fromIntegral pos `shiftR` 3) + 1)

mvToEdge :: Mv -> Edge
mvToEdge Pass = Nothing
mvToEdge GiveUp = Nothing
mvToEdge (M x y) = Just $ fromIntegral $ (x - 1) .|. (y - 1) `shiftL` 3
