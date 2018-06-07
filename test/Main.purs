module Test.Main where

import Bootstrap.Type (Query(..), State)
import Bootstrap.UI (eval)
import Control.Monad.State (StateT, runStateT)
import Data.Tuple (Tuple(..))
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Aff (Aff, launchAff)
import Effect.Class (liftEffect)
import Effect.Class.Console (logShow)
import Prelude (bind, discard, unit, void, ($), (/=))
import Test.Assert (assert)

main :: Effect Unit
main = void do

    let 
        initial :: State
        initial = { topic : "cat", gifUrl : "" } 

        action :: StateT State Aff Unit
        action = eval (MorePlease unit)
    
    launchAff do 
        Tuple a s <- runStateT action initial
        
        liftEffect $ assert (s.gifUrl /= "")
            
        logShow s.gifUrl
        
