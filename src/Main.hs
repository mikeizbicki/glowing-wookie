{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE GADTs #-}
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
import           System.Random
import           Snap.Snaplet.Session
import qualified Data.Text as T
import           Data.Maybe


--Initializes the app to use Session Snaplet
appInit :: B.ByteString -> [[QuizData]] -> SnapletInit App App
appInit about quizes = makeSnaplet "myapp" "glowingwookie" Nothing $ do
    ss <- nestSnaplet "session" sess $ initCookieSessionManager "session.txt" "_session" (Just 3600)
    addRoutes ( [ ("/", enterQuiz)
                , ("about", writeBS about)
                , ("img", serveDirectory "img")
                , ("css", serveDirectory "css")
                ] ++ getQuizes quizes 
              )
    return $ App ss
    

    
--Main function reads html files and calls session functions
main :: IO ()
main = do
    about <- B.readFile "./src/about.html"
    quizes <- createQuizes
    serveSnaplet defaultConfig $ appInit about quizes
    
    
getQuizes :: (MonadSnap m, Handler App App ~ m) => [[QuizData]] -> [(B.ByteString, m ())]
getQuizes xs = getQuizesH 1 xs
    where listOfSizes = map length xs
    
          getQuizesH :: (MonadSnap m, Handler App App ~ m) => Int -> [[QuizData]] -> [(B.ByteString, m ())]
          getQuizesH _ [] = []
          getQuizesH x (q:qs) = let intTuples = [ (a,b) | a <- [1..quizSize], b <- [1..quizSize], a /= b ]
                                    quizSize = length q
                                in getOneQuiz x intTuples q ++ getQuizesH (x + 1) qs 
                                
          getOneQuiz :: (MonadSnap m, Handler App App ~ m) => Int -> [(Int,Int)] -> [QuizData] -> [(B.ByteString, m ())]
          getOneQuiz _ [] _ = []
          getOneQuiz x (i:intTuples) qs = [(B.pack("quiz" ++ (show x) ++ "/item" ++ (show $ fst i) ++ "/item" ++ (show $ snd i)), method GET mkPage <|> method POST setter)] ++ getOneQuiz x intTuples qs
              where 
                  mkPage = do
                      sessionList <- with sess $ sessionToList
                      let numAns = show $ fromMaybe "0" $ lookup "counter" sessionList
                      let mR = lookup "referer" sessionList
                      case mR of
                          Just r -> return ()
                          Nothing -> do
                              mRef <- getReferer
                              case mRef of
                                  Just ref -> withSession sess . withTop sess $ setInSession "referer" ref
                                  Nothing -> return ()
                      sessionList <- with sess $ sessionToList
                      r1 <- liftIO $ randomRIO (1,length xs)
                      r2 <- liftIO $ randomRIO (1,listOfSizes !! (r1 - 1) )
                      r3 <- randomNotNumIO r1 r2
                      writeBS $ B.pack $ display r1 r2 r3 numAns (qs !! (fst i - 1),qs !! (snd i - 1))
                      return ()
                      
                  setter = do
                      mvalue <- getParam "Question"
                      withSession sess . withTop sess $ setInSession ("Question") (convert mvalue)
                      sessionList <- with sess $ sessionToList
                      let mC = lookup "counter" sessionList
                      case mC of
                          Just c -> withSession sess . withTop sess $ setInSession "counter" $ addOne c
                          Nothing -> withSession sess . withTop sess $ setInSession "counter" "1"
                      let ref = lookup "referer" sessionList
                      --Gets CSRF token from session data
                      csrf <- with sess $ csrfToken
                      --Writes user data to csv file
                      liftIO $ putStrLn $ convertStr mvalue
                      writeData (convertStr mvalue) (show csrf) (show $ fromMaybe "" ref)
                      mkPage
                  
                  convert = T.pack . B.unpack . fromMaybe "set-error"
                  convertStr = show . B.unpack . fromMaybe ""
                  randomNotNumIO r1 r2 = do
                      r3 <- liftIO $ randomRIO (1,listOfSizes !! (r1 - 1) )
                      if r2 /= r3 then return r3
                                  else randomNotNumIO r1 r2


-- Redirects user to random page upon visiting home address
enterQuiz :: Handler App App ()
enterQuiz = do
        gen <- liftIO getStdGen
        let (rand, gen1) = randomR (1, 3) gen :: (Int, StdGen) -- 1-3 b/c =3 quizzes
        let quiz = show rand
        let (rand1, gen2) = randomR (1, 40) gen1 :: (Int, StdGen) -- 1-40 b/c ~40 questions
        let (rand2, _) = randomR (1, 40) gen2 :: (Int, StdGen)
        if rand1 == rand2
            then enterQuiz
            else do
                let item1 = show rand1
                let item2 = show rand2
                redirect' (B.pack $ "quiz" ++ quiz ++ "/item" ++ item1 ++ "/item" ++ item2) 307
