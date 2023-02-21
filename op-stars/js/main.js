!(function (e, n, t) {
  function o(e, n) {
    return typeof e === n;
  }
  function s() {
    var e, n, t, s, i, a, r;
    for (var l in c)
      if (c.hasOwnProperty(l)) {
        if (
          ((e = []),
          (n = c[l]),
          n.name &&
            (e.push(n.name.toLowerCase()),
            n.options && n.options.aliases && n.options.aliases.length))
        )
          for (t = 0; t < n.options.aliases.length; t++)
            e.push(n.options.aliases[t].toLowerCase());
        for (s = o(n.fn, "function") ? n.fn() : n.fn, i = 0; i < e.length; i++)
          (a = e[i]),
            (r = a.split(".")),
            1 === r.length
              ? (Modernizr[r[0]] = s)
              : (!Modernizr[r[0]] ||
                  Modernizr[r[0]] instanceof Boolean ||
                  (Modernizr[r[0]] = new Boolean(Modernizr[r[0]])),
                (Modernizr[r[0]][r[1]] = s)),
            f.push((s ? "" : "no-") + r.join("-"));
      }
  }
  function i(e) {
    var n = u.className,
      t = Modernizr._config.classPrefix || "";
    if ((p && (n = n.baseVal), Modernizr._config.enableJSClass)) {
      var o = new RegExp("(^|s)" + t + "no-js(s|$)");
      n = n.replace(o, "$1" + t + "js$2");
    }
    Modernizr._config.enableClasses &&
      ((n += " " + t + e.join(" " + t)),
      p ? (u.className.baseVal = n) : (u.className = n));
  }
  function a() {
    return "function" != typeof n.createElement
      ? n.createElement(arguments[0])
      : p
      ? n.createElementNS.call(n, "http://www.w3.org/2000/svg", arguments[0])
      : n.createElement.apply(n, arguments);
  }
  function r() {
    var e = n.body;
    return e || ((e = a(p ? "svg" : "body")), (e.fake = !0)), e;
  }
  function l(e, t, o, s) {
    var i,
      l,
      f,
      c,
      d = "modernizr",
      p = a("div"),
      h = r();
    if (parseInt(o, 10))
      for (; o--; )
        (f = a("div")), (f.id = s ? s[o] : d + (o + 1)), p.appendChild(f);
    return (
      (i = a("style")),
      (i.type = "text/css"),
      (i.id = "s" + d),
      (h.fake ? h : p).appendChild(i),
      h.appendChild(p),
      i.styleSheet
        ? (i.styleSheet.cssText = e)
        : i.appendChild(n.createTextNode(e)),
      (p.id = d),
      h.fake &&
        ((h.style.background = ""),
        (h.style.overflow = "hidden"),
        (c = u.style.overflow),
        (u.style.overflow = "hidden"),
        u.appendChild(h)),
      (l = t(p, e)),
      h.fake
        ? (h.parentNode.removeChild(h), (u.style.overflow = c), u.offsetHeight)
        : p.parentNode.removeChild(p),
      !!l
    );
  }
  var f = [],
    c = [],
    d = {
      _version: "3.6.0",
      _config: {
        classPrefix: "",
        enableClasses: !0,
        enableJSClass: !0,
        usePrefixes: !0,
      },
      _q: [],
      on: function (e, n) {
        var t = this;
        setTimeout(function () {
          n(t[e]);
        }, 0);
      },
      addTest: function (e, n, t) {
        c.push({ name: e, fn: n, options: t });
      },
      addAsyncTest: function (e) {
        c.push({ name: null, fn: e });
      },
    },
    Modernizr = function () {};
  (Modernizr.prototype = d), (Modernizr = new Modernizr());
  var u = n.documentElement,
    p = "svg" === u.nodeName.toLowerCase(),
    h = d._config.usePrefixes
      ? " -webkit- -moz- -o- -ms- ".split(" ")
      : ["", ""];
  (d._prefixes = h),
    Modernizr.addTest("csspositionsticky", function () {
      var e = "position:",
        n = "sticky",
        t = a("a"),
        o = t.style;
      return (
        (o.cssText = e + h.join(n + ";" + e).slice(0, -e.length)),
        -1 !== o.position.indexOf(n)
      );
    });
  var m = (d.testStyles = l);
  Modernizr.addTest("touchevents", function () {
    var t;
    if ("ontouchstart" in e || (e.DocumentTouch && n instanceof DocumentTouch))
      t = !0;
    else {
      var o = [
        "@media (",
        h.join("touch-enabled),("),
        "heartz",
        ")",
        "{#modernizr{top:9px;position:absolute}}",
      ].join("");
      m(o, function (e) {
        t = 9 === e.offsetTop;
      });
    }
    return t;
  }),
    s(),
    i(f),
    delete d.addTest,
    delete d.addAsyncTest;
  for (var v = 0; v < Modernizr._q.length; v++) Modernizr._q[v]();
  e.Modernizr = Modernizr;
})(window, document);
