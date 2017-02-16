module Type where

import Data.Void (Void)
import Halogen.Aff.Effects (HalogenEffects)
import Network.HTTP.Affjax (AJAX)

type State = {
    topic :: String,
    gifUrl :: String
}

data Query a = MorePlease a

type Input = String

type Output = Void

type Effects eff = HalogenEffects (ajax :: AJAX | eff)

