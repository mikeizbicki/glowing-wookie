module Display
	where

import           System.IO
import           Data.Char
import           QuizData

						 
display :: Question -> String
display q = "<html>\n\n"
			 ++ "<head>\n"
			 ++ "<link type=\"text/css\" rel=\"stylesheet\" href=\"/css/stylesheet.css\" >\n"
			 ++ "</head>\n\n"
			 ++ "<body>\n"
			 ++ "<div id=\"header\">\n\n"
			 ++ "<h2>Which is better?</h2>\n"
			 ++ "</div>\n\n"
			 ++ "<div class=\"container\">\n"
			 ++ "<div class=\"queryobject\">\n"
			 ++ displayonething (fst q)
			 ++ "</div>\n\n"
			 ++ "<div class=\"middle\">\n"
			 ++ "<strong style=\"font-size: 100px\">or</strong>\n"
			 ++ "</div>\n\n"
			 ++ "<div class=\"queryobject\">\n"
			 ++ displayonething (snd q)
			 ++ "</div>\n"
			 ++ "**Hover over image for description\n"
			 ++ "</div>\n\n\n"
			 ++ "<div id=\"footer\">\n"
			 ++ "</div>\n\n"
			 ++ "</html>\n"
			 ++ "</body>\n"
			 
			 
displayonething :: QuizData -> String
{-displayonething x = "<a href=\"ex3.html\"><div class=\"queryobject\"><img src=\"/img/" 
				 ++ getPicURL x ++ "\"><p>" ++ getName x ++ "</p></div></a>\n"
-}
displayonething x = "<form name=\"input\" action=\"demo_form_action.asp\" method=\"push\">\n"
				 ++ "<p><strong>" ++ getName x ++ "</strong></p>\n"
				 ++ "<input type=\"image\" src=\"/img/" ++ getPicURL x ++ "\" id=\"imgWidth\">\n"
				 ++ "</form>\n"
				 
