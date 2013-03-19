class Hash

  # Transform keys into camel case string
  #
  # @example
  #   {
  #     :image_id => 1
  #   }.camel_case_keys
  #   # => {"ImageId" => 1}
  def camel_case_keys # {{{
    self.inject({}) do |result, element|
      result.merge({element[0].to_s.camel_case => element[1]})
    end
  end # }}}

end
