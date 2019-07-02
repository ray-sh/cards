use Mix.Config
config :logger,
  # default, support for additional log sinks
  backends: [:console],
  # purges logs with lower level than this
  compile_time_purge_level: :debug,
  sync_threshold: 0