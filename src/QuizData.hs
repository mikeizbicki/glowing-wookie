module QuizData
( BoolM(..)
, QuizData(..)
, parseQuizData
, readit
, readQuizN
, toQuizList
) where

import System.Random



data BoolM = Unlikely | Maybe | Definitely deriving (Read, Show, Eq, Ord)

data QuizData = Soda { getName :: String
                     , getPicURL :: String
                     } 
              | Person { getName :: String
                       , isGood :: BoolM
                       , getPicURL :: String
                       }
              | Airline { getName :: String
                        , getPicURL :: String
                        } 
              | PoltIssue { getName :: String
                          , getPicURL :: String
                          } deriving (Read, Show, Eq)
                          
                          

parseQuizData :: String -> Maybe QuizData
parseQuizData xs
              | xs == []             = Nothing
              | first == "Soda"      = parseSoda endxs
              | first == "Person"    = parsePerson endxs
              | first == "Airline"   = parseAirline endxs
              | first == "PoltIssue" = parsePoltIssue endxs
              | otherwise            = Nothing
                where endxs = tail $ words xs
                      first = head $ words xs
              
parseSoda :: [String] -> Maybe QuizData
parseSoda xs
          | length xs /= 2 = Nothing
          | otherwise      = Just $ Soda (headwSpace xs) (last xs)
          
parsePerson :: [String] -> Maybe QuizData
parsePerson xs
            | length xs == 2 = Just $ Person (headwSpace xs) (Maybe) (last xs)
            | length xs == 3 = Just $ Person (headwSpace xs) (f xs)  (last xs)
            | otherwise      = Nothing
              where f = read . head . tail
              
parseAirline :: [String] -> Maybe QuizData
parseAirline xs
             | length xs /= 2 = Nothing
             | otherwise      = Just $ Airline (headwSpace xs) (last xs)
              
parsePoltIssue :: [String] -> Maybe QuizData
parsePoltIssue xs
               | length xs /= 2 = Nothing
               | otherwise      = Just $ PoltIssue (headwSpace xs) (last xs)
              
              
              
readit :: String -> IO String
readit filename = do
    contents <- readFile filename
    return $ parseFile $ lines contents
    
parseFile :: [String] -> String
parseFile [] = ""
parseFile (x:xs)
    | parseQuizData x == Nothing = "Not valid quiz data type<br>" ++ (parseFile xs)
    | otherwise                  = (show q) ++ "<br>" ++ (parseFile xs)
      where Just q = parseQuizData x
      
headwSpace :: [String] -> String
headwSpace xs = map underscoreToSpace $ head xs 

underscoreToSpace :: Char -> Char
underscoreToSpace '_' = ' '
underscoreToSpace c = c



readQuizN :: Int -> IO String
readQuizN x
    | x < 0     = return "Oops! No quiz!"
    | x > 6     = return "Oops! No quiz!"
    | otherwise = readit $ "./src/data/quiz" ++ (show x) ++ ".txt"

    
    
toQuizList :: [String] -> [Maybe QuizData]
toQuizList xs = map parseQuizData xs



{-randomQuiz :: String -> IO String
randomQuiz filename = do
    contents <- readFile filename
    IO-stringify $ unMaybeQuizList $ map parseQuizData $ lines contents-}

unMaybeQuizList :: [Maybe QuizData] -> [QuizData]
unMaybeQuizList xs = let f = (\(Just x) -> x)
                     in map f $ filter (/= Nothing) xs
                
                
               
{-main = do 
    quizdata <- readFile "./quizdata.txt"
    putStrLn $ show $ head $ randomQuiz $ toQuizList $ lines quizdata-}