 * All files `extensions/\d\d_*.rb` are loaded from smallest to greatest number.
  If `$ext` contains a proper instance of `Extension` after loading, this instance is
  added to the list of extensions.
  The specified values for codes and parameters will be added to the global parameter codes and parameters, resp.
  Present values are never overwritten.

 * Modules can never change values in `$params`

 * Modules can not change the class `Extension`

 * Modules' `exec` function returns `[success, log]` (`boolean`, `String`)

 * Modules return to the working directory they are called with before they return

 * When modules are called, working directory is the temporary directory