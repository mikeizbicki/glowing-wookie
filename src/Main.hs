{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Snap
import           Snap.Snaplet.Session.Backends.CookieSession
import qualified Data.ByteString.Char8 as B
import           App
import           Root


--Initializes the app to use Session Snaplet
appInit :: B.ByteString -> B.ByteString -> B.ByteString -> SnapletInit App App
appInit header footer about = makeSnaplet "myapp" "Sample Page" Nothing $ do
    ss <- nestSnaplet "session" sess $ initCookieSessionManager "session.txt" "_session" (Just 3600)
    addRoutes [ ("/", sessionHandler header footer)
              , ("about", writeBS about)
              ]
    return $ App ss


--Main function reads html files and calls session functions
main :: IO ()
main = do
    header <- B.readFile "./src/header.html"
    footer <- B.readFile "./src/footer.html"
    about <- B.readFile "./src/about.html"
    serveSnaplet defaultConfig $ appInit header footer about
