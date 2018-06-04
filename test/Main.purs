module Test.Main where

import Bootstrap.Type (Query(..), State)
import Bootstrap.UI (eval)
import Control.Monad.State (StateT, runStateT)
import Data.Tuple (Tuple(..))
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Aff (Aff, launchAff)
import Effect.Class.Console (error, logShow)
import Prelude (bind, discard, unit, void, when, (==))

main :: Effect Unit
main = void do

    let 
        initial :: State
        initial = { topic : "cat", gifUrl : "" } 

        action :: StateT State Aff Unit
        action = eval (MorePlease unit)
    
    launchAff do 
        Tuple a s <- runStateT action initial
        when (s.gifUrl == "") do 
            error "invalid state at gitUrl"
                
        logShow s.gifUrl
        
