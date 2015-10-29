module Where

  #This is my initial solution. It uses each to iterate through and push matches to an array.

  # def where(selectors)
  #   matches = []
  #   selector = selectors.shift
  #     self.each do |element|
  #       key = selector[0]
  #       desired_value = selector[1]
  #       if (element[key] == desired_value) || (desired_value.is_a?(Regexp) && (element[key] =~ desired_value))
  #         matches << element
  #       end
  #     end
  #   if selectors.length == 0
  #     return matches
  #   else
  #     return matches.where(selectors)
  #   end
  # end


  #This is my refactored solution. It uses the select method, which I think is more concise / easier to understand. Both solutions work, so I left the initial solution commented above for reference.

  def where(selectors)
      selector = selectors.shift
      key = selector[0]
      desired_value = selector[1]
      if desired_value.is_a?(Regexp)
        matches = self.select{|element| element[key] =~ desired_value }
      else
        matches = self.select{|element| element[key] == desired_value }
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

