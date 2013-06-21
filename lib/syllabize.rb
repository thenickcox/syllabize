require "syllabize/version"

module Syllabize

  class Counter
    attr_accessor :word

    def initialize(word)
      @word = word
    end

    CONSONANTS = /[bcdfghjklmnpqrstvwxz]/i
    VOWELS = /[aeiou]/i
    CONSONANT_E = /le/i
    DIPHTHONGS = /ou|ie|oo|oi|ea|ee|ai|ae/i

    def count_syllables
      syllables = count_vowels
      syllables -= 1 if ends_in_silent_e?
      syllables -= count_diphthongs if contains_diphthongs?
      syllables += 1 if ends_in_y?
      syllables <= 1 ? 1 : syllables
    end

    private

    def count_vowels
      word.scan(VOWELS).count
    end

    def ends_in_silent_e?
      return false if word.downcase.scan(CONSONANT_E).any?
      word.downcase.each_char.to_a[-1] == 'e'
    end

    def ends_in_y?
      word.downcase.end_with?('y')
    end

    def contains_diphthongs?
      word.downcase.scan(DIPHTHONGS).any?
    end

    def count_diphthongs
      word.downcase.scan(DIPHTHONGS).count
    end
  end

end
