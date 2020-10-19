type msgf('a, 'b) = (format4('a, Format.formatter, unit, 'b) => 'a) => 'b;

module type Logger = {
  let errorf: msgf(_, unit) => unit;
  let error: string => unit;
  let warnf: msgf(_, unit) => unit;
  let warn: string => unit;
  let infof: msgf(_, unit) => unit;
  let info: string => unit;
  let debugf: msgf(_, unit) => unit;
  let debug: string => unit;
  let tracef: msgf(_, unit) => unit;
  let trace: string => unit;
  let fn: (string, 'a => 'b, ~pp: 'b => string=?, 'a) => 'b;
};

module Level: {
  type t;

  let error: t;
  let warn: t;
  let info: t;
  let debug: t;
  let trace: t;
  let perf: t;
};

module Log: {
  let withNamespace: string => (module Logger);
  let perf: (string, unit => 'a) => 'a;
};

module Reporter: {
  type t;

  let none: t;
  let console: (~enableColors: bool=?, unit) => t;
  let file: (~truncate: bool=?, string) => t;

  let combine: (t, t) => t;
};

module App: {
  // These function should only be used by the application, not libraries
  let isLevelEnabled: Level.t => bool;
  let isNamespaceEnabled: string => bool;

  let enable: Reporter.t => unit;
  let disable: unit => unit;

  let setLevel: Level.t => unit;

  /**
   * setNamespaceFilter(filters)
   *
   * where `filter` is a comma-separated list of glob patterns to include,
   * optionally prefixed with a `-` to negate it. A blank string includes
   * everything, and is the default.
   *
   * E.g.
   *   setNamespaceFilter("Oni2.*, -Revery*")
   */
  let setNamespaceFilter: string => unit;
};

module Testing: {let setTimeFn: (unit => float) => unit;};
