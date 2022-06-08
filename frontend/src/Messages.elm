module Messages exposing (..)

import Http
import Time


-- Update accepts this type
type Message =
    DoRequest Time.Posix
  | GotText (Result Http.Error String)
  | SidebarMsg SidebarMsg



-- Messages that sidebar items produce
type SidebarMsg =
    SidebarItemClicked