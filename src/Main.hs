{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Snap
import           Snap.Snaplet.Session.Backends.CookieSession
import qualified Data.ByteString.Char8 as B
import           Snap.Util.FileServe
import           App
import           Root
import           Display
import           QuizData


--Initializes the app to use Session Snaplet
appInit :: B.ByteString -> B.ByteString -> B.ByteString -> [Quiz] -> SnapletInit App App
appInit header footer about quizes = makeSnaplet "myapp" "Sample Page" Nothing $ do
    ss <- nestSnaplet "session" sess $ initCookieSessionManager "session.txt" "_session" (Just 3600)
    addRoutes ( [ ("/", sessionHandler header footer)
                , ("about", writeBS about)
                , ("img", serveDirectory "img")
                , ("css", serveDirectory "css")
                ] ++ getQuizes quizes
              )
    return $ App ss
    

    
--Main function reads html files and calls session functions
main :: IO ()
main = do
    header <- B.readFile "./src/header.html"
    footer <- B.readFile "./src/footer.html"
    about <- B.readFile "./src/about.html"
    quizes <- createQuizes
    serveSnaplet defaultConfig $ appInit header footer about quizes
    
    
getQuizes :: (MonadSnap m) => [Quiz] -> [(B.ByteString, m ())]
getQuizes xs = getQuizesH 1 xs

getQuizesH :: (MonadSnap m) => Int -> [Quiz] -> [(B.ByteString, m ())]
getQuizesH _ [] = []
getQuizesH x (q:qs) = getOneQuiz x 1 q ++ getQuizesH (x + 1) qs

getOneQuiz :: (MonadSnap m) => Int -> Int -> Quiz -> [(B.ByteString, m ())]
getOneQuiz _ _ [] = []
getOneQuiz x y (q:qs) = [(B.pack("quiz" ++ (show x) ++ "/question" ++ (show y)), writeBS $ B.pack $ display q)] ++ getOneQuiz x (y + 1) qs
