module QuizData
( BoolM(..)
, QuizData(..)
, parseQuizData
, readit
) where

data BoolM = Unlikely | Maybe | Definitely deriving (Read, Show, Eq, Ord)

data QuizData = Soda { getName :: String
                     , getPicURL :: String
                     } 
              | Person { getName :: String
                       , isGood :: BoolM
                       , getPicURL :: String
                       } deriving (Read, Show, Eq)
                     
parseQuizData :: String -> Maybe QuizData
parseQuizData xs
              | xs == []                    = Nothing
              | head (words xs) == "Soda"   = parseSoda endxs
              | head (words xs) == "Person" = parsePerson endxs
              | otherwise                   = Nothing
                where endxs = tail $ words $ xs
              
              
parseSoda :: [String] -> Maybe QuizData
parseSoda xs
          | length xs /= 2 = Nothing
          | otherwise      = Just $ Soda (head xs) (last xs)
          
parsePerson :: [String] -> Maybe QuizData
parsePerson xs
            | length xs == 2 = Just $ Person (head xs) (Maybe) (last xs)
            | length xs == 3 = Just $ Person (head xs) (f xs)  (last xs)
            | otherwise      = Nothing
              where f = read . head . tail
              
readit :: String -> IO String
readit filename = do
    contents <- readFile filename
    return $ parseFile $ lines contents
    
parseFile :: [String] -> String
parseFile [] = ""
parseFile (x:xs)
    | parseQuizData x == Nothing = "Not valid quiz data type\n" ++ (parseFile xs)
    | otherwise                  = (show q) ++ "\n" ++ (parseFile xs)
      where Just q = parseQuizData x