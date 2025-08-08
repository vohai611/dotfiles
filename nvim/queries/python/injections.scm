;extends
((string_content) @injection.content

	   (#set! injection.combined)
	   (#set! injection.language "sql")
	   (#set! injection.include-children)



	   ) @_x

  (#match?  @_x "--sql.+[(select)|(with)]")

