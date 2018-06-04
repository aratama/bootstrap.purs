module Bootstrap.Type where

import Data.Void (Void)

type State = {
    topic :: String,
    gifUrl :: String
}

type Giphy = {
    data :: {
        image_url :: String
    }
}

data Query a = MorePlease a

type Input = String

type Output = Void


