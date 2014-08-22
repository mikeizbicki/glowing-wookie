module Display
	where

import           System.IO
import           Data.Char
import           QuizData

						 
display :: Int -> Int -> Int -> Question -> String
display r1 r2 r3 q = "<html>\n\n"
			         ++ "<head>\n"
			         ++ "<link type=\"text/css\" rel=\"stylesheet\" href=\"/css/stylesheet.css\" >\n"
			         ++ "</head>\n\n"
			         ++ "<body>\n"
			         ++ "<div id=\"header\">\n\n"
			         ++ "<h2>Which is better?</h2>\n"
			         ++ "</div>\n\n"
			         ++ "<div class=\"container\">\n"
			         ++ "<div class=\"queryobject\">\n"
			         ++ displayonething r1 r2 r3 (fst q)
                     ++ "</div>\n\n"
                     ++ "<div class=\"middle\">\n"
			         ++ "<strong style=\"font-size: 100px\">or</strong>\n"
			         ++ "</div>\n\n"
			         ++ "<div class=\"queryobject\">\n"
			         ++ displayonething r1 r2 r3 (snd q)
			         ++ "</div>\n"
			         ++ "</div>\n\n\n"
                     ++ "<div>**Hover over image for description</div>\n"
			         ++ "<div id=\"footer\">\n"
			         ++ "</div>\n\n"
			         ++ "</html>\n"
		             ++ "</body>\n"
			 
			 
displayonething :: Int -> Int -> Int -> QuizData -> String
displayonething r1 r2 r3 x = "<form name=\"input\" action=\"/quiz" ++ show r1 ++ "/item" ++ show r2 ++ "/item" ++ show r3 ++ "\" method=\"push\" title=\"" ++ getDescription x ++ "\">\n"
				 ++ "<p><strong>" ++ getName x ++ "</strong></p>\n"
				 ++ "<input type=\"image\" src=\"/img/" ++ getPicURL x ++ "\" id=\"imgWidth\">\n"
				 ++ "</form>\n"
				 
