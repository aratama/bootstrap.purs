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
  = MorePlease a
  | SetTopic String (State -> a)

type Input
  = String

type Message
  = Void
