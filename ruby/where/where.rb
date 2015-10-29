module Where

  def where(selectors)
    matches = []
    selectors.each do |selector|
      self.each do |element|
        key = selector[0]
        desired_value = selector[1]
        if (element[key] == desired_value) || (desired_value.is_a?(Regexp) && (element[key] =~ desired_value))
          matches << element
        end
      end
    end
    return matches
  end

  # def new_where(selectors)
  #   matches = []
  #     if selector.length == 1
  #       self.each do |element|
  #         key = selector[0]
  #         desired_value = selector[1]
  #         if (element[key] == desired_value) || (desired_value.is_a?(Regexp) && (element[key] =~ desired_value))
  #           matches << element
  #         end
  #       end
  #     else
  #       matches =
  #     end
  #   return matches
  # end

end



class Array
  include Where
end


