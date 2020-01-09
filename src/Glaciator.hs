{-# LANGUAGE TemplateHaskell #-}
module Glaciator
    ( glaciator
    ) where

import Path
import Path.IO
import Crypto.Hash.SHA1 as SHA1
import qualified Data.ByteString as B
import Data.HexString as Hex
import Control.Exception
import Control.Monad

backupRoot = $(mkAbsDir "/mnt/f/Work/zelf/glaciator_data_test")
-- backupRoot = $(mkAbsDir "/home/jorik/test_dir")


glaciator :: IO ()
glaciator = do
    items <- snd <$> listDirRecur backupRoot
    hashedItems <- mapM hashFile items
    forM_ hashedItems $ \errOrTup ->
      case errOrTup of
        Left err -> print err
        Right (path, bhash) -> do
          print (path, Hex.fromBytes bhash)

hashFile :: Path Abs File -> IO(Either IOException (Path Abs File, B.ByteString))
hashFile file = do
    errorOrContents <- handle go ( Right <$> B.readFile ( toFilePath file ))
    case errorOrContents of 
      Left err -> pure $ Left err
      Right content -> pure $ Right (file, SHA1.hash content)
  where go ::  IOException -> IO (Either IOException B.ByteString)
        go = pure . Left