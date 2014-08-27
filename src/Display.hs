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
                     ++ "<a href=\"https://github.com/mikeizbicki/glowing-wookie\"><img style=\"position: absolute; top: 0; right: 0; border: 0; height: 149px; width: 149px; z-index: 1\" src=\"https://camo.githubusercontent.com/365986a132ccd6a44c23a9169022c0b5c890c387/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f7265645f6161303030302e706e67\" alt=\"Fork me on GitHub\" data-canonical-src=\"https://s3.amazonaws.com/github/ribbons/forkme_right_red_aa0000.png\"></a>"
			         ++ "<div id=\"header\">\n\n"
			         ++ "<h2>Which is better?</h2>\n"
			         ++ "</div>\n\n"
			         ++ "<div class=\"container\">\n"
			         ++ "<div class=\"queryobject\">\n"
			         ++ displayonething r1 r2 r3 (fst q)
                     ++ "</div>\n\n"
                     ++ "<div class=\"middle\">\n"
			         ++ "<img src=\"/img/or.png\" id=\"or\">\n"
			         ++ "</div>\n\n"
			         ++ "<div class=\"queryobject2\">\n"
			         ++ displayonething r1 r2 r3 (snd q)
			         ++ "</div>\n"
			         ++ "</div>\n\n\n"
                     -- ++ "<div>**Hover over image for description</div>\n"
			         ++ "<div id=\"footer\">\n"
                     ++ "<p id=\"pfoot\">**Hover over image for description</p>"
			         ++ "</div>\n\n"
			         ++ "</html>\n"
		             ++ "</body>\n"
			 
			 
displayonething :: Int -> Int -> Int -> QuizData -> String
{-displayonething x = "<a href=\"ex3.html\"><div class=\"queryobject\"><img src=\"/img/" 
				 ++ getPicURL x ++ "\"><p>" ++ getName x ++ "</p></div></a>\n"
-}
displayonething r1 r2 r3 x = "<form name=\"input\" action=\"/quiz" ++ show r1 ++ "/item" ++ show r2 ++ "/item" ++ show r3 ++ "\" method=\"push\" title=\"" ++ getDescription x ++ "\">\n"
				 ++ "<p><strong>" ++ getName x ++ "</strong></p>\n"
				 ++ "<input type=\"image\" src=\"/img/" ++ getPicURL x ++ "\" id=\"imgWidth\">\n"
				 ++ "</form>\n"
				 
