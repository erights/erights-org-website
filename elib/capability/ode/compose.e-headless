#!/usr/bin/env e

define ode__uriGetter := <d:/e/doc/elib/capability/ode>

define extract(file, section) :any {
    if (file.text =~
    `@_<!-- #BeginEditable "$section" -->@result<!-- #EndEditable -->@_`) {
        result
    }
}

define section(file, anchor) :any {
    define `@_<TITLE>@title</TITLE>@_` := extract(file, "doctitle")
    define body := extract(file, "LongBody")
    `<hr><h1><a name="$anchor"></a>$title</h1>$body`
}

define firstSection(file) :any {
    define `@result<hr>@_` := extract(file, "LongBody")
    result
}

<ode:ode-linear.html>.text := `<html>
<head>
<title>An Ode to the Granovetter Diagram</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#FFEEDD">
<h1 align="center">Capability-based Financial Instruments</h1>
${firstSection(<ode:index.html>)}
${section(<ode:ode-objects.html>, "objects")}
${section(<ode:ode-capabilities.html>, "capabilities")}
${section(<ode:ode-protocol.html>, "protocol")}
${section(<ode:ode-pki.html>, "pki")}
${section(<ode:ode-bearer.html>, "bearer")}
${section(<ode:ode-ack.html>, "ack")}
${section(<ode:ode-references.html>, "references")}
</body>
</html>`
