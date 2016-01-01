require 'stringio'

module Gly
  # Converts gly to modern-notation LilyPond
  #
  # expects the 'lygre' gem
  # (which is only an optional dependency of gly)
  class DocumentLyConvertor
    def initialize(document)
      @doc = document
    end

    def convert
      gabcor = GabcConvertor.new
      parser = GabcParser.new
      lilyor = LilypondConvertor.new cadenza: true, version: false

      ly_output = StringIO.new

      @doc.scores.each do |score|
        gabc = gabcor.convert(score).string
        parsed_score = parser.parse gabc
        begin
          ly_output.puts lilyor.convert parsed_score.create_score
        rescue NoMethodError
          ly_output.puts "\\markup{error processing score \\italic{#{score.lyrics.readable}}}"
        end

        ly_output.puts
      end

      out_fname = File.basename(@doc.path) + '.ly'
      File.open(out_fname, 'w') do |fw|
        fw.puts ly_output.string
      end
    end
  end
end