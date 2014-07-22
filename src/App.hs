{-# LANGUAGE TemplateHaskell #-}

module App
    where 

import           Snap
import           Snap.Snaplet.Session
import           Snap.Snaplet.Session.Backends.CookieSession
import qualified Data.ByteString.Char8 as B
import qualified Data.Text as T
import           Data.Maybe
import           Control.Lens.TH

data App = App
    { _sess        :: Snaplet (SessionManager) }

makeLenses ''App
