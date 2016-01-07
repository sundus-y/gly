require 'stringio'

module Gly
  # parses gly source
  class Parser
    def initialize(syllable_separator=nil)
      @syllable_separator = syllable_separator || '--'
    end

    def parse(source)
      if source.is_a? String
        if File.file? source
          parse_fname source
        elsif source == '-'
          parse_io STDIN
        else
          parse_str source
        end
      else
        parse_io source
      end
    end

    def parse_fname(str)
      File.open(str) do |fr|
        parse_io fr
      end
    end

    def parse_str(str)
      parse_io(StringIO.new(source))
    end

    def parse_io(io)
      @doc = Document.new
      @score = ParsedScore.new

      if io.respond_to? :path
        @doc.path = io.path
      end

      io.each do |line|
        line = strip_comments(line)

        if empty? line
          next
        elsif new_score? line
          push_score
          @score = ParsedScore.new
        elsif header_start? line
          push_score
          @score = @doc.header
        elsif header_line? line
          parse_header line
        elsif explicit_lyrics? line
          parse_lyrics line
        elsif explicit_music? line
          parse_music line
        elsif lyrics_line? line
          parse_lyrics line
        else
          parse_music line
        end
      end

      push_score

      return @doc
    end

    private

    def empty?(str)
      str =~ /\A\s*\Z/
    end

    def new_score?(str)
      str =~ /\A\s*\\score/
    end

    def header_start?(str)
      str =~ /\A\s*\\header/
    end

    def strip_comments(str)
      str.sub(/%.*\Z/, '')
    end

    def header_line?(str)
      in_header_block? || @score.lyrics.empty? && @score.music.empty? && str =~ /\w+:\s*./
    end

    EXPLICIT_LYRICS_RE = /\A\\l(yrics)?\s+/

    def explicit_lyrics?(str)
      str =~ EXPLICIT_LYRICS_RE
    end

    EXPLICIT_MUSIC_RE = /\A\\m(usic)?\s+/

    def explicit_music?(str)
      str =~ EXPLICIT_MUSIC_RE
    end

    def lyrics_line?(str)
      str.include?(@syllable_separator) || (contains_unmusical_letters?(str) && !contains_square_brackets?(str))
    end

    def in_header_block?
      @score.is_a? Headers
    end

    def contains_unmusical_letters?(str)
      letters = str.gsub(/[\W\d_]+/, '')
      letters !~ /\A[a-morsvwxz]*\Z/i # incomplete gabc music letters!
    end

    def contains_square_brackets?(str)
      str.include? '['
    end

    def parse_header(str)
      hid, hvalue = str.split(':').collect(&:strip)
      @score.headers[hid] = hvalue
    end

    def parse_lyrics(str)
      # words: split by whitespace not being part of syllable
      # separator
      str
        .sub(EXPLICIT_LYRICS_RE, '')
        .split(/(?<!#{@syllable_separator})\s+(?!#{@syllable_separator})/)
        .each do |word|
        @score.lyrics << Word.new(word.split(/\s*#{@syllable_separator}\s*/))
      end
    end

    def parse_music(str)
      str = str.sub(EXPLICIT_MUSIC_RE, '')

      # music chunks: split by whitespace out of brackets
      StringHelpers.music_split(str).each do |chunk|
        @score.music << chunk
      end
    end

    def push_score
      if @score.is_a?(ParsedScore) && !@score.empty?
        @doc << @score
      end
    end
  end
end
