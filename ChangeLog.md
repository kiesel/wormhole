Wormhole ChangeLog
==================

v?.?.?
------
* Provide zsh plugin for starting server / client
  (@kiesel)

* Rewrite guest scripts as shell functions
  (@kiesel)

* Rename host script to `wormhole.sh`
  (@kiesel)

* Use `flock` to protect against double run
  (@kiesel)

* Drop legacy host environment variable names
  (@kiesel)

v1.0.0
------
* Finally released 2015-12-03
  (@kiesel)

* Includes client invocation scripts: `expl`, `s`, `start`, `term`
  (@kiesel)

* Introduce new convention for environment configuration names: prefix
  variables with WORMHOLE_ (@kiesel)