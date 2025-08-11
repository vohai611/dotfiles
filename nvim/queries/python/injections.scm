;extends
(string
  (string_content) @injection.content
  (#match? @injection.content "^--sql.+(select|with|SELECT|WITH)")
  (#set! injection.language "sql")
  (#set! injection.include-children)
  )

