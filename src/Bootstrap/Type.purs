module Bootstrap.Type where

import Data.Void (Void)

type State
  = { topic :: String
    , gifUrl :: String
    }

type Giphy
  = { data ::
        { image_url :: String
        }
    }

data Action
  = FetchImage

data Query a
  = SetTopic String a
  | GetTopic (String -> a)

type Input
  = String

type Message
  = Void
