require 'syllabize/version'
require 'yaml'

module Syllabize

  class Counter
    attr_accessor :word, :exceptions_file

    def initialize(word)
      @word = word
      handle_non_string_input
      load_exceptions
    end

    CONSONANTS = /[bcdfghjklmnpqrstvwxz]/i
    VOWELS = /[aeiou]/i
    LE_VOWEL_SOUND = /((le)\z)|((le(d|r|s))|(ling)\z)/i
    DIPHTHONGS = /ou|ie|oo|oi|ea|ee|ai|ae/i
    Y_AS_VOWEL = /[^yY][yY]/
    RE_VOWEL = /(^re[aeiou])/i

    def count_syllables
      return handle_exceptions if exceptions.keys.include?(word)
      @syllables = count_vowels
      handle_additions
      handle_subtractions
      @syllables <= 1 ? 1 : @syllables
    end

    private

    # for Ruby 1.9
    def __dir__
      File.dirname(__FILE__)
    end unless respond_to?(:__dir__, true)

    def handle_non_string_input
      if !(word.is_a?(String))
        raise ArgumentError.new "#{word} must be a string"
      end
    end

    def load_exceptions
      @exceptions_file = YAML::load_file(File.join(__dir__, 'exceptions.yml'))
    end

    def exceptions
      @exceptions_file['exceptions']
    end

    def handle_exceptions
      exceptions[word.to_s]
    end

    def handle_additions
      @syllables += count_ys_in_vowel_role if contains_non_initial_y?
      if contains_le_vowel_sound? || begins_with_re_vowel? || ends_in_sm?
        @syllables += 1
      end
    end

    def handle_subtractions
      @syllables -= 1 if ends_in_silent_e?
      @syllables -= count_diphthongs if contains_diphthongs?
    end

    def count_vowels
      word.scan(VOWELS).count
    end

    def ends_in_silent_e?
      word.downcase.each_char.to_a[-1] == 'e'
    end

    def contains_le_vowel_sound?
      word.scan(LE_VOWEL_SOUND).any?
    end

    def contains_non_initial_y?
      count_ys_in_vowel_role > 0
    end

    def count_ys_in_vowel_role
      word.scan(Y_AS_VOWEL).size
    end

    def begins_with_re_vowel?
      word.scan(RE_VOWEL).any?
    end

    def contains_diphthongs?
      word.downcase.scan(DIPHTHONGS).any?
    end

    def count_diphthongs
      word.downcase.scan(DIPHTHONGS).count
    end

    def ends_in_sm?
      word.end_with?('sm')
    end
  end

end
