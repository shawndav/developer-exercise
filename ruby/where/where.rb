module Where

  def where(selectors)
    matches = []
    selector = selectors.shift
      self.each do |element|
        key = selector[0]
        desired_value = selector[1]
        if (element[key] == desired_value) || (desired_value.is_a?(Regexp) && (element[key] =~ desired_value))
          matches << element
        end
      end
    if selectors.length == 0
      return matches
    else
      return matches.where(selectors)
    end
  end
end



class Array
  include Where
end
