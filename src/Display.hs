module Display
	where

import           System.IO
import           Data.Char
import           QuizData

						 
display :: Int -> Int -> Question -> String
display r1 r2 q = "<html>\n\n"
			 ++ "<head>\n"
			 ++ "<link type=\"text/css\" rel=\"stylesheet\" href=\"/css/stylesheet.css\" >\n"
			 ++ "</head>\n\n"
			 ++ "<body>\n"
			 ++ "<div id=\"header\">\n\n"
			 ++ "<h2>Which is better?</h2>\n"
			 ++ "</div>\n\n"
			 ++ "<div class=\"container\">\n"
			 ++ "<div class=\"queryobject\">\n"
			 ++ displayonething r1 r2 "left" (fst q)
			 ++ "</div>\n\n"
			 ++ "<div class=\"middle\">\n"
			 ++ "<strong style=\"font-size: 100px\">or</strong>\n"
			 ++ "</div>\n\n"
			 ++ "<div class=\"queryobject\">\n"
			 ++ displayonething r1 r2 "right" (snd q)
			 ++ "</div>\n"
			 ++ "</div>\n\n\n"
             ++ "<div>**Hover over image for description</div>\n"
			 ++ "<div id=\"footer\">\n"
			 ++ "</div>\n\n"
			 ++ "</html>\n"
			 ++ "</body>\n"
			 
			 
displayonething :: Int -> Int -> String -> QuizData -> String
{-displayonething x = "<a href=\"ex3.html\"><div class=\"queryobject\"><img src=\"/img/" 
				 ++ getPicURL x ++ "\"><p>" ++ getName x ++ "</p></div></a>\n"
-}
displayonething r1 r2 ans x = "<form name=\"input\" action=\"/quiz" ++ show r1 ++ "/question" ++ show r2 ++ "\" method=\"post\" title=\"" ++ getDescription x ++ "\">\n"
				 ++ "<p><strong>" ++ getName x ++ "</strong></p>\n"
				 ++ "<input type=\"image\" name=\"Question\" value=\"" ++ ans ++ "\"src=\"/img/" ++ getPicURL x ++ "\" id=\"imgWidth\">\n"
				 ++ "</form>\n"
				 
