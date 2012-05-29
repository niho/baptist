require "baptist/version"
require "base64"
require "digest/md5"

# A tool for generating unique and well-formed URIs.
module Baptist

  SEPARATOR = '/'
  SPACE = '-'
  MULTIPLIER = 1
  ENCODING = 'UTF-8'

  # Generates a well-formed and unique URI from an array of strings.
  #
  # === Usage
  #
  #   Baptist.generate                                               # => 'hMAkUyhyqdPkSDWHaUtptQ'
  #   Baptist.generate('Arthur Russell')                             # => 'Arthur-Russell'
  #   Baptist.generate('Arthur Russell', :space => '_')              # => 'Arthur_Russell'
  #   Baptist.generate(['Arthur Russell', 'Calling Out of Context']) # => 'Arthur-Russell/Calling-Out-of-Context'
  #   Baptist.generate(['Rihanna', 'Loud'], :modifier => 'Explicit') # => 'Rihanna/Loud-(Explicit)'
  #
  # === Uniqueness
  #
  # To guarantee the generated URI is unique:
  #
  #   Baptist.generate('Arthur Russell', :multiplier => '*') do |uri|
  #     Resource.find_by_uri(uri)
  #   end
  #
  # Will take the <tt>:multiplier</tt> character and multiply it for each time
  # the block returns <tt>false</tt> and add that to the end of the URI. So if
  # there were three name collisions when running the code above the resulting
  # URI would be 'Arthur-Russell-***'.
  #
  # The default multiplier is simply the Integer 1, which will result in an
  # incrementing number being added to the end of the URI.
  #
  # === Options
  #
  #   :space - Space character (default: '-')
  #   :separator - Separator character (default: '/')
  #   :modifier - Will add a modifier string in parentheses at the end of the generated URI
  #   :multiplier - The object to multiply with to find a unique URI (default: 1)
  #   :encoding - Force this encoding (default: 'UTF-8')
  #
  def generate(names = [], options = {})
    options = { :space => SPACE,
                :separator => SEPARATOR,
                :multiplier => MULTIPLIER,
                :encoding => ENCODING }.merge(options)

    names = (names.is_a?(Array) ? names : [names]).compact
    names = [generate_name] if names.empty?
    names = names.map do |name|
      escape(name, options)
    end

    uri = names.join(options[:separator]) +
      (options[:modifier] ? "#{options[:space]}(#{escape(options[:modifier], options)})" : '')

    if block_given?
      return uri if yield(uri)
      (1..100).each do |i|
        s = uri + options[:space] + (options[:multiplier] * i).to_s
        if yield(s)
          return s
        end
      end
    end

    uri
  end
  module_function :generate

protected

  def generate_name
    Base64.encode64(
      Digest::MD5.digest("#{Time.now}-#{(0...50).map{ ('a'..'z').to_a[rand(26)] }.join}")
    ).gsub('/','x').gsub('+','y').gsub('=','').strip
  end
  module_function :generate_name

  def escape(s, options = {})
    s = encode(s, options[:encoding])
    regexp = case
      when RUBY_VERSION >= "1.9" && s.encoding === Encoding.find('UTF-8')
        /([^ a-zA-Z0-9_\.\-!~*'()\/]+)/u
      else
        /([^ a-zA-Z0-9_\.\-!~*'()\/]+)/n
      end
    s.to_s.gsub(regexp) {
      '%'+$1.unpack('H2'*bytesize($1)).join('%').upcase
    }.tr(' ', options[:space]).tr('/', options[:space])
  end
  module_function :escape

  # Converts string to given encoding; uses String#encode under Ruby 1.9 and
  # does nothing under 1.8.
  if ''.respond_to?(:encode)
    def encode(s, encoding)
      s.to_s.encode(encoding)
    end
  else
    def encode(s, encoding)
      s.to_s
    end
  end
  module_function :encode

  # Return the bytesize of String; uses String#size under Ruby 1.8 and
  # String#bytesize under 1.9.
  if ''.respond_to?(:bytesize)
    def bytesize(string)
      string.bytesize
    end
  else
    def bytesize(string)
      string.size
    end
  end
  module_function :bytesize

end
