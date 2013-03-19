class String

  # Camelize the string
  def camel_case # {{{
    self.split('_').map {|c| c.capitalize}.join
  end # }}}

end
